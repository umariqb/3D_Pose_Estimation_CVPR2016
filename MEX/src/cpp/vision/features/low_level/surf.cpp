/*
 * surf.cpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#include "surf.hpp"
#include <glog/logging.h>
#include <opencv2/imgproc/imgproc.hpp>

namespace vision
{
namespace features
{

Surf::Surf()
{
    surf_ = cv::SURF(0, 1, 1, false, true);
    grid_width_ = 4;
    keypoint_size_ = 2 * grid_width_;
}

/*virtual*/Surf::~Surf()
{
}
/*virtual*/ unsigned int Surf::descriptorLength() const
{
    return surf_.descriptorSize();
}

void Surf::set_grid_spacing(int spacing){
  grid_width_ = spacing;
}

void Surf::getGridLocations(const cv::Size& img_size,
        std::vector<cv::Point>& locations,
        const cv::Mat_<uchar>& mask ) {
  // compute dense grid points
  locations.clear();
  LowLevelFeatureExtractor::generateGridLocations(
          img_size,
          cv::Size(grid_width_, grid_width_),
          keypoint_size_/2,
          keypoint_size_/2,
          locations,
          mask);
}

/*virtual*/ cv::Mat_<float> Surf::denseExtract(
        const cv::Mat& image,
        std::vector<cv::Point>& locations,
        const cv::Mat_<uchar>& mask ) const
{
    // compute dense grid points
    locations.clear();
    LowLevelFeatureExtractor::generateGridLocations(
            image.size(),
            cv::Size(grid_width_, grid_width_),
            keypoint_size_/2,
            keypoint_size_/2,
            locations,
            mask);
    if (locations.size() == 0)
    {
        return cv::Mat_<float>();
    }

    std::vector < cv::KeyPoint > keypoints;
    keypoints.resize(locations.size());
    for( size_t i = 0; i < locations.size(); i++ )
    {
        keypoints[i].pt.x = locations[i].x;
        keypoints[i].pt.y = locations[i].y;
        keypoints[i].size = keypoint_size_;
    }


    cv::Mat_<float> descriptors;
    extract(image, &keypoints, &descriptors);

    return descriptors;
}

/*virtual*/ void Surf::extract(const cv::Mat& image,
            std::vector<cv::KeyPoint>* keypoints,
            cv::Mat_<float>* descriptors) const {
  // convert to gray
  cv::Mat gray = image;
  if (image.type() != CV_8U)
  {
      cv::cvtColor(image, gray, CV_BGR2GRAY);
  }

  // extract the descriptors at the point
  descriptors->create(keypoints->size(), surf_.descriptorSize());
  surf_(gray, cv::Mat(), *keypoints, *descriptors, true);
}

/*virtual*/ void Surf::extract_at_extremas(const cv::Mat& image,
    cv::Mat_<float>* descriptors,
    const cv::Mat_<uchar>& mask) const {

  // convert to gray
  cv::Mat gray = image;
  if (image.type() != CV_8U) {
      cv::cvtColor(image, gray, CV_BGR2GRAY);
  }

//  descriptors->create(keypoints->size(), surf_.descriptorSize());
  std::vector<cv::KeyPoint> keypoints;
  surf_(gray, mask, keypoints, *descriptors, false);
}

cv::Mat_<float> Surf::extract(
     const cv::Mat& image,
     std::vector<cv::KeyPoint>* keypoints ) const {

  cv::Mat_<float> descriptors;
  extract(image, keypoints, &descriptors);
  return descriptors;
}
//==============================================================================

/*virtual*/ void RootSurf::extract(const cv::Mat& image,
            std::vector<cv::KeyPoint>* keypoints_,
            cv::Mat_<float>* descriptors_) const {

  Surf::extract(image, keypoints_, descriptors_);
  cv::Mat_<float>& descriptors = *descriptors_;
  for (int i = 0; i < descriptors.rows; ++i){
    // signed squarerooting
    float* ptr = descriptors.row(i)[0];
    float l2_norm = 0;
    for (int k = 0; k < descriptors.cols; ++k){
      const float v = *ptr;
      // signed sqrt
      // dont try this optimize this statement. compiler does a better job
      if (v < 0) {
        *ptr = -std::sqrt(-v);
        l2_norm += -v;
      }
      else {
        *ptr = std::sqrt(v);
        l2_norm += v;
      }
      ++ptr;
    }
    if (l2_norm > 0.){
      descriptors.row(i) /= std::sqrt(l2_norm);
    }
  }

}




} /* namespace features */
} /* namespace vision */
