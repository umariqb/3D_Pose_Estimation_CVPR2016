/*
 * sift.hpp
 *
 *  Created on: Feb 19, 2014
 *      Author: lbossard
 */

#ifndef VISON_FEATURES_LOW_LEVEL_SIFT_HPP_
#define VISON_FEATURES_LOW_LEVEL_SIFT_HPP_

#include "low_level_feature_extractor.hpp"
namespace vision
{
namespace features
{

class RootSift: public LowLevelFeatureExtractor
{
public:

    RootSift();
    virtual ~RootSift();

    virtual void extract_at_extremas(const cv::Mat& image,
                             cv::Mat_<float>* descriptors,
                             const cv::Mat_<uchar>& mask = cv::Mat_<char>()) const;

    virtual cv::Mat_<float> denseExtract(
                const cv::Mat& image,
                std::vector<cv::Point>& descriptor_locations,
                const cv::Mat_<uchar>& mask = cv::Mat_<char>()
                ) const;



    virtual unsigned int descriptorLength() const;


private:

};


} /* namespace features */
} /* namespace vision */
#endif /* VISON_FEATURES_LOW_LEVEL_Sift_HPP_ */
