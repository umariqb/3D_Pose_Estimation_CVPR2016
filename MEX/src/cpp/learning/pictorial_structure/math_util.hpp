/*
 * math_util.hpp
 *
 *  Created on: Apr 3, 2013
 *      Author: mdantone
 */

#ifndef MATH_UTIL_HPP_
#define MATH_UTIL_HPP_

#include <glog/logging.h>
#include "opencv2/core/core.hpp"
#include <vector>
#include <limits>
#include <boost/limits.hpp>
#include <boost/random.hpp>
#include <boost/numeric/conversion/bounds.hpp>



namespace learning
{
namespace ps
{
namespace utils
{

cv::Rect inline intersect(const cv::Rect r1, const cv::Rect r2) {
  cv::Rect intersection;

  // find overlapping region
  intersection.x = (r1.x < r2.x) ? r2.x : r1.x;
  intersection.y = (r1.y < r2.y) ? r2.y : r1.y;
  intersection.width = (r1.x + r1.width < r2.x + r2.width) ? r1.x + r1.width
      : r2.x + r2.width;
  intersection.width -= intersection.x;
  intersection.height = (r1.y + r1.height < r2.y + r2.height) ? r1.y
      + r1.height : r2.y + r2.height;
  intersection.height -= intersection.y;

  // check for non-overlapping regions
  if ((intersection.width <= 0) || (intersection.height <= 0)) {
    intersection = cvRect(0, 0, 0, 0);
  }
  return intersection;
}


float inline dist(const cv::Point_<float>& a, const cv::Point_<float>&b) {
  return sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
}

// calculate the mean and the mean norm.
void inline calculate_mean(const std::vector<cv::Point_<float> >& offsets,
    cv::Point_<float>* mean, float* mean_norm  ) {
  CHECK_GT(offsets.size(), 0);

  // calculate the mean and the mean norm.
  cv::Point_<float> mean_offset(0,0);
  float m_norm = 0;
  for(int i=0; i < offsets.size(); i++) {
    const cv::Point_<float>& offset = offsets[i];
    m_norm += cv::norm(offset);
    mean_offset += offset;
  }
  mean_offset.x /= offsets.size();
  mean_offset.y /= offsets.size();
  m_norm /= offsets.size();

  *mean = mean_offset;
  *mean_norm = m_norm;
}

int inline get_min_index(const std::vector<cv::Mat_<float> >& scores,
    const cv::Point p, const std::vector<float>& weights ) {
  float min_v = boost::numeric::bounds<double>::highest();
  int min_index = 0;
  for(int i=0; i < scores.size(); i++) {

    float s = scores[i].at<float>(p) + weights[i];
    if(s < min_v ) {
      min_v = s;
      min_index = i;
    }
  }
  return min_index;
}


float inline get_min( const std::vector<cv::Mat_<float> >& scores,
    const std::vector<float>& weights, cv::Point p) {
  float min_v = boost::numeric::bounds<double>::highest();
  for(int i=0; i < scores.size(); i++) {
    if(weights[i] >= 0)
      min_v = MIN(min_v, scores[i].at<float>(p)+ weights[i] );
  }
  return min_v;
}


void inline reduce_min( const std::vector<cv::Mat_<float> >& scores,
    const std::vector<float>& weights,
    cv::Mat_<float>& score) {
  CHECK_EQ(scores.size(), weights.size());
  score = cv::Mat::zeros(scores[0].size(), cv::DataType<float>::type);
  for(int x = 0; x < score.cols; ++x) {
    for(int y = 0; y < score.rows; ++y) {
      const cv::Point p(x,y);
      score.at<float>(p) = get_min( scores, weights,  p);
    }
  }
}

float inline get_min( const std::vector<cv::Mat_<float> >& scores, cv::Point p) {
  float min_v = boost::numeric::bounds<double>::highest();
  for(int i=0; i < scores.size(); i++) {
    min_v = MIN(min_v, scores[i].at<float>(p) );
  }
  return min_v;
}

void inline reduce_min( const std::vector<cv::Mat_<float> >& scores,
    cv::Mat_<float>& score) {
  score = cv::Mat::zeros(scores[0].size(), cv::DataType<float>::type);
  for(int x = 0; x < score.cols; ++x) {
    for(int y = 0; y < score.rows; ++y) {
      const cv::Point p(x,y);
      score.at<float>(p) = get_min( scores, p);
    }
  }
}

void inline reduce_min( const std::vector<cv::Mat_<float> >& scores,
    const std::vector<cv::Mat_<int> > d_xs,
    const std::vector<cv::Mat_<int> > d_ys,
    const std::vector<float>& weights,
    cv::Mat& score,  cv::Mat_<int>& d_x, cv::Mat_<int>& d_y) {
  score = cv::Mat::zeros(scores[0].size(), cv::DataType<float>::type);
  d_x   = cv::Mat::zeros(scores[0].size(), cv::DataType<int>::type);
  d_y   = cv::Mat::zeros(scores[0].size(), cv::DataType<int>::type);
  for(int x = 0; x < score.cols; ++x) {
    for(int y = 0; y < score.rows; ++y) {
      const cv::Point p(x,y);
      int min_index = get_min_index(scores, p, weights);
      score.at<float>(p) = scores[min_index].at<float>(p) + weights[min_index];
      d_x.at<int>(p) = d_xs[min_index].at<int>(p);
      d_y.at<int>(p) = d_ys[min_index].at<int>(p);
    }
  }
}

} // namespace util

} //namespace ps

} //namespace learning



#endif /* MATH_UTIL_HPP_ */
