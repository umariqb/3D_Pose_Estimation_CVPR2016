/*
 * image_utils.hpp
 *
 *  Created on: Jan 20, 2012
 *      Author: lbossard
 */

#ifndef VISION_IMAGE_UTILS_HPP_
#define VISION_IMAGE_UTILS_HPP_

#include <opencv2/core/core.hpp>

namespace vision
{
namespace image_utils
{
    void normalizeColors(cv::Mat& image,
                         float pixel_portion_to_discard = 0.0005);

    double scale_down_if_bigger(const cv::Mat& image,
                                int max_side_length,
                                cv::Mat& resized_image);

    void resize_and_crop(const cv::Mat& image,
                         int width,
                         int height,
                         cv::Mat& resized_image);

    double build_image_pyramid(const cv::Mat& test_image,
                              int scale_count, float scale_factor,
                              std::vector<cv::Mat>& pyramid,
                              int max_side_length = -1);

    bool build_image_pyramid(const cv::Mat& test_image,
                              int scale_count, float scale_factor,
                              std::vector<cv::Mat>& pyramid,
                              double initial_scale = 2.0);

    void extend_image(const cv::Mat& src_img,
                      int add_pixel_per_side, cv::Mat& dst_img);


} // namespace image_utils
} // namespace vision
#endif /* VISION_IMAGE_UTILS_HPP_ */
