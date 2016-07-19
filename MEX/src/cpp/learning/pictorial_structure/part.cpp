/*
 * pictorial_structure.cpp
 *
 *  Created on: Jan 21, 2013
 *      Author: mdantone
 */

#include <glog/logging.h>
#include <boost/thread.hpp>
#include <boost/random.hpp>
#include "cpp/utils/thread_pool.hpp"
#include "cpp/learning/pictorial_structure/part.hpp"
#include "cpp/learning/pictorial_structure/utils.hpp"
#include "cpp/learning/pictorial_structure/math_util.hpp"
#include "cpp/learning/forest/utils/eval_utils.hpp"
using namespace std;
using namespace cv;


namespace learning
{
namespace ps
{

const Part* Part::get_child(int i) const {
  return &childeren[i];
}

void Part::set_parent(Part* parent_) {
  parent = parent_;
}

const Part* Part::get_parent() const {
  return parent;
}

void Part::make_leaf() {
  childeren.clear();
//  displacement.shifts.clear();
//  displacement.cost_functions_x.clear();
//  displacement.cost_functions_y.clear();
//  displacement.pair_weights.clear();
//  displacement.weights.clear();
}


void Part::clear(bool recursive) {
  if( appereance_score.data != NULL)
    appereance_score.release();
  for( int i = 0; i < childeren.size() && recursive; i++){
    childeren[i].clear(recursive);
  }
}

void Part::set_deformation_cost(Displacement disp_cost) {
  displacement = disp_cost;
}

void Part::set_voting_map(const Mat_<float>& map, int do_normalize) {
  appereance_score = map.clone();
  appereance_score *= -1;

//  if(do_normalize < 0 ) {
//    // no normalization
//  }else if(do_normalize == 0) {
//    normalize(appereance_score, appereance_score, 0, 1, CV_MINMAX);
//  }else if(do_normalize == 1){
//    appereance_score /= norm_factor_forest;
//  }
}

void do_shifts_and_dt(const cv::Mat_<float>& score,
          const vector<cv::Point>& shifts,
          const vector<Quadratic>& cost_functions_x,
          const vector<Quadratic>& cost_functions_y,
          const std::vector<float>& weights,
          cv::Mat_<float>& score_out,
          cv::Mat_<int>& d_x_out,
          cv::Mat_<int>& d_y_out) {


  vector<Mat_<float> > scores(shifts.size());
  vector<Mat_<int> > d_xs(shifts.size());
  vector<Mat_<int> > d_ys(shifts.size());


  Mat_<int> Ix_dt, Iy_dt;


  DistanceTransform<float> dt_;
  Mat_<float> s = Mat_<float>(score).clone();

  for(int i =0; i < shifts.size(); i++) {
    const Point& shift = shifts[i];

    const Quadratic& fx = cost_functions_x[i];
    const Quadratic& fy = cost_functions_y[i];

    dt_.compute(s, fx, fy, shift,
        scores[i], d_xs[i], d_ys[i]);
  }

  learning::ps::utils::reduce_min(scores, d_xs, d_ys, weights, score_out, d_x_out, d_y_out );
}


void Part::transform(const Mat_<float> score_tmp,
    Mat_<float>& score,
    Mat_<int>& score_x,
    Mat_<int>& score_y ) const {

  // distance transform
  do_shifts_and_dt(score_tmp,
      displacement.shifts,
      displacement.cost_functions_x,
      displacement.cost_functions_y,
      displacement.weights,
      score,
      score_x,
      score_y);
}

void Part::transform_d(const cv::Mat_<float> score_tmp,
      cv::Mat_<float>& score,
      cv::Mat_<int>& score_x,
      cv::Mat_<int>& score_y) const {

  unsigned int nClusters = displacement.shifts.size();
  std::vector<cv::Point> shifts_d(nClusters);
  std::vector<Quadratic> cost_functions_x_d(nClusters);
  std::vector<Quadratic> cost_functions_y_d(nClusters);

  for(unsigned int i = 0; i < nClusters; i++){
    shifts_d[i] = cv::Point(1-displacement.shifts[i].x, 1-displacement.shifts[i].y);
    Quadratic fx = displacement.cost_functions_x[i];
    Quadratic fy = displacement.cost_functions_y[i];
    cost_functions_x_d[i] = Quadratic(fx.a, -1*fx.b);
    cost_functions_y_d[i] = Quadratic(fy.a, -1*fy.b);
  }

  //distance transform
  do_shifts_and_dt(score_tmp, shifts_d,
                   cost_functions_x_d,
                   cost_functions_y_d,
                   displacement.weights,
                   score,
                   score_x,
                   score_y
                   );
}


} //namespace ps

} //namespace learning
