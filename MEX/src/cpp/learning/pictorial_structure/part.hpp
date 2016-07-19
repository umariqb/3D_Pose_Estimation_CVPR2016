/*
 * pictorial_structure.hpp
 *
 *  Created on: Jan 21, 2013
 *      Author: mdantone
 */

#ifndef PS_PART_HPP_
#define PS_PART_HPP_
#include <opencv2/opencv.hpp>
#include <vector>
#include <glog/logging.h>
#include "cpp/third_party/PartBasedDetector/src/DistanceTransform.hpp"

namespace learning
{
namespace ps
{

struct Displacement {
  Displacement(cv::Point mean_ = cv::Point(0,0), float var_ = 1, float cluster_size_ = 0) :
    mean(mean_),var(var_), cluster_size(cluster_size_) { }
  cv::Point mean;
  std::vector<cv::Point> shifts;
  std::vector<Quadratic> cost_functions_x;
  std::vector<Quadratic> cost_functions_y;

  cv::Mat kernel;
  double var;
  double dist;
  float cluster_size;
  std::vector<float> weights;
  std::vector<std::vector<float> > pair_weights;

};

class Part {
public:
  Part():part_id(-1), part_name(""), parent(0), norm_factor_forest(1) {};

  Part( int part_id_, std::string part_name_)
        : part_id(part_id_), part_name(part_name_),
          parent(0), norm_factor_forest(1) { };


  cv::Mat get_appeareance_score_copy() const {
    CHECK_NOTNULL(appereance_score.data);
    return appereance_score.clone();
  }

  const cv::Mat* get_appeareance_score() const{
    CHECK_NOTNULL(appereance_score.data);
    return &appereance_score;
  }

  Part* add_child(int part_id = -1, std::string part_name="") {

    if( childeren.size() == 0 ){
      childeren.reserve(2);
    }
    Part p(part_id, part_name);
    p.set_parent(this);
    childeren.push_back(p);
    return &childeren.back();
  }

  void make_leaf();

  void clear(bool recursive = true);

  void set_deformation_cost(Displacement disp_cost);

  void set_voting_map(const cv::Mat_<float>& maps, int do_normalize = -1);

  void transform(const cv::Mat_<float> score_tmp,
      cv::Mat_<float>& score,
      cv::Mat_<int>& score_x,
      cv::Mat_<int>& score_y) const;

  void transform_d(const cv::Mat_<float> score_tmp,
      cv::Mat_<float>& score,
      cv::Mat_<int>& score_x,
      cv::Mat_<int>& score_y) const;


  void set_part_id(int id) {
    part_id = id;
  }
  void set_name(std::string name) {
    part_name = name;
  }

  int num_orientations() const {
    return displacement.shifts.size();
  }

  cv::Point get_offset(int i) const {
    return displacement.shifts[i];
  }

  Quadratic get_cost_function_x(int i) const {
    return displacement.cost_functions_x[i];
  }

  Quadratic get_cost_function_y(int i) const {
    return displacement.cost_functions_y[i];
  }

  std::vector<std::vector<float> > get_pairwise_weights() const {
    return displacement.pair_weights;
  }

  virtual ~Part(){};

  const Part* get_parent() const;
  const Part* get_child(int i) const;
  void set_parent(Part* parent_);


private:
  int part_id;
  std::string part_name;

  Part* parent;
  std::vector<Part> childeren;
  Displacement displacement;

  cv::Mat_<float> appereance_score;

  float norm_factor_forest;

};

} //namespace ps

} //namespace learning

#endif /* PS_PART_HPP_ */
