/*
 * inferenz.hpp
 *
 *  Created on: Mar 24, 2013
 *      Author: mdantone
 */

#ifndef INFERENZ_HPP_
#define INFERENZ_HPP_

#include "cpp/learning/pictorial_structure/model.hpp"

namespace learning
{
namespace ps
{

class Inferenz {
public:

  Inferenz(Model* m) : model(m), _inferenz_score(0),min_computed(false)  {
    int n_parts = model->get_num_parts();

    // scores with the message recieved from the child (parent_score + distance_transform(child_score))
    scores.resize(n_parts);
    // scores without the message that a child sends to its parent
    scores_without_dt.resize(n_parts);
    score_src_x.resize(n_parts);
    score_src_y.resize(n_parts);

  };

  float compute_min(int part_id = 0);

  void compute_arg_min( std::vector<cv::Point_<int> >& min_locations,
      int part_id = 0) const;

  void non_max_supression( std::vector<std::vector<cv::Point_<int> > >& locations,
      int n_locations);

  float get_score() const {
    return _inferenz_score;
  }

  bool min_is_computed() const{
    return min_computed;
  }

protected:
  Model* model;
  float _inferenz_score;
  std::vector<cv::Mat_<float> > scores;
  std::vector<cv::Mat_<float> > scores_without_dt;
  std::vector<cv::Mat_<int> > score_src_x;
  std::vector<cv::Mat_<int> > score_src_y;
  bool min_computed;
};


float inferenz_multiple(std::vector<Model> models,
    const std::vector<cv::Mat_<float> >& apperance_scores,
    std::vector<cv::Point_<int> >& min_locations, bool debug = false,
    const cv::Mat& img = cv::Mat(), float weight = 0.0, int num_threads = 0);

float inferenz_multiple(std::vector<Model> models,
    const std::vector<cv::Mat_<float> >& apperance_scores,
    std::vector<cv::Point_<int> >& min_locations, int& min_index, bool debug = false,
    const cv::Mat& img = cv::Mat(), float weight = 0.0, int num_threads = 0);

float inferenz_multiple_diff_votmap(std::vector<std::vector<Model> > models,
      const std::vector< std::vector<cv::Mat_<float> > >& apperance_scores,
      std::vector<int> indexes,
      std::vector<cv::Point_<int> >& min_locations, bool debug = false, const cv::Mat& img = cv::Mat(), float weight = 0.0, int num_threads = 0);


} /* namespace ps */
} /* namespace learning */

#endif /* INFERENZ_HPP_ */
