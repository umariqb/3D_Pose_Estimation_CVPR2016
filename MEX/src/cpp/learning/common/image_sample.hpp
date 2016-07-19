/*
 * image_sample.hpp
 *
 *  Created on: May 3, 2011
 *      Author: Matthias Dantone
 */

#ifndef LEARNING_COMMON_IMAGE_SAMPLE_HPP_
#define LEARNING_COMMON_IMAGE_SAMPLE_HPP_

#include <iostream>
#include <glog/logging.h>
#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "cpp/vision/features/feature_channels/feature_channel_factory.hpp"


namespace learning {
namespace common {

class Image {
public:
  Image(): _useIntegral(false), _id(-1), _global_attr_label(-1) { };

  Image(const cv::Mat img,
      std::vector<int> features,
      const vision::features::feature_channels::FeatureChannelFactory& fcf,
      bool useIntegral= false, int id = 0) : _useIntegral(useIntegral), _id(id), _global_attr_label(-1)
      {
        init(img, features, &fcf, useIntegral, id);
      }

  Image(const cv::Mat img,
      std::vector<int> features,
      const vision::features::feature_channels::FeatureChannelFactory& fcf,
      bool useIntegral, int id, int global_attr_label):
          _useIntegral(useIntegral), _id(id), _global_attr_label(global_attr_label)
      {
                init(img, features, &fcf, useIntegral, id);

      }

  Image(const cv::Mat img,
      std::vector<int> features,
      bool useIntegral_ = false, int id_ = 0) : _useIntegral(useIntegral_), _id(id_), _global_attr_label(-1)
      {
        vision::features::feature_channels::FeatureChannelFactory fcf = vision::features::feature_channels::FeatureChannelFactory();
        extract_channels(img, feature_channels, features, _useIntegral, &fcf);
      }

  void init(const cv::Mat img,
      const std::vector<int>& features,
      const vision::features::feature_channels::FeatureChannelFactory* fcf,
      bool useIntegral, int id) {

      _useIntegral = useIntegral;
      _id = id;
      extract_channels(img, feature_channels, features, _useIntegral, fcf);
  }

  // Extract features from image
  void extract_channels(const cv::Mat& img,
      std::vector<cv::Mat>& vImg,
      std::vector<int> features,
      bool useIntegral,
      const vision::features::feature_channels::FeatureChannelFactory* fcf) const {
    cv::Mat img_gray;
    if (img.channels() == 1) {
      img_gray = img;
    } else {
      cvtColor(img, img_gray, CV_RGB2GRAY);
    }

    // check if norm in feature-channels
    for(unsigned int i=0; i < features.size(); i++) {
      if( features[i] == 5 ) {

        // set back to 0
        features[i] = 0;
        cv::equalizeHist(img_gray, img_gray);
      }
    }

    sort(features.begin(), features.end());
    for (unsigned int i = 0; i < features.size(); i++) {
      fcf->extractChannel(features[i], useIntegral, img_gray, img, vImg);
    }

  }

  int width() const {
    CHECK_GT(num_feature_channels(), 0 );
    return feature_channels[0].cols;
  }

  int height() const {
    CHECK_GT(num_feature_channels(), 0 );
    return feature_channels[0].rows;
  }

  int num_feature_channels() const {
    return feature_channels.size();
  }

  void show() const {
    CHECK_GT(num_feature_channels(), 0 );
    cv::imshow("Image Sample", feature_channels[0]);
    cv::waitKey(0);
  }

  void display_feature_channels() const {
    for(unsigned int i=0; i < feature_channels.size(); i++) {
      LOG(INFO) << i << ": " << feature_channels.size() << std::endl;
      cv::imshow("X", feature_channels[i]);
      cv::waitKey(0);
    }
  }

  const std::vector<cv::Mat>& get_feature_channels() const {
    return feature_channels;
  }

  const cv::Mat& get_feature_channel(int i) const {
    assert(num_feature_channels() > i );
    return feature_channels[i];
  }

  std::vector<cv::Mat>& get_feature_channels() {
    return feature_channels;
  }

  cv::Mat& get_feature_channel(int i) {
    CHECK_GT(num_feature_channels(), i );
    return feature_channels[i];
  }

  void add_feature_channel(cv::Mat c) {
    feature_channels.push_back(c);
  }

  void del_feature_channels() {
    feature_channels.clear();
  }


  bool is_integral_image() const {
    return _useIntegral;
  }

  int inline get_global_attr_label() const{
    return _global_attr_label;
  }

  void set_global_attr_label(int label){
    _global_attr_label = label;
  }


  virtual ~Image() {
    for (unsigned int i = 0; i < feature_channels.size(); i++)
      feature_channels[i].release();
    feature_channels.clear();
  }

private:
  std::vector<cv::Mat> feature_channels;
  bool _useIntegral;
  int _id;
  int _global_attr_label;
};


class ImageSample {
public:
  ImageSample(): img(0){}

  ImageSample(const Image* img_, cv::Rect roi_ ):
    roi(roi_), img(img_)  {

    CHECK_GE(roi_.x , 0);
    CHECK_GE(roi_.y , 0);
    CHECK_GT(roi_.width , 0);
    CHECK_GT(roi_.height , 0);

    CHECK_LE(roi_.width  + roi_.x, img->width() );
    CHECK_LE(roi_.height + roi_.y, img->height() );
  }

  const Image* get_image() const {
    return img;
  }

  const std::vector<cv::Mat>& get_images() const {
    return img->get_feature_channels();
  }

  const cv::Rect get_roi() const {
    return roi;
  }

  const cv::Mat& get_feature_channel(int i) const {
    return img->get_feature_channel(i);
  }

  const std::vector<cv::Mat>& get_feature_channels() const {
    return img->get_feature_channels();
  }

  bool is_integral_image() const {
    return img->is_integral_image();
  }

  ~ImageSample() { }

  cv::Rect roi;
private:
  const Image* img;
};

} //namespace common
} //namespace learning

#endif /* LEARNING_COMMON_IMAGE_SAMPLE_HPP_ */
