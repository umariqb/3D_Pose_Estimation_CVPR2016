/*
 * hog.hpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#ifndef VISON_FEATURES_LOW_LEVEL_HOG_HPP_
#define VISON_FEATURES_LOW_LEVEL_HOG_HPP_

#include "low_level_feature_extractor.hpp"

#include <opencv2/objdetect/objdetect.hpp>

namespace vision
{
namespace features
{

class Hog : public LowLevelFeatureExtractor
{
public:
    Hog();
    virtual ~Hog();

    virtual void extract_at_extremas(const cv::Mat& image,
             cv::Mat_<float>* descriptors,
             const cv::Mat_<uchar>& mask) const {
      CHECK(false) << "not implemented.";
    }

    virtual cv::Mat_<float> denseExtract(
                const cv::Mat& image,
                std::vector<cv::Point>& descriptor_locations,
                const cv::Mat_<uchar>& mask = cv::Mat_<char>()
                ) const;

    virtual cv::Mat_<float> extract(
                const cv::Mat& image,
                cv::Point& location
                ) const;

    virtual unsigned int descriptorLength() const;

private:
    cv::HOGDescriptor hog_;
    cv::Size hog_blocksize_;
    cv::Size hog_cellsize_;
};

} /* namespace features */
} /* namespace vision */
#endif /* VISON_FEATURES_LOW_LEVEL_HOG_HPP_ */
