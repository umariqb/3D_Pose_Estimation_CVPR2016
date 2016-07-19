/*
 * low_level_feature_extractor.hpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#ifndef VISON_FEATURES_LOW_LEVEL_FEATURE_EXTRACTOR_HPP_
#define VISON_FEATURES_LOW_LEVEL_FEATURE_EXTRACTOR_HPP_

#include <boost/noncopyable.hpp>

#include <opencv2/core/core.hpp>
#include <glog/logging.h>
namespace vision
{
namespace features
{

class LowLevelFeatureExtractor : boost::noncopyable
{
public:
    LowLevelFeatureExtractor();
    virtual ~LowLevelFeatureExtractor();

    virtual void extract_at_extremas(const cv::Mat& image,
             cv::Mat_<float>* descriptors,
             const cv::Mat_<uchar>& mask = cv::Mat_<char>()) const = 0;

    virtual cv::Mat_<float> denseExtract(
            const cv::Mat& image,
            std::vector<cv::Point>& descriptor_locations,
            const cv::Mat_<uchar>& mask = cv::Mat_<char>()
            ) const = 0;

    cv::Mat_<float> denseExtract(const cv::Mat& image) const;

    /**
     * extracts features at multiple scales (scaling factor 2^(-i)))
     * @param image
     * @param scales
     * @return
     */
    cv::Mat_<float> denseExtractMultiscale(
        const cv::Mat& image,
        std::vector<cv::Point>& locations,
        float start=0,
        float stop=3,
        float step=.5) const;


    static void generateGridLocations(
            const cv::Size& image,
            const cv::Size& grid_spacing,
            const int margin_rows,
            const int margin_cols,
            std::vector<cv::Point>& keypoints,
            const cv::Mat_<uchar>& mask );

    virtual unsigned int descriptorLength() const = 0;

protected:

private:


};


// Matthias // I would prefer a interface like that
// extract features densly
/*
void extract_dense(const cv::Mat& image,
         cv::Mat_<float>* descriptors,
         std::vector<cv::Point>* keypoints,
         const cv::Mat_<uchar>& mask = cv::Mat_<char>()) const;

// extract faetures at local maximas
void extract_at_extremas(const cv::Mat& image,
         cv::Mat_<float>* descriptors,
         std::vector<cv::Point>* keypoints,
         const cv::Mat_<uchar>& mask = cv::Mat_<char>()) const;


// extract features at predefined locations
virtual void extract(const cv::Mat& image,
         const std::vector<cv::Point>& descriptor_locations,
         cv::Mat_<float>* descriptors) const = 0;

// returns location of the local maximas
virtual void get_local_maximas(const cv::Mat& image,
          std::vector<cv::Point>* descriptor_locations,
          const cv::Mat_<uchar>& mask = cv::Mat_<char>(),
          int max_locations = -1) const = 0;

virtual void get_dense_locations(const cv::Mat& image,
          std::vector<cv::Point>* descriptor_locations,
          const cv::Mat_<uchar>& mask = cv::Mat_<char>(),
          int max_locations = -1) const = 0;

*/


} /* namespace features */
} /* namespace vision */
#endif /* VISON_FEATURES_LOW_LEVEL_FEATURE_EXTRACTOR_HPP_ */
