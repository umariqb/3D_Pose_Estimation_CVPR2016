/*
 * utils.hpp
 *
 *  Created on: Jan 21, 2013
 *      Author: mdantone
 */

#ifndef PS_UTILS_HPP_
#define PS_UTILS_HPP_

#include <glog/logging.h>
#include "opencv2/core/core.hpp"
#include "cpp/learning/pictorial_structure/learn_model_parameter.hpp"
#include "cpp/learning/pictorial_structure/part.hpp"

#include <vector>

namespace learning
{
namespace ps
{
namespace utils
{

float pos_angle( float a );

float get_angle(cv::Point point );

cv::Point_<float> get_point(float angle, int norm );

// returns offset normalized with respect to parent
cv::Point get_offset_normalized( cv::Point part,
    cv::Point parent, cv::Point grand );


void get_orient_hist( const std::vector< cv::Point_<float> >& offsets,
    const std::vector<cv::Point>& shifts,
    std::vector<float>& weights, bool debug);

void transform_offsets( const std::vector<cv::Point_<float> >& offsets,
           std::vector<cv::Point_<float> >& offsets_transformed, bool plot = false);


void estimate_covariance_matrix( const std::vector<cv::Point_<float> >& offsets,
    cv::Mat& covar, cv::Mat& mean);

void visualize_clusters(const std::vector<cv::Point_<float> >& offsets,
    cv::Mat centers, cv::Mat best_labels, int i_part = 0 );


void visualize_offsets(const std::vector<cv::Point_<float> >& offsets);



bool get_displacement_cost(
    const std::vector< std::vector<cv::Point> >& annotations,
    const std::vector<int>& parents,
    std::vector<Displacement>& displacements,
    std::vector<JointParameter> params,
    std::vector<double> weights = std::vector<double>());


} // namespace util

} //namespace ps

} //namespace learning



#endif /* PS_UTILS_HPP_ */
