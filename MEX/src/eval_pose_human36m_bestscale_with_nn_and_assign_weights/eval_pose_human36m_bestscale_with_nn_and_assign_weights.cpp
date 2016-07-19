/*
 *
 *  Created on: Oct 7, 2012
 *      Author: mdantone
 *
 *      Modified: Umar Iqbal
 *                Andreas Doering
 */



#include <istream>
#include <cassert>
#include <opencv2/opencv.hpp>
#include <boost/progress.hpp>
#include <boost/assign/std/vector.hpp>
#include <boost/format.hpp>
#include <boost/random.hpp>

#include "cpp/utils/timing.hpp"
#include "cpp/learning/forest/forest.hpp"
#include "cpp/learning/pictorial_structure/learn_model_parameter.hpp"
#include "cpp/learning/pictorial_structure/inferenz.hpp"

#include "cpp/learning/pictorial_structure/utils.hpp"

#include "cpp/body_pose/body_part_sample.hpp"
#include "cpp/body_pose/utils.hpp"
#include "cpp/utils/thread_pool.hpp"
#include "cpp/body_pose/clustering/body_clustering.hpp"
#include "cpp/vision/features/feature_channels/feature_channel_factory.hpp"
#include "cpp/body_pose/body_pose_types.hpp"
#include "cpp/vision/image_utils.hpp"

using namespace boost::assign;
using namespace std;
using namespace cv;
using namespace learning::forest::utils;
using namespace learning::forest;
using namespace learning::ps;

using vision::features::feature_channels::FeatureChannelFactory;

typedef BodyPartSample S;

static const int NUM_THREADS = 12;

int main(int argc, char** argv) {
  string experiment_name;
  string config_file;
  string image_index_path = "/tmp/PE-Data/image_index_path_test.txt";
  string nn_dir = "";
  string save_path = "/tmp/";
  string save_file_name = "refined_results.txt";

  int n_clusters = 1;
  int nTrees = 30;
  
  bool save = true;

  LOG(INFO) << argc;
  if(argc > 1)
  {
    experiment_name = argv[1];
  }
  if(argc > 2)
  {
    nTrees = boost::lexical_cast<int>(argv[2]);
  }
  if(argc > 3)
  {
    config_file = argv[3];
  }
  if(argc > 4)
  {
    image_index_path = argv[4];
  }
  if(argc > 5)
  {
    nn_dir = argv[5];
  }
  if(argc > 6)
  {
      save_path = argv[6];
  }
  if(argc > 7)
  {
      save_file_name = argv[7];
  }
  
  string folder = "Human36M/";
  config_file += "/"+folder;
  config_file += "/"+experiment_name;

  ForestParam param;
  vector<Forest<S> >  forests;

  body_pose::BodyPoseTypes pose_type = body_pose::FULL_BODY_J14;
  std::vector<std::string> pair_names;
  pair_names += "head", "neck", "shoulder_l", "shoulder_r", "hip_l", "hip_r", "elbow_l", "hand_l", "elbow_r", "hand_r", "knee_l", "feet_l", "knee_r", "feet_r";

   bool loadBinary = false;
  load_forests(config_file, forests, loadBinary, nTrees, 20, pair_names);
  param = forests[0].getParam();
  param.img_index_path = image_index_path;


  // loading GT
  LOG(INFO)<<"Loading annotation...";
  vector<Annotation> annotations, org_annotations;
  load_annotations(annotations, param.img_index_path);
  load_annotations(org_annotations, param.img_index_path);

  LOG(INFO) << annotations.size() << " found.";

  JointParameter joint_param;
  joint_param.joint_type = learning::ps::CLUSTER_GAUSS;
  joint_param.num_rotations = 5;
  joint_param.use_weights = true ;
  joint_param.weight_alpha = 0.1;
  joint_param.min_sampels = 20;
  joint_param.zero_sum_weights = true;
  vector<JointParameter> joints_param(static_cast<int>(pose_type), joint_param);


  std::vector<int> part_comb_ids;

  part_comb_ids += 1,2,3,4,5;
  string cluster_path = "";
  body_pose::clustering::ClusterMethod method = body_pose::clustering::GLOBAL_POSE;

  FeatureChannelFactory fcf = FeatureChannelFactory();

  boost::filesystem::path test_file(param.img_index_path);

  ofstream outFile, outFileSM;
  string f = save_path;
  string file_name(boost::str(boost::format("%1%%2%") %f %save_file_name));

  if(save) {
    LOG(INFO) <<  "file_name: " << file_name << endl;
    outFile.open(file_name.c_str(), ios::out);
  }

  vector<int> part_ids;
  boost::progress_display show_progress(annotations.size());

  for (int i = 0; i < annotations.size(); ++i, ++show_progress) {

    // load image
    Mat image_org = imread(annotations[i].url,1);
    Mat image;
  
    std::vector<string> strs1;
    boost::split(strs1,annotations[i].url,boost::is_any_of("/"));
    std::vector<string> strs2;
    boost::split(strs2, strs1.back(), boost::is_any_of("."));
    std::string nn_file_name = boost::str(boost::format("%1%/%2%.txt") %nn_dir %strs2.front().c_str());

    vector<Model> models;
    std::vector<Annotation> nearest_neighbours, nearest_neighbours_rescaled;
    load_annotations(nearest_neighbours, nn_file_name);


    for(unsigned int j=0; j<nearest_neighbours.size(); j++){
      Annotation nn = nearest_neighbours[j];
   
      rescale_ann(nn, annotations[i].best_scale);
      nearest_neighbours_rescaled.push_back(nn);

      bool use_separate_body_combinations = true;
      if(!use_separate_body_combinations){
        nearest_neighbours_rescaled[j].cluster_id = 0;
      }
    }

    learning::ps::get_body_model_mixtures(nearest_neighbours_rescaled, models, joints_param, param.norm_size, pose_type);
    CHECK_GT(annotations[i].best_scale, 0);

    resize(image_org, image, cv::Size(0,0), annotations[i].best_scale, annotations[i].best_scale);

    Image image_sample(image, param.features, fcf, false, i);

    vector<Mat_<float> > voting_maps;
      eval_forests(forests,image_sample, voting_maps, 1, true, NUM_THREADS);
      for(int j=0; j < voting_maps.size(); j++) {
        normalize(voting_maps[j], voting_maps[j], 0, 1, CV_MINMAX);
      }
    

    vector<Point> minimas(annotations[i].parts.size(), Point(-1,-1));
    int best_model = -1;
    if(true) {
      learning::ps::inferenz_multiple(models, voting_maps, minimas, best_model, false, image, 0, NUM_THREADS);
    }else{
      Point_<int> anker;
      for(int j=0; j < voting_maps.size(); j++) {
        Point max;
        minMaxLoc(voting_maps[j], 0, 0, 0, &max);
        minimas[j] = max;
      }
    }

    vector<cv::Point> minimas_rescaled = minimas;
    for(int j=0; j < minimas_rescaled.size(); j++) {
      minimas_rescaled[j].x /= annotations[i].best_scale;
      minimas_rescaled[j].y /= annotations[i].best_scale;
    }


    std::vector<Annotation> best_model_nn;
    std::vector<int> model_ids;

    // adding 1 to model ids since in the annotation file they start from 1 instead of 0
    model_ids += (best_model+1);
    keep_ann_of_cluster_ids(nearest_neighbours_rescaled, best_model_nn, model_ids);


    std::vector<float> nn_weights(best_model_nn.size(), 0);
    for(unsigned int j=0; j<best_model_nn.size(); j++){
      Annotation nn = best_model_nn[j];
      for(unsigned int k=0; k<nn.parts.size(); k++){
        nn_weights[j] += voting_maps[k].at<float>(nn.parts[k]);
      }
      nn_weights[j] /= nn.parts.size();
    }

    if(save){
      outFile << annotations[i].url <<" 0 0 0 0 "<<org_annotations[i].cluster_id<<" "<< annotations[i].parts.size() << " ";
      assert( minimas_rescaled.size() == annotations[i].parts.size() );
      for( int j=0; j < minimas_rescaled.size(); j++){
        Point rescaled = minimas_rescaled[j];
        outFile << rescaled.x  << " " << rescaled.y << " ";
      }
      outFile << "-bs "<<annotations[i].best_scale << " ";
      outFile << "-bm "<<best_model<<" ";\
      outFile << "-nnw ";
      for(unsigned int j = 0; j < nn_weights.size(); j++){
        outFile<<nn_weights[j]<<" ";
      }
      outFile<<"\n";
      outFile.flush();

    }else{
      plot(image_org, minimas_rescaled, pose_type);
      LOG(INFO) << "minimas_rescaled: " << ::utils::VectorToString(minimas_rescaled);
    }
  }

  LOG(INFO) << "DONE";
  return 0;
}