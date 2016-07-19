/*
 * dense_surf.hpp
 *
 *  Created on: Sep 14, 2013
 *      Author: mdantone
 */

#ifndef DENSE_SURF_HPP_
#define DENSE_SURF_HPP_

#include "low_level_feature_extractor.hpp"

#include "opencv2/core/core.hpp"

namespace vision {
namespace features {

class DenseSurf : public LowLevelFeatureExtractor {
public:
  DenseSurf() {}

	virtual void extract_at_extremas(
			const cv::Mat& image,
			cv::Mat_<float>* descriptors,
			const cv::Mat_<uchar>& mask = cv::Mat_<char>()) const {
		CHECK(false) << "Cannot only extract DenseSurf densely";
	}

	virtual cv::Mat_<float> denseExtract(
			const cv::Mat& image,
			std::vector<cv::Point>& locations,
			const cv::Mat_<uchar>& mask = cv::Mat_<char>()
			) const {
		if (mask.data != NULL) {
			LOG(INFO) << "mask not yet supported in DenseSurf";
		}

		const int bin_size = 4;
		cv::Mat_<float> features;
		DenseSurf::extract(image, features, locations, bin_size);
		return features;
	}

	virtual unsigned int descriptorLength() const {
		return 64;
	}

  static void extract(const cv::Mat_<u_char>& img,
                      cv::Mat_<float>& features,
											std::vector<cv::Point>& locations,
                      int bin_size = 1);

  static void compute_derivatives( const cv::Mat_<u_char>& img,
                                cv::Mat_<float>& dx_pos_int,
                                cv::Mat_<float>& dx_neg_int,
                                cv::Mat_<float>& dy_pos_int,
                                cv::Mat_<float>& dy_neg_int );

  static void compute_sums( const cv::Mat_<float>& dx_pos_int,
                          const cv::Mat_<float>& dx_neg_int,
                          const cv::Mat_<float>& dy_pos_int,
                          const cv::Mat_<float>& dy_neg_int,
                          int size,
                          cv::Mat_<float>& dx_sum,
                          cv::Mat_<float>& dx_abs_sum,
                          cv::Mat_<float>& dy_sum,
                          cv::Mat_<float>& dy_abs_sum );

};

} /* namespace features */
} /* namespace vision */
#endif /* DENSE_SURF_HPP_ */
