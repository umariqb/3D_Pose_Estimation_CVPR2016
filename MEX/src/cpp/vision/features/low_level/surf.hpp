/*
 * surf.hpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#ifndef VISON_FEATURES_LOW_LEVEL_SURF_HPP_
#define VISON_FEATURES_LOW_LEVEL_SURF_HPP_

#include "low_level_feature_extractor.hpp"
#include <opencv2/core/core.hpp>
#include <opencv2/nonfree/features2d.hpp>
namespace vision
{
namespace features
{

class Surf: public LowLevelFeatureExtractor
{
public:

    Surf();
    virtual ~Surf();

    virtual void extract_at_extremas(const cv::Mat& image,
                             cv::Mat_<float>* descriptors,
                             const cv::Mat_<uchar>& mask = cv::Mat_<char>()) const;

    virtual cv::Mat_<float> denseExtract(
                const cv::Mat& image,
                std::vector<cv::Point>& descriptor_locations,
                const cv::Mat_<uchar>& mask = cv::Mat_<char>()
                ) const;

    cv::Mat_<float> extract(const cv::Mat& image,
                std::vector<cv::KeyPoint>* keypoints ) const;

    virtual void extract(const cv::Mat& image,
                std::vector<cv::KeyPoint>* keypoints,
                cv::Mat_<float>* descriptor) const;

    virtual unsigned int descriptorLength() const;

    void getGridLocations(const cv::Size& img_size,
            std::vector<cv::Point>& locations,
            const cv::Mat_<uchar>& mask );

    void set_grid_spacing(int spacing);

private:
    cv::SURF surf_;
    unsigned int grid_width_;
    unsigned int keypoint_size_;

};

class RootSurf : public Surf {
  virtual void extract(const cv::Mat& image,
              std::vector<cv::KeyPoint>* keypoints,
              cv::Mat_<float>* descriptors) const;

};

} /* namespace features */
} /* namespace vision */
#endif /* VISON_FEATURES_LOW_LEVEL_SURF_HPP_ */
