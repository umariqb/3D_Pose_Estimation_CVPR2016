/*
 * FeatureChannelExtractor.cpp
 *
 *  Created on: Sep 7, 2011
 *      Author: Matthias Dantone
 */

#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include <boost/thread.hpp>
#include <boost/foreach.hpp>
#include <glog/logging.h>

#include "hog_extractor.h"
#include "feature_channel_factory.hpp"

#include "cpp/fashion/skin/SkinSegmentation.h"
#include "cpp/utils/thread_pool.hpp"
#include "cpp/utils/timing.hpp"
#include "cpp/vision/min_max_filter.hpp"

using namespace cv;
using namespace std;

namespace vision {
namespace features {
namespace feature_channels {

FeatureChannelFactory::FeatureChannelFactory() {
  init_gabor_kernels();
}

void FeatureChannelFactory::extractChannel(int type, bool useIntegral,
    const Mat& src,
    const Mat& src_color,
    vector<Mat>& channels) const {

  vector<Mat> tmp;
  if (type == FC_GRAY) {
    extract_fc_gray(src, src_color, tmp);

  }else if (type == FC_NORM) {
    extract_fc_norm(src, src_color, tmp);

  }else if (type == FC_GABOR) {
    extract_fc_gabor(src, src_color, tmp);

  } else if (type == FC_SOBEL){
    extract_fc_sobel(src, src_color, tmp);

  } else if (type == FC_MIN_MAX){
    extract_fc_mim_max(src, src_color, tmp);

  } else if (type == FC_CANNY) {
    extract_fc_canny(src, src_color, tmp);

  } else if (type == FC_HOG) {
    extract_fc_hog(src, src_color, tmp);

  } else if( type == FC_SKIN) {
    extract_fc_skin(src, src_color, tmp);

  }else if( type == FC_LBP){
    extract_fc_lbp(src, src_color, tmp);

  }else if(type == FC_SURF){
    extract_fc_surf(src, src_color, tmp);

  }else if(type == FC_T2SURF) {
		extract_fc_t2surf(src, src_color, tmp);

	}else if(type == FC_LAB){
    extract_fc_lab(src, src_color, tmp);
  }else if(type == FC_COLOR_HOG){
    extract_fc_color_hog(src, src_color, tmp);
  }else{
    LOG(ERROR)<< "unkown feature channel" << std::endl;
    CHECK(false);
  }

  if(useIntegral) {
    for(unsigned int i = 0; i < tmp.size(); i++) {
      cv::Mat int_out;
      cv::integral(tmp[i], int_out, CV_32F);
      channels.push_back(int_out);
    }
  }else{
    channels.insert(channels.end(), tmp.begin(), tmp.end());
  }

}

void FeatureChannelFactory::extract_fc_gray( const Mat& src,
      const Mat& src_color,
      vector<Mat>& channels) const {
  channels.push_back(src);
}

void FeatureChannelFactory::extract_fc_norm( const Mat& src,
      const Mat& src_color,
      vector<Mat>& channels) const {
  cv::Mat normal;
  cv::equalizeHist(src, normal);
  channels.push_back(normal);
}

void FeatureChannelFactory::extract_fc_gabor( const Mat& src,
  const Mat& src_color,
  vector<Mat>& channels) const {
  //check if kernels are initzialized
  int old_size = channels.size();
  bool multithreaded = true;
  if (multithreaded) {
    channels.resize(channels.size() + reals.size());
    int num_treads = boost::thread::hardware_concurrency();
    boost::thread_pool::executor e(num_treads);
    for (unsigned int i = 0; i < reals.size(); i++) {
      e.submit(boost::bind(&FeatureChannelFactory::gabor_transform,
          this, src, &channels[old_size + i],  i, old_size));
    }
    e.join_all();
  } else {
    for (unsigned int i = 0; i < reals.size(); i++) {
      cv::Mat final;
      cv::Mat r_mat;
      cv::Mat i_mat;
      cv::filter2D(src, r_mat, CV_32F, reals[i]);
      cv::filter2D(src, i_mat, CV_32F, imags[i]);
      cv::pow(r_mat, 2, r_mat);
      cv::pow(i_mat, 2, i_mat);
      cv::add(i_mat, r_mat, final);
      cv::pow(final, 0.5, final);
      cv::normalize(final, final, 0, 1, CV_MINMAX, CV_32F);

      final.convertTo(final, CV_8UC1, 255);
      channels.push_back(final);

    }
  }
}

void FeatureChannelFactory::extract_fc_sobel( const Mat& src,
      const Mat& src_color,
      vector<Mat>& channels) const {
  Mat sob_x(src.size(), CV_8U);
  Mat sob_y(src.size(), CV_8U);

  Sobel(src, sob_x, CV_8U, 0, 1);
  Sobel(src, sob_y, CV_8U, 1, 0);

  channels.push_back(sob_x);
  channels.push_back(sob_y);
}

void FeatureChannelFactory::extract_fc_mim_max( const Mat& src,
      const Mat& src_color,
      vector<Mat>& channels) const {
  cv::Mat kernel(cv::Size(3, 3), CV_8UC1);
  kernel.setTo(cv::Scalar(1));
  cv::Mat img_min(src.size(), CV_8U);
  cv::Mat img_max(src.size(), CV_8U);

  cv::erode(src, img_min, kernel);
  cv::dilate(src, img_max, kernel);

  channels.push_back(img_min);
  channels.push_back(img_max);
}

void FeatureChannelFactory::extract_fc_canny( const Mat& src,
      const Mat& src_color,
      vector<Mat>& channels) const {
  cv::Mat cannyImg;
  cv::Canny(src, cannyImg, -1, 5);
  channels.push_back(cannyImg);
}

void FeatureChannelFactory::extract_fc_hog( const Mat& src,
      const Mat& src_color,
      vector<Mat>& channels) const {
  HOGExtractor hog_ex;
  CHECK(src_color.data != NULL);
  hog_ex.extractFeatureChannels15( src_color, channels );
}

void FeatureChannelFactory::extract_fc_skin( const Mat& src,
      const Mat& src_color,
      vector<Mat>& channels) const {

  fashion::SkinSegmentation skin_seg;
  cv::Mat skin_probability_map;
  cv::Mat skin_class_map;
  CHECK(src_color.data != NULL);
  skin_seg.createSkinProbabilityMap(src_color, &skin_probability_map );
  skin_seg.createSkinPixelMap(src_color, &skin_class_map);
  channels.push_back(skin_probability_map);
  channels.push_back(skin_class_map);
}

void FeatureChannelFactory::extract_fc_lbp( const Mat& src,
      const Mat& src_color,
      vector<Mat>& channels) const {
  cv::Mat src_blur = src;
//  cv::blur(src_blur, src_blur, cv::Size(3,3));

  std::vector<int> step_widths;
  step_widths.push_back(1);
  step_widths.push_back(2);
  step_widths.push_back(3);
  step_widths.push_back(4);
  step_widths.push_back(5);
  step_widths.push_back(6);
  BOOST_FOREACH(int step_width, step_widths) {
    cv::Mat out = cv::Mat(src_blur.size(), CV_8UC1);
    for (int x = step_width; x < src_blur.cols-step_width; x++) {
      for (int y = step_width; y < src_blur.rows-step_width; y++) {
        uchar feature = vision::features::get_lbp_code(y,x, src_blur,step_width);
        out.at<unsigned char>(y,x) = feature;
      }
    }
    channels.push_back(out);
  }
}


void FeatureChannelFactory::extract_fc_surf( const Mat& src,
      const Mat& src_color,
      vector<Mat>& channels) const {
  Mat dx, dx_min;
  Sobel(src,dx,CV_8U,1,0,3);
  Sobel(src,dx_min,CV_8U,1,0,3,-1);

  Mat dy, dy_min;
  Sobel(src,dy,CV_8U,0,1,3);
  Sobel(src,dy_min,CV_8U,0,1,3,-1);

  channels.push_back(dx);
  channels.push_back(dx_min);
  channels.push_back(dy);
  channels.push_back(dy_min);
}

void FeatureChannelFactory::extract_fc_t2surf( const Mat& src,
      const Mat& src_color,
      vector<Mat>& channels) const {
	// Extract standard SURF.
	extract_fc_surf(src, src_color, channels);
	for (int c = 0; c < channels.size(); ++c) {
		channels[c].convertTo(channels[c], CV_32F);
		channels[c] *= 1.0 / 255;
	}

	const Mat& dx = channels[0];
	const Mat& dx_min = channels[1];
	const Mat& dy = channels[2];
	const Mat& dy_min = channels[3];

	Mat dx2, dx_min2, dy2, dy_min2;
	cv::pow(dx, 2, dx2);
	cv::pow(dx_min, 2, dx_min2);
	cv::pow(dy, 2, dy2);
	cv::pow(dy_min, 2, dy_min2);

	Mat dx45;
	cv::add(dx2, dy2, dx45);
	cv::sqrt(dx45, dx45);

	Mat dx45_min;
	cv::add(dx_min2, dy_min2, dx45_min);
	cv::sqrt(dx45_min, dx45_min);

	Mat dy45;
	cv::subtract(dx2, dy2, dy45);
	cv::sqrt(dy45, dy45);

	Mat dy45_min;
	cv::subtract(dx_min2, dy_min2, dy45_min);
	cv::sqrt(dy45_min, dy45_min);

	channels.push_back(dx45);
	channels.push_back(dx45_min);
	channels.push_back(dy45);
	channels.push_back(dy45_min);

	for (int c = 0; c < channels.size(); ++c) {
		channels[c] *= 255;
		channels[c].convertTo(channels[c], CV_8U);
	}
}

void FeatureChannelFactory::extract_fc_lab( const cv::Mat& src,
    const cv::Mat& src_color,
    std::vector<cv::Mat>& channels) const {

  Mat imgRGB(src_color.size(), CV_8UC3);
  cvtColor( src_color, imgRGB, CV_RGB2Lab  );
  cv::split(imgRGB, channels);
  channels.resize(6);

  for(int c=0; c < 3; c++) {
    channels[c+3].create(src_color.rows,src_color.cols, CV_8U);
    vision::MinMaxFilter::minfilt(channels[c], channels[c+3], 5);
  }
  for(int c=0; c < 3; c++) {
    vision::MinMaxFilter::maxfilt(channels[c], 5);
  }
}

void FeatureChannelFactory::extract_fc_color_hog( const cv::Mat& src,
    const cv::Mat& src_color,
    std::vector<cv::Mat>& channels, bool use_max_filter) const {

  std::vector<cv::Mat> channels_tmp;
  Mat imgRGB(src_color.size(), CV_8UC3);
//  cvtColor( src_color, imgRGB, CV_RGB2Lab  );
  cv::split(src_color, channels_tmp);

  for(int i=0; i < channels_tmp.size(); i++) {
    cv::equalizeHist(channels_tmp[i], channels_tmp[i]);

    std::vector<cv::Mat> channels_hog;
    HOGExtractor hog_ex;
    hog_ex.extractFeatureChannels9(channels_tmp[i],channels_hog, use_max_filter);

    channels.push_back(channels_tmp[i]);
    for(int j=0; j < channels_hog.size(); j++) {
      channels.push_back(channels_hog[j]);
    }

  }
}

void FeatureChannelFactory::gabor_transform(const cv::Mat& src, cv::Mat* dst,
      int index, int old_size) const {
    cv::Mat final;
    cv::Mat r_mat;
    cv::Mat i_mat;
    cv::filter2D(src, r_mat, CV_32F, reals[index]);
    cv::filter2D(src, i_mat, CV_32F, imags[index]);
    cv::pow(r_mat, 2, r_mat);
    cv::pow(i_mat, 2, i_mat);
    cv::add(i_mat, r_mat, final);
    cv::pow(final, 0.5, final);
    cv::normalize(final, final, 0, 1, CV_MINMAX);


    final.convertTo(final, CV_8UC1, 255);
    *dst = final;
}

void FeatureChannelFactory::init_gabor_kernels() {

  //create kernels
  int NuMin = 0;
  int NuMax = 4;
  int MuMin = 0;
  int MuMax = 7;
  double sigma = 1. / 2.0 * CV_PI;
  double dF = sqrt(2.0);

  int iMu = 0;
  int iNu = 0;

  for (iNu = NuMin; iNu <= NuMax; iNu++)
    for (iMu = MuMin; iMu < MuMax; iMu++)
      createKernel(iMu, iNu, sigma, dF);

};

void FeatureChannelFactory::createKernel(int iMu, int iNu, double sigma, double dF) {
  //Initilise the parameters
  double F = dF;
  double k = (CV_PI / 2) / pow(F, (double) iNu);
  double phi = CV_PI * iMu / 8;

  double width = round((sigma / k) * 6 + 1);
  if (fmod(width, 2.0) == 0.0)
    width++;

  //create kernel
  cv::Mat m_real = cv::Mat(width, width, CV_32FC1);
  cv::Mat m_imag = cv::Mat(width, width, CV_32FC1);

  int x, y;
  double dReal;
  double dImag;
  double dTemp1, dTemp2, dTemp3;

  int off_set = (width - 1) / 2;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < width; j++) {
      x = i - off_set;
      y = j - off_set;
      dTemp1 = (pow(k, 2) / pow(sigma, 2)) * exp(-(pow((double) x, 2) + pow((double) y, 2)) * pow(k, 2) / (2 * pow(sigma, 2)));
      dTemp2 = cos(k * cos(phi) * x + k * sin(phi) * y) - exp(-(pow(sigma, 2) / 2));
      dTemp3 = sin(k * cos(phi) * x + k * sin(phi) * y);
      dReal = dTemp1 * dTemp2;
      dImag = dTemp1 * dTemp3;
      m_real.at<float>(j, i) = dReal;
      m_imag.at<float>(j, i) = dImag;
    }
  }

  reals.push_back(m_real);
  imags.push_back(m_imag);
};

} //namespace vision
} //namespace features
} //namespace feature_channels
