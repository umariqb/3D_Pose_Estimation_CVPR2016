/*
 * low_level_feature_extractor.cpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#include "low_level_feature_extractor.hpp"
#include <glog/logging.h>

#include <opencv2/imgproc/imgproc.hpp>

namespace vision
{
namespace features
{

///////////////////////////////////////////////////////////////////////////////
// Base class
LowLevelFeatureExtractor::LowLevelFeatureExtractor()
{

}

/*virtual*/ LowLevelFeatureExtractor::~LowLevelFeatureExtractor()
{
}
/*static*/ void LowLevelFeatureExtractor::generateGridLocations(
        const cv::Size& image,
        const cv::Size& grid_spacing,
        const int margin_rows,
        const int margin_cols,
        std::vector<cv::Point>& keypoints,
        const cv::Mat_<uchar>& mask )
{
    const int min_row = margin_rows;
    const int min_col = margin_cols;
    const int max_row = image.height - margin_rows;
    const int max_col = image.width - margin_cols;
    int points_w = std::ceil((static_cast<float>(image.width) - (2.f * margin_cols-1)) / grid_spacing.width);
    int points_h = std::ceil((static_cast<float>(image.height) - (2.f * margin_rows-1)) / grid_spacing.height);
    keypoints.clear();
    if (points_w < 1 || points_h < 1)
    {
        return;
    }
    keypoints.reserve(points_w * points_h);

    if (mask.data)
    {
        for (int row = min_row ; row <= max_row ; row += grid_spacing.height)
        {
            for (int col = min_col; col <= max_col; col += grid_spacing.width)
            {
                if (mask(row, col))
                {
                    keypoints.push_back(cv::Point(col, row));
                }
            }
        }
    }
    else
    {
        for (int row = min_row ; row <= max_row ; row += grid_spacing.height)
        {
            for (int col = min_col; col <= max_col; col += grid_spacing.width)
            {
                keypoints.push_back(cv::Point(col, row));
            }
        }
    }


}

cv::Mat_<float> LowLevelFeatureExtractor::denseExtract(const cv::Mat& image) const
{
    std::vector<cv::Point> locations;
    return this->denseExtract(image, locations);
}

cv::Mat_<float> LowLevelFeatureExtractor::denseExtractMultiscale(const cv::Mat& image, std::vector<cv::Point>& locations, float start, float stop, float step) const
{
  cv::Mat_<float> features;
  locations.clear();

  // extract with scaling
  cv::Mat scaled_image;
  for (float scale=start; scale <= stop; scale += step){
    // scale
    double scale_factor = std::pow(2, -scale);
    cv::resize(image, scaled_image, cv::Size(), scale_factor, scale_factor);

    std::vector<cv::Point> loc;
    cv::Mat_<float> curr_features = denseExtract(scaled_image, loc);
    features.push_back(curr_features);
    for (int32_t loc_idx = 0; loc_idx < loc.size(); ++loc_idx){
      locations.push_back(loc[loc_idx] * (1./scale_factor));
    }
  }

  return features;
}

} /* namespace features */
} /* namespace vision */
