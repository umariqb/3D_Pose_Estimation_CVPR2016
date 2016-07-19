/*
 * tools.cpp
 *
 *  Created on: Oct 11, 2013
 *      Author: mdantone
 */

#ifndef VISION_TOOLS_CPP_
#define VISION_TOOLS_CPP_

#include <opencv2/core/core.hpp>
#include <opencv2/flann/flann.hpp>

#include "cpp/vision/features/low_level/surf.hpp"
#include <vector>

namespace vision
{
namespace features
{

void inline visualize_surf_matches(cv::Mat& src, cv::Mat& dst,
                            cv::Mat_<uchar>& mask_src,
                            cv::Mat_<uchar>& mask_dst) {


  std::vector<cv::Point> locations_src;
  std::vector<cv::Point> locations_dst;
  vision::features::Lbp extractor;


  cv::Mat descriptors_src = extractor.denseExtract(src, locations_src, mask_src);
  cv::Mat descriptors_dst = extractor.denseExtract(dst, locations_dst, mask_src);

  // nn search
  cv::Mat dists;
  cv::Mat_<int> indices;
  cv::flann::SearchParams p;
  p.setAlgorithm(cvflann::FLANN_DIST_EUCLIDEAN);
  cv::flann::Index index(descriptors_dst, p);
  index.knnSearch(descriptors_src, indices, dists, 1, p);

  std::vector< std::pair<int,int> > pairs;
  for(int i=0; i < descriptors_src.rows; i++) {
    int label = indices(i,0);
    pairs.push_back( std::make_pair(i, label));
  }


  int offset = 50;
  int w = std::max(src.cols, dst.cols);
  int h = std::max(src.rows, dst.rows);
  cv::Rect roi_a = cv::Rect(0,0, src.cols, src.rows );
  cv::Rect roi_b = cv::Rect(0,0, dst.cols, dst.rows );
  roi_b.x = w+offset;

  cv::Mat image = cv::Mat(w*2 +offset*2, h*2, CV_8UC3, 0.0 );
  src.copyTo(image(roi_a) );
  dst.copyTo(image(roi_b) );

  for(int i=0; i < pairs.size(); i++) {
    if( i%10 != 0)
      continue;
    cv::Point a = locations_src[pairs[i].first];
    cv::Point b = locations_dst[pairs[i].second];
    CHECK_LT(pairs[i].first, locations_src.size() );
    CHECK_LT(pairs[i].second,  locations_dst.size() );

    b.x += roi_b.x;
    cv::line(image, a, b, cv::Scalar(255,0,255) );
  }

  cv::imshow("matches", image);
  cv::waitKey(0);

}

void inline visualize_surf_matches(cv::Mat& src, cv::Mat& dst) {
  cv::Mat_<uchar> mask_src;
  cv::Mat_<uchar> mask_dst;
  visualize_surf_matches(src, dst, mask_src, mask_dst);
}

}
}


#endif /* vTOOLS_CPP_ */
