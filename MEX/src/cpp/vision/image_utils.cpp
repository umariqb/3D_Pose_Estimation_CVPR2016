/*
 * image_utils.cpp
 *
 *  Created on: Jan 20, 2012
 *      Author: lbossard
 */

#include "image_utils.hpp"
#include <glog/logging.h>

#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;
namespace vision
{
namespace image_utils
{
/**
 * Normalizes each channel of the image independently:
 * Histogram of each channel is stretched to 0 / 255
 * @param image
 * @param pixel_portion_to_discard portion of pixels to be dicarded / ignored
 */
void normalizeColors(Mat& image, float pixel_portion_to_discard)
{
    static const size_t num_bins = 256;
    const int total = image.rows * image.cols;

    // normalize each channel
    for (int channel = 0; channel < image.channels(); ++channel)
    {
        unsigned int histogram[num_bins] = {0};

        // collect histogram
        for (int r = 0; r < image.rows; ++r)
        {
            for (int c = 0; c < image.cols; ++c)
            {
                ++histogram[image.data[r * image.step[0] + c * image.step[1] + channel]];
            }
        }

        // find lowest value  with at least total * colorNormalizationThreshold pixels
        size_t lower_bin = 0;
        for (unsigned int sum = 0; sum < total * pixel_portion_to_discard && lower_bin < num_bins; sum += histogram[lower_bin++]) {}

        // find highest value  with at least total * colorNormalizationThreshold pixels
        size_t upper_bin = num_bins - 1;
        for (unsigned int sum = 0; sum < total * pixel_portion_to_discard && upper_bin > lower_bin; sum += histogram[upper_bin--]) {}

        --lower_bin;
        ++upper_bin;

        // normalize each pixel
        for (int r = 0; r < image.rows; ++r)
        {
            for (int c = 0; c < image.cols; ++c)
            {
                int position = r * image.step[0] + c * image.step[1] + channel;
                image.data[position] = std::min<int>(
                        std::max<int>(image.data[position] - lower_bin, 0) * num_bins / (upper_bin - lower_bin),
                        num_bins - 1);
            }
        }
    }
}



double scale_down_if_bigger(
        const Mat& image,
        int max_side_length,
        Mat& resized_image) {
  double scale_factor = static_cast<double>(max_side_length) / std::max(image.rows, image.cols);
  if (scale_factor >= 1.) {
    resized_image = image.clone();
    scale_factor = 1.;
  }
  else {
    resize(image, resized_image, Size(), scale_factor, scale_factor);
  }
  return scale_factor;
}

void resize_and_crop(const Mat& image, int width, int height, Mat& resized_image){
	double scale_factor = std::max(
      static_cast<double>(width)/image.cols,
      static_cast<double>(height)/image.rows);

	resize(image, resized_image, Size(), scale_factor, scale_factor);

	Rect cropping(
			(resized_image.cols - width) / 2,  // x
			(resized_image.rows - height) / 2, // y
			width,
			height );
	// crop and make continuous array
	resized_image = resized_image(cropping).clone();
}


double build_image_pyramid(const Mat& test_image,
    int scale_count, float scale_factor,
    std::vector<Mat>& pyramid,
    int max_side_length) {

  // Create array of downsampled images.
  pyramid.resize(scale_count);

  double init_scale_factor =
      scale_down_if_bigger(test_image, max_side_length, pyramid[0]);

  for (int i = 1; i < pyramid.size(); ++i) {
    resize(pyramid[i - 1], pyramid[i], Size(0, 0),
               scale_factor, scale_factor);
  }
  return init_scale_factor;
}

bool build_image_pyramid(const Mat& test_image,
    int scale_count, float scale_factor,
    std::vector<Mat>& pyramid,
    double initial_scale) {

  // Create array of downsampled images.
  pyramid.resize(scale_count);
  std::vector<double> scales(scale_count);

  scales[0] = initial_scale;
  for(unsigned int i=1; i<scales.size(); i++){
    scales[i] = scale_factor*scales[i-1];
  }

  for (int i = 0; i < pyramid.size(); ++i) {
    resize(test_image, pyramid[i], Size(0, 0),
               scales[i], scales[i]);
  }
  true;
}


void extend_image(const cv::Mat& src_img,
                  int add_pixel_per_side, cv::Mat& dst_img) {
  CHECK_GT(add_pixel_per_side, 0);

  // create new image.
  Size new_size(src_img.cols + add_pixel_per_side*2,
                src_img.rows + add_pixel_per_side*2);
  dst_img = Mat(new_size, src_img.type() );

  // copy old image.
  Rect bbox(add_pixel_per_side, add_pixel_per_side, src_img.cols, src_img.rows );
  src_img.copyTo( dst_img(bbox) );


}





} // namespace image_utils
} // namespace vision
