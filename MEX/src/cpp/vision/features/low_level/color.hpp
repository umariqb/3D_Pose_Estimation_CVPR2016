/*
 * color.hpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#ifndef VISON_FEATURES_LOW_LEVEL_COLOR_HPP_
#define VISON_FEATURES_LOW_LEVEL_COLOR_HPP_

#include "low_level_feature_extractor.hpp"

namespace vision
{
namespace features
{
class Color : public LowLevelFeatureExtractor
{
public:
    Color();
    virtual ~Color();

    virtual void extract_at_extremas(const cv::Mat& image,
             cv::Mat_<float>* descriptors,
             const cv::Mat_<uchar>& mask) const {
      CHECK(false) << "not implemented.";
    }

    virtual cv::Mat_<float> denseExtract(
                const cv::Mat& image,
                std::vector<cv::Point>& descriptor_locations,
                const cv::Mat_<uchar>& mask = cv::Mat_<uchar>()
                ) const;

    cv::Mat_<float> denseExtract(
                const cv::Mat& image,
                std::vector<cv::Point>& descriptor_locations,
                bool do_cache) const;

    cv::Mat_<float> denseExtractMasked(
                const cv::Mat& image,
                std::vector<cv::Point>& descriptor_locations,
                const cv::Mat_<uchar>& mask) const;

    virtual unsigned int descriptorLength() const;

private:

};

} /* namespace features */
} /* namespace vision */
#endif /* VISON_FEATURES_LOW_LEVEL_COLOR_HPP_ */
