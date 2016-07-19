/*
 * FeatureChannelExtractor.h
 *
 *  Created on: Sep 7, 2011
 *      Author: Matthias Dantone
 */

#ifndef FEATURECHANNELEXTRACTOR_H_
#define FEATURECHANNELEXTRACTOR_H_


#include <string>

#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

//#include "cpp/fashion/skin/SkinSegmentation.h"
#include "cpp/vision/features/low_level/lbp.hpp"
#include "cpp/vision/features/feature_channels/hog_extractor.h"
#include "cpp/utils/timing.hpp"


namespace vision {
namespace features {
namespace feature_channels {

#define FC_GRAY     0
#define FC_GABOR    1
#define FC_SOBEL    2
#define FC_MIN_MAX  3
#define FC_CANNY    4
#define FC_NORM     5
#define FC_HOG      6
#define FC_SKIN     7
#define FC_HESSIAN  8
#define FC_LBP      9
#define FC_SURF    10
#define FC_LAB     11
#define FC_T2SURF	 12
#define FC_COLOR_HOG  13

class FeatureChannelFactory {
public:

  FeatureChannelFactory();

	static int to_channel(const std::string& name) {
		if (name == "SURF") {
			return FC_SURF;
		} else if (name == "T2SURF") {
			return FC_T2SURF;
		}
		return -1;
	}

  void extractChannel(int type, bool useIntegral,
      const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;


  void extract_fc_gray( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_norm( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_gabor( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_sobel( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_mim_max( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_canny( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_hog( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_skin( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_lbp( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_surf( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

	void extract_fc_t2surf( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_lab( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels) const;

  void extract_fc_color_hog( const cv::Mat& src,
      const cv::Mat& src_color,
      std::vector<cv::Mat>& channels,
      bool use_max_filter = true) const;

  void gabor_transform(const cv::Mat& src, cv::Mat* dst,
      int index, int old_size) const;


private:
  void init_gabor_kernels();

  void createKernel(int iMu, int iNu, double sigma, double dF);

  //fashion::SkinSegmentation skin_seg;

  //gabor kernels
  std::vector<cv::Mat> reals;
  std::vector<cv::Mat> imags;
};

} //namespace vision
} //namespace features
} //namespace feature_channels
#endif /* FEATURECHANNELEXTRACTOR_H_ */
