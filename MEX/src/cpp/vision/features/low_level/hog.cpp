/*
 * hog.cpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#include "hog.hpp"
namespace vision
{
namespace features
{

Hog::Hog() : hog_blocksize_(8, 8), hog_cellsize_(4, 4) {
    hog_ = cv::HOGDescriptor(hog_blocksize_, hog_blocksize_, hog_cellsize_, hog_cellsize_, 9);
}
/*virtual*/Hog::~Hog()
{
}
/*virtual*/ unsigned int Hog::descriptorLength() const
{
    return hog_.getDescriptorSize();
}
/*virtual*/cv::Mat_<float> Hog::denseExtract(
        const cv::Mat& image,
        std::vector<cv::Point>& locations,
        const cv::Mat_<uchar>& mask )const
{
    const size_t feature_length = hog_.getDescriptorSize();

    // compute dense grid points
    locations.clear();
    LowLevelFeatureExtractor::generateGridLocations(
            image.size(),
            hog_cellsize_,
            hog_cellsize_.height,
            hog_cellsize_.width,
            locations,
            mask);
    if (locations.size() == 0)
    {
        return cv::Mat_<float>();
    }

    // extract features
    std::vector<float> descriptors;
    hog_.compute(image, descriptors, cv::Size(), cv::Size(), locations);

    // copy features to output
    cv::Mat_<float> descriptor_mat(descriptors, true);
    std::size_t extracted_features_count = descriptors.size() / feature_length;
    descriptor_mat = descriptor_mat.reshape(0, extracted_features_count);
    assert(descriptor_mat.rows == extracted_features_count);

    return descriptor_mat;
}


cv::Mat_<float> Hog::extract(
            const cv::Mat& image,
            cv::Point& location
            ) const {

  std::vector<float> descriptors;
  std::vector<cv::Point> locations;
  locations.push_back(location);
  hog_.compute(image, descriptors, cv::Size(), cv::Size(), locations);

  cv::Mat_<float> descriptor_mat(descriptors, true);
  std::size_t extracted_features_count = descriptors.size() / hog_.getDescriptorSize();
  descriptor_mat = descriptor_mat.reshape(0, locations.size());
  assert(descriptor_mat.cols == extracted_features_count);
  assert(descriptor_mat.rows == 1);

  return descriptor_mat;


}

} /* namespace features */
} /* namespace vision */
