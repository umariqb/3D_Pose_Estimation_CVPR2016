/*
 * test_dense_surf.cpp
 *
 *  Created on: Sep 14, 2013
 *      Author: mdantone
 */

#include "dense_surf.hpp"
#include "surf.hpp"

#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "cpp/utils/timing.hpp"

#include <glog/logging.h>

using namespace cv;
using namespace std;



int main(int argc, char** argv) {

  cv::Mat_<uchar> colors_big_image = cv::imread("/home/mdantone/Desktop/winter_dunk.jpg", 0);


  Timing timer;
  timer.start();
  cv::Mat_<float> features;
  vector<Point> loc;
  vision::features::DenseSurf::extract(colors_big_image, features, loc, 4);
  LOG(INFO) << "dense: " << timer.elapsed();


  timer.restart();
  vector<Point> locations;
  vision::features::Surf surf_extr;
  Mat feat = surf_extr.denseExtract(colors_big_image, locations);

  LOG(INFO) << "regular: " << timer.elapsed();

  LOG(INFO) << features.rows;

  LOG(INFO) << feat.rows;

}
