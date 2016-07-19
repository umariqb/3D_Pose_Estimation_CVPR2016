/*
 * dense_surf.cpp
 *
 *  Created on: Sep 14, 2013
 *      Author: mdantone
 */

#include "dense_surf.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include <glog/logging.h>

using namespace cv;
using namespace std;

namespace vision {
namespace features {

void DenseSurf::compute_derivatives(const cv::Mat_<u_char>& img,
                                    Mat_<float>& dx_pos_int,
                                    Mat_<float>& dx_neg_int,
                                    Mat_<float>& dy_pos_int,
                                    Mat_<float>& dy_neg_int ) {

  // compute the derivatives in x and y direction
  Mat_<u_char> dx_pos, dx_neg;
  Sobel(img,dx_pos,CV_8U,1,0,3);
  Sobel(img,dx_neg,CV_8U,1,0,3,-1);

  Mat_<u_char> dy_pos, dy_neg;
  Sobel(img,dy_pos,CV_8U,0,1,3);
  Sobel(img,dy_neg,CV_8U,0,1,3,-1);

  // calculate integral image.
  cv::integral(dx_pos, dx_pos_int, CV_32F);
  cv::integral(dx_neg, dx_neg_int, CV_32F);
  cv::integral(dy_pos, dy_pos_int, CV_32F);
  cv::integral(dy_neg, dy_neg_int, CV_32F);
}

float integral_sum(const Mat_<float>& mat_int, const cv::Rect roi ) {
  float a = mat_int.at<float>(roi.y, roi.x);
  float b = mat_int.at<float>(roi.y, roi.x + roi.width);
  float c = mat_int.at<float>(roi.y + roi.height, roi.x);
  float d = mat_int.at<float>(roi.y + roi.height, roi.x + roi.width);
  return (d - b - c + a) / static_cast<float>(roi.width * roi.height);
}


void DenseSurf::compute_sums( const Mat_<float>& dx_pos_int,
                              const Mat_<float>& dx_neg_int,
                              const Mat_<float>& dy_pos_int,
                              const Mat_<float>& dy_neg_int,
                              int bin_size,
                              Mat_<float>& dx_sum,
                              Mat_<float>& dx_abs_sum,
                              Mat_<float>& dy_sum,
                              Mat_<float>& dy_abs_sum ) {

  int n_rows = (dx_pos_int.rows-1)/bin_size;
  int n_cols = (dx_pos_int.cols-1)/bin_size;
  dx_sum     = Mat_<float>( n_rows, n_cols);
  dx_abs_sum = Mat_<float>( n_rows, n_cols );
  dy_sum     = Mat_<float>( n_rows, n_cols );
  dy_abs_sum = Mat_<float>( n_rows, n_cols );

  for(int x = 0; x < n_cols; ++x) {
    for(int y = 0; y < n_rows; ++y) {

      Rect r(x*bin_size, y*bin_size, bin_size, bin_size);
      Point p(x,y);
      float sum_dx_pos = integral_sum(dx_pos_int, r);
      float sum_dx_neg = integral_sum(dx_neg_int, r);
      float sum_dy_pos = integral_sum(dy_pos_int, r);
      float sum_dy_neg = integral_sum(dy_neg_int, r);

      dx_sum.at<float>(p)     = sum_dx_pos - sum_dx_neg;
      dx_abs_sum.at<float>(p) = sum_dx_pos + sum_dx_neg;
      dy_sum.at<float>(p)     = sum_dy_pos - sum_dy_neg;
      dy_abs_sum.at<float>(p) = sum_dy_pos + sum_dy_neg;

    }
  }
}

void compute_desc( const Mat_<float>& dx_sum,
                  const Mat_<float>& dx_abs_sum,
                  const Mat_<float>& dy_sum,
                  const Mat_<float>& dy_abs_sum,
                  cv::Mat_<float>& features,
									std::vector<cv::Point>& locations) {

  int desc_size = 64;
  int n_features = (dx_sum.rows - 4) * (dx_sum.cols  - 4);
  int i_features = 0;

  features = Mat_<float>(n_features, desc_size);
  for(int x = 0; x < dx_sum.cols - 4; ++x) {
    for(int y = 0; y < dx_sum.rows - 4; ++y) {
			locations.push_back(cv::Point(x, y));
      for(int i = 0; i < 4; ++i) {
        for(int j = 0; j < 4; ++j) {
          Point p(x+i,y+j);
          int index = (i*4+j)*4;

          features.at<float>(i_features, index)     = dx_sum.at<float>(p);
          features.at<float>(i_features, index + 1) = dx_abs_sum.at<float>(p);
          features.at<float>(i_features, index + 2) = dy_sum.at<float>(p);
          features.at<float>(i_features, index + 3) = dy_abs_sum.at<float>(p);

        }
      }
      ++i_features;
    }
  }

  // normalize desc
  for(int i_feat = 0; i_feat < n_features; ++i_feat) {

    float val, sqlen = 0.0, fac;
    for (int i =0; i < desc_size; i++) {
      val = features.at<float>(i_feat, i);
      sqlen += val * val;
    }
    if (sqlen > 0) {
      fac = 1.0 / sqrt(sqlen);
      for(int i = 0; i < desc_size; i++) {
        features.at<float>(i_feat, i) *= fac;
      }
    }
  }

}


void DenseSurf::extract(const cv::Mat_<u_char>& img,
                        cv::Mat_<float>& features,
												std::vector<cv::Point>& locations,
                        int bin_size) {

  // compute the derivatives in x and y direction
  Mat_<float> dx_pos, dx_neg, dy_pos, dy_neg;
  compute_derivatives(img, dx_pos, dx_neg, dy_pos, dy_neg);


  Mat_<float> dx_sum, dx_abs_sum, dy_sum, dy_abs_sum;
  compute_sums(dx_pos, dx_neg, dy_pos, dy_neg, bin_size,
               dx_sum, dx_abs_sum, dy_sum, dy_abs_sum);


	compute_desc(dx_sum, dx_abs_sum, dy_sum, dy_abs_sum, features, locations);


}

} /* namespace features */
} /* namespace vision */
