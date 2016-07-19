/*
 * Sift.cpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#include "root_sift.hpp"

#include <cmath>

#include <glog/logging.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <boost/shared_ptr.hpp>

#include "cpp/third_party/vlfeat/vl/dsift.h"

namespace vision
{
namespace features
{

struct VlFree {
  void operator()(void* x){
    if (x != NULL){
      vl_free(x);
    }
  }
};

struct VlDsiftDelete{
  void operator()(void* x){
    if (x != NULL){
      vl_dsift_delete((VlDsiftFilter*)x);
    }
  }
};


RootSift::RootSift()
{
}

/*virtual*/RootSift::~RootSift()
{
}
/*virtual*/ unsigned int RootSift::descriptorLength() const
{
  return 128;
}



/*virtual*/ cv::Mat_<float> RootSift::denseExtract(
    const cv::Mat& image,
    std::vector<cv::Point>& locations,
    const cv::Mat_<uchar>& mask ) const
{

  const int step = 4;

  locations.clear();

  CHECK(mask.data == NULL) << "rootsift does not support masks";

  // convert to gray
  cv::Mat gray = image;
  if (image.type() != CV_8U)
  {
    cv::cvtColor(image, gray, CV_BGR2GRAY);
  }

  // convert to float image
  cv::Mat_<float> float_img;
  gray.convertTo(float_img, CV_32FC1, 1./255);

  // from https://github.com/vlfeat/vlfeat/blob/master/apps/recognition/getDenseSIFT.m
  VlDsiftDescriptorGeometry geom ;
  geom.numBinX = 4 ;
  geom.numBinY = 4 ;
  geom.numBinT = 8 ;
  geom.binSizeX = 8 ;
  geom.binSizeY = 8 ;

  boost::shared_ptr<VlDsiftFilter> dsift(
      vl_dsift_new(gray.cols, gray.rows),
      VlDsiftDelete());
  vl_dsift_set_geometry(dsift.get(), &geom) ;
  vl_dsift_set_steps(dsift.get(), step, step) ;
  vl_dsift_set_flat_window(dsift.get(), false) ; // opt_fast

  const int num_features = vl_dsift_get_keypoint_num (dsift.get());
  const int descriptor_dims = vl_dsift_get_descriptor_size(dsift.get());
  DCHECK_EQ(descriptorLength(), descriptor_dims);
  geom = *vl_dsift_get_geometry(dsift.get());

  vl_dsift_process(dsift.get(), float_img[0]) ;

  const VlDsiftKeypoint* frames = vl_dsift_get_keypoints(dsift.get());
  const float* descrs = vl_dsift_get_descriptors(dsift.get()) ;

  // copy
  locations.resize(num_features);
  for (int idx = 0; idx < num_features; ++idx){
    cv::Point& p = locations[idx];
    p.x = frames[idx].x;
    p.y = frames[idx].y;
  }
  cv::Mat_<float> descriptors(num_features, descriptor_dims);
  float* out_ptr = descriptors[0];
  float const* src_ptr = descrs;
  for (int i = 0; i < descriptor_dims * num_features; ++i){
    out_ptr[i] = std::sqrt(std::min(512.0f * src_ptr[i], 255.0f));
  }
  // rootsift
  for (int r = 0; r < descriptors.rows; ++r){
    const double l2_norm = cv::norm(descriptors.row(r), cv::NORM_L2);
    if (l2_norm != 0){
      descriptors.row(r) /= l2_norm;
    }
  }

  return descriptors;
}

/*virtual*/ void RootSift::extract_at_extremas(const cv::Mat& image,
    cv::Mat_<float>* descriptors,
    const cv::Mat_<uchar>& mask) const {

  CHECK(false);
}

//==============================================================================





} /* namespace features */
} /* namespace vision */
