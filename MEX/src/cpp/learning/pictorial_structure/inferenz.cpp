/*!
 * inferenz.cpp
 *
 *  Created on: Mar 24, 2013
 *  @Author: mdantone
 *
 *  @Modified by: uiqbal
 *  Date:06.06.2014
 */
#include "cpp/learning/pictorial_structure/inferenz.hpp"
#include "cpp/learning/pictorial_structure/utils.hpp"
#include "cpp/learning/pictorial_structure/math_util.hpp"
#include "cpp/learning/pictorial_structure/learn_model_parameter.hpp"

#include "cpp/utils/thread_pool.hpp"
#include "cpp/utils/system_utils.hpp"

#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;
namespace learning
{
namespace ps
{

  float Inferenz::compute_min(int part_id) {
    CHECK_GT(scores.size(), part_id);
    const Part* part = model->get_part(part_id);
    vector<int> child_ids = model->get_children_ids(part_id);
    Mat_<float> score_tmp = part->get_appeareance_score_copy();

    // these scores are already be shifted
    for( int i = 0; i < child_ids.size(); i++){
      int child_id = child_ids[i];
      compute_min(child_id);
      add(score_tmp, scores[child_id], score_tmp);
    }

    // saving scores without dt to compute the min_marginals later on
    scores_without_dt[part_id] = score_tmp.clone();

    bool is_root = !model->has_parent(part_id);
    if(!is_root) {
      part->transform(score_tmp,
          scores[part_id],
          score_src_x[part_id],
          score_src_y[part_id]);
    }else{
      scores[part_id] = score_tmp.clone();
    }

    // check if root
    if( is_root ) {
      min_computed = true;
      double min;
      minMaxLoc(scores[0], &min, 0 , 0, 0);
      _inferenz_score =  static_cast<float>(min);
      return static_cast<float>(min);
    }else{
      return 0;
    }
  }

  void Inferenz::compute_arg_min( vector<Point_<int> >& min_locations,
                                  int part_id) const {
    CHECK_NOTNULL(scores[part_id].data);
    CHECK_EQ(min_locations.size(), scores.size());

    // the anker point is the location of the parent
    // and for the root the anker point is the maximum of the score mat
    Point_<int> min_loc;
    if(model->has_parent(part_id)) {
      Point anker;
      anker = min_locations[ model->get_parent_id(part_id) ];
      CHECK_NE(anker.x, -1);
      min_loc.x = score_src_x[part_id](anker);
      min_loc.y = score_src_y[part_id](anker);
    }else{
      minMaxLoc(scores[part_id], 0, 0, &min_loc, 0);
      CHECK_NE(min_loc.x, -1);
    }

    min_locations[part_id] = min_loc;

    // recursive call
    vector<int> child_ids = model->get_children_ids(part_id);
    for(int i=0; i < child_ids.size(); i++) {
      compute_arg_min( min_locations, child_ids[i]);
    }
  }

  void Inferenz::non_max_supression( vector<vector<Point_<int> > >& locations,
      int n_locations) {

    Mat score = scores[0].clone();
    normalize(score, score, 0, 1, CV_MINMAX);
    vector<int> child_ids = model->get_children_ids(0);
    int n_parts = model->get_num_parts();
    for(int i=0; i < n_locations; i++) {
      vector<Point_<int> >l(n_parts, cv::Point(-1,-1));

      // get maximum
      Point_<int> anker;
      minMaxLoc(score, 0, 0, &anker, 0);

      l[0].x = score_src_x[0](anker);
      l[0].y = score_src_y[0](anker);

      //TODO: The following for loop does not seems to be
      // neccesary since compute_arg_min has recursive calls
      for(int i=0; i < child_ids.size(); i++) {
        compute_arg_min( l, child_ids[i]);
      }
      locations.push_back(l);

      int patch_size = 20;
      Rect box(anker.x - patch_size/2, anker.y - patch_size/2, patch_size, patch_size);
      Rect inter = utils::intersect(box, Rect(0,0,score.cols,score.rows));
      score(inter).setTo(cv::Scalar(0));
    }
  }



  float inferenz_multiple(std::vector<Model> models,
      const std::vector<cv::Mat_<float> >& apperance_scores,
      std::vector<cv::Point_<int> >& min_locations, bool debug, const Mat& img, float weight, int num_threads) {

    // seting voting maps;
    vector<Inferenz> solvers;
    for(int j=0; j < models.size(); j++) {
      models[j].set_voting_maps(apperance_scores, -1);
      solvers.push_back(Inferenz(&models[j]) );
    }

    // multithreaded inferenz
    if(num_threads < 1){
        num_threads = ::utils::system::get_available_logical_cpus();
    }

    if(num_threads > 1 && models.size() > 1 && !debug) {
      boost::thread_pool::executor e(num_threads);
      for(int i=0; i < solvers.size(); i++) {
        e.submit(boost::bind(&Inferenz::compute_min, &solvers[i], 0 ));
      }
      e.join_all();

    // singlethreaded inferenz
    }else{
      for(int i=0; i < solvers.size(); i++) {
        solvers[i].compute_min();
      }
    }

    // check min
    float min_inferenz = boost::numeric::bounds<double>::highest();
    int min_index = 0;
    for(int i=0; i < solvers.size(); i++) {
      // logarithmic weighting
      float w = -log(models[i].get_weight()) * weight;
      float inferenz = solvers[i].get_score() + w;

      //linear weighting
//      float w = weight*models[i].get_weight();
//      float inferenz = solvers[i].get_score();
//      inferenz = (inferenz < 0) ? inferenz * w : inferenz * (1-w);

      if(debug){
        LOG(INFO)<<"weight = "<<w<<"\t\tinferenz = "<<solvers[i].get_score()<<"\t\ttotal "<<inferenz;
      }

      if( inferenz < min_inferenz ) {
        min_inferenz = inferenz;
        min_index = i;
      }
    }
    //LOG(INFO)<<"min_index = "<<min_index;

    if(debug and solvers.size() > 1) {
      for(int i=0; i < solvers.size(); i++) {
        solvers[i].compute_arg_min(min_locations);
        Mat p = img.clone();
        //plot( p, min_locations);
      }
    }
    solvers[min_index].compute_arg_min(min_locations);

    return min_inferenz;
  }


  float inferenz_multiple(std::vector<Model> models,
      const std::vector<cv::Mat_<float> >& apperance_scores,
      std::vector<cv::Point_<int> >& min_locations, int& min_index, bool debug, const Mat& img, float weight, int num_threads) {

    // seting voting maps;
    vector<Inferenz> solvers;
    for(int j=0; j < models.size(); j++) {
      models[j].set_voting_maps(apperance_scores, -1);
      solvers.push_back(Inferenz(&models[j]) );
    }

    // multithreaded inferenz
    if(num_threads < 1){
        num_threads = ::utils::system::get_available_logical_cpus();
    }

    if(num_threads > 1 && models.size() > 1 && !debug) {
      boost::thread_pool::executor e(num_threads);
      for(int i=0; i < solvers.size(); i++) {
        e.submit(boost::bind(&Inferenz::compute_min, &solvers[i], 0 ));
      }
      e.join_all();

    // singlethreaded inferenz
    }else{
      for(int i=0; i < solvers.size(); i++) {
        solvers[i].compute_min();
      }
    }

    // check min
    float min_inferenz = boost::numeric::bounds<double>::highest();
    min_index = 0;
    for(int i=0; i < solvers.size(); i++) {
      // logarithmic weighting
      float w = -log(models[i].get_weight()) * weight;
      float inferenz = solvers[i].get_score() + w;

      //linear weighting
//      float w = weight*models[i].get_weight();
//      float inferenz = solvers[i].get_score();
//      inferenz = (inferenz < 0) ? inferenz * w : inferenz * (1-w);

      if(debug){
        LOG(INFO)<<"weight = "<<w<<"\t\tinferenz = "<<solvers[i].get_score()<<"\t\ttotal "<<inferenz;
      }

      if( inferenz < min_inferenz ) {
        min_inferenz = inferenz;
        min_index = i;
      }
    }
    //LOG(INFO)<<"min_index = "<<min_index;

    if(debug and solvers.size() > 1) {
      for(int i=0; i < solvers.size(); i++) {
        solvers[i].compute_arg_min(min_locations);
        Mat p = img.clone();
        //plot( p, min_locations);
      }
    }
    solvers[min_index].compute_arg_min(min_locations);

    return min_inferenz;
  }



//void get_attr_wise_conditional_voting_map_mt(const Image* sample,
//        const Forest<BodyPartSample>* f, std::vector<cv::Mat_<float> >* voting_maps,
//          cv::Rect bbox, int stepsize, bool blur) {
//  get_attr_wise_conditional_voting_map( *sample, *f, *voting_maps, bbox, stepsize,blur, false, cv::Rect(0,0,0,0));
//}
//
//

  void inferenz_multiple_mt(std::vector<Model>* models,
      const std::vector<cv::Mat_<float> >* apperance_scores,
      std::vector<cv::Point_<int> >* min_locations, bool debug, const Mat* img, float weight, int num_threads, float* score){

      *score = learning::ps::inferenz_multiple(*models, *apperance_scores, *min_locations, debug, *img, weight, num_threads);

  }

  float inferenz_multiple_diff_votmap(std::vector<std::vector<Model> > models,
      const std::vector< std::vector<cv::Mat_<float> > >& apperance_scores,
      std::vector<int> indexes,
      std::vector<cv::Point_<int> >& min_locations, bool debug, const Mat& img, float weight, int num_threads) {

    std::vector<std::vector<cv::Point_<int> > > min_locations_tmp(apperance_scores.size());
    std::vector<float> scores(apperance_scores.size());
    float min_score = std::numeric_limits<float>::max();

    if(num_threads < 1){
        num_threads = ::utils::system::get_available_logical_cpus();
    }

    num_threads /= indexes.size();

    if(num_threads > 1 && apperance_scores.size() > 1 && !debug) {
      boost::thread_pool::executor e(num_threads);
      for(int i=0; i < apperance_scores.size(); i++) {
        min_locations_tmp[i].resize(apperance_scores[i].size(), Point(-1,-1));
        e.submit(boost::bind(&inferenz_multiple_mt, &models[indexes[i]], &apperance_scores[i], &min_locations_tmp[i], debug, &img, weight, num_threads, &scores[i]));
      }
      e.join_all();

      for(int i=0; i<apperance_scores.size(); i++){
        if(scores[i] < min_score){
          min_score = scores[i];
          min_locations = min_locations_tmp[i];
        }
      }

    // singlethreaded inferenz
    }else{
      for(int i=0; i < apperance_scores.size(); i++) {
          min_locations_tmp[i].resize(apperance_scores[i].size(), Point(-1,-1));
          float score = inferenz_multiple(models[indexes[i]], apperance_scores[i], min_locations_tmp[i], debug, img, weight, num_threads);
          if(score < min_score){
            min_score = score;
            min_locations = min_locations_tmp[i];
          }
      }
    }
    return min_score;
  }

} /* namespace ps */
} /* namespace learning */
