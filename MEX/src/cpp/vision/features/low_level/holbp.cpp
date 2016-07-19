/*
 * HoLbp.cpp
 *
 *  Created on: Oct 12, 2013
 *      Author: mdantone
 */

#include "holbp.hpp"
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace cv;

namespace vision {
namespace features {

/*virtual*/ unsigned int HoLbp::descriptorLength() const {
    return Lbp::wordCount();
}


void HoLbp::denseExtract( const cv::Mat_<uchar>& img_src,
              cv::Mat_<int>& img_dst,
              const cv::Mat_<uchar>& mask,
              int step_width) const {
  img_dst =  cv::Mat_<int>( img_src.size(), -1 );
  for (int row = step_width; row < img_src.rows - step_width; ++row) {
    for (int col = step_width; col < img_src.cols - step_width; ++col) {
      if (!mask.data || mask(row, col)) {
        img_dst(row, col) = get_lbp_code(row, col, img_src, step_width);
      }
    }
  }
}

/*virtual*/ cv::Mat_<float> HoLbp::denseExtract(
        const cv::Mat& image,
        std::vector<cv::Point>& locations,
        const cv::Mat_<uchar>& mask_ ) const {

  // prepare image
  cv::Mat_<uchar> gray;
  if (image.type() != CV_8U)  {
      cv::cvtColor(image, gray, CV_BGR2GRAY);
  } else {
      gray = image;
  }

  // erode mask
  cv::Mat_<uchar> mask;
  if(mask.data) {
    cv::Mat kernel(cv::Size(3, 3), CV_8UC1);
    kernel.setTo(cv::Scalar(1));
    cv::erode(mask_, mask, kernel);
  }

  // compute dense grid points if points are not set.
  if(locations.size() == 0) {
    LowLevelFeatureExtractor::generateGridLocations(
            image.size(),
            cv::Size(grid_width, grid_width),
            cell_size/2,
            cell_size/2,
            locations,
            mask);
  }else{
    // check if points are valid
    for(int i=0; i < locations.size(); i++) {
      Rect roi(locations[i].x-cell_size/2, locations[i].y-cell_size/2,
               cell_size, cell_size );
      CHECK_GE(roi.x, 0 );
      CHECK_GE(roi.y, 0 );
      CHECK_LE(roi.x+roi.width, gray.cols );
      CHECK_LE(roi.y+roi.height, gray.rows );
    }
  }

  // compute lbp
  cv::Mat_<int> lbp_1;
  denseExtract(gray, lbp_1, mask, 1);

  CHECK_EQ(lbp_1.cols, gray.cols);
  CHECK_EQ(lbp_1.rows, gray.rows);

  cv::Mat_<float> descriptors(locations.size(), descriptorLength(),0.0);
  for(int i=0; i < locations.size(); i++) {
    Rect roi(locations[i].x-cell_size/2, locations[i].y-cell_size/2,
             cell_size, cell_size );

    CHECK_GE(roi.x, 0 );
    CHECK_GE(roi.y, 0 );
    CHECK_LE(roi.x+roi.width, gray.cols );
    CHECK_LE(roi.y+roi.height, gray.rows );
    Mat_<float> row = descriptors.row(i);

    exract_hist( gray(roi), lbp_1(roi), row);
//    exract_hist( gray(roi), row, mask(roi));

  }
  return descriptors;

}

void HoLbp::exract_hist( const cv::Mat_<uchar>& image,
                         cv::Mat_<float>& desc,
                         const cv::Mat_<uchar>& mask) const {
  desc.setTo(0);
  // extract hist
  for (int row = step_width; row < image.rows - step_width; ++row) {
    for (int col =step_width; col < image.cols - step_width; ++col) {
      if (!mask.data || mask(row, col)) {
        ++desc(get_lbp_code(row, col, image, step_width));
      }
    }
  }

  // normalize desc
  float val, sqlen = 0.0, fac;
  for (int i =0; i < desc.cols; i++) {
    val = desc(i);
    sqlen += val * val;
  }
  if (sqlen > 0) {
    fac = 1.0 / sqrt(sqlen);
    for(int i = 0; i <  desc.cols; i++) {
      desc(i) *= fac;
    }
  }
}

void HoLbp::exract_hist( const cv::Mat_<uchar>& image,
                         const cv::Mat_<int>& lbp,
                         cv::Mat_<float>& desc) const {

  desc.setTo(0);
  // extract hist
  for (int row = step_width; row < image.rows - step_width; ++row) {
    for (int col =step_width; col < image.cols - step_width; ++col) {
      if(  lbp(row, col) >= 0 ) {
        ++desc( lbp(row, col) );
      }
    }
  }

  // normalize desc
  float val, sqlen = 0.0, fac;
  for (int i =0; i < desc.cols; i++) {
    val = desc(i);
    sqlen += val * val;
  }
  if (sqlen > 0) {
    fac = 1.0 / sqrt(sqlen);
    for(int i = 0; i <  desc.cols; i++) {
      desc(i) *= fac;
    }
  }
}





} /* namespace features */
} /* namespace vision */
