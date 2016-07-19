/*
 * color.cpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#include "color.hpp"

#include <cstring>

#include <opencv2/imgproc/imgproc.hpp>

namespace vision
{
namespace features
{

Color::Color()
{
}
/*virtual*/Color::~Color()
{
}
/*virtual*/ unsigned int Color::descriptorLength() const
{
    return 3;
}
/*virtual*/ cv::Mat_<float> Color::denseExtract(
        const cv::Mat& image,
        std::vector<cv::Point>& locations,
        const cv::Mat_<uchar>& mask
        )  const
{
    if (mask.data)
    {
        return denseExtractMasked(image, locations, mask);
    }
    else
    {
        return denseExtract(image, locations, false);
    }
}
cv::Mat_<float> Color::denseExtract(
            const cv::Mat& image,
            std::vector<cv::Point>& locations,
            bool do_cache) const
{
    if (!do_cache
            ||  (do_cache
                && (locations.size() == 0
                    || locations[locations.size() - 1].x != image.cols
                    || locations[locations.size() - 1].y != image.rows)))
    {
        locations.resize(image.rows*image.cols);

        for (int row = 0 ; row < image.rows ; ++row)
        {
            for (int col = 0; col < image.cols; ++col)
            {
                cv::Point& p = locations[row * image.cols + col];
                p.x = col;
                p.y = row;
            }
        }
    }

    cv::Mat image_lab(image.size(), image.type());
    cv::cvtColor(image, image_lab, CV_BGR2Lab);
    image_lab.convertTo(image_lab, CV_32F);
    return image_lab.reshape(1, image_lab.rows * image_lab.cols);
}

cv::Mat_<float> Color::denseExtractMasked(
            const cv::Mat& image,
            std::vector<cv::Point>& locations,
            const cv::Mat_<uchar>& mask) const
{
    // prepare image
    cv::Mat image_lab(image.size(), image.type());
    cv::cvtColor(image, image_lab, CV_BGR2Lab);
    image_lab.convertTo(image_lab, CV_32F);
    cv::Mat_<float> feature_vector = image_lab.reshape(1, image_lab.rows * image_lab.cols);

    // reserve space locations
    locations.resize(image.rows*image.cols);

    // find first zero element (i.e. masked pixel)
    int index = 0;
    const uchar* mask_ptr = mask.ptr(0);
    const uchar* end_mask_ptr = mask.end().ptr;
    while ( (*mask_ptr) != 0 && mask_ptr < end_mask_ptr)
    {
        cv::Point& p = locations[index];
        p.x = index % image.cols ; // col
        p.y = index / image.cols; // row
        ++mask_ptr;
        ++index;
    }

    // found first zero in the mask.
    /*
     * TODO(luk): for optimization, we just could record the run of non masked
     *            pixels and copy them via one single memcpy call instead of
     *            consecutive calls.
     */
    if (index < feature_vector.cols){
      float* source = reinterpret_cast<float*>(feature_vector.ptr(index)); // this throws, if index bigger than allt he possible features
      while (mask_ptr < end_mask_ptr)
      {
        if ((*mask_ptr) != 0)
        {
          cv::Point& p = locations[index];
          p.x = index / image.cols;
          p.y = index % image.cols;

          float* dest = reinterpret_cast<float*>(feature_vector.ptr(index));
          // if there was on masked pixel, source != dest and thus src and dest
          // dont overlap. we can thus safely use memcpy
          std::memcpy(dest, source, 3 * sizeof(float));
          ++index;
        }
        ++mask_ptr;
        source += 3;
      }
    }

    // resize to the number of inserted elements
    locations.resize(index);
    feature_vector.resize(index);

    return feature_vector;
}

} /* namespace features */
} /* namespace vision */
