/*
 * eval_utils.hpp
 *
 *  Created on: Apr 24, 2013
 *      Author: gandrada
 */

#ifndef LEARNING_COMMON_EVAL_UTILS_HPP_
#define LEARNING_COMMON_EVAL_UTILS_HPP_

#include <fstream>

#include <opencv2/opencv.hpp>

#include "cpp/learning/common/classifier_interface.hpp"
#include "cpp/learning/common/image_sample.hpp"
#include "cpp/utils/string_utils.hpp"
#include "cpp/vision/features/feature_channels/feature_channel_factory.hpp"

namespace learning {
namespace common {
namespace utils {

using vision::features::feature_channels::FeatureChannelFactory;

// Describes a detected peak in an image.
struct PeakLocation {
	PeakLocation(int center_x, int center_y, const cv::Size& size, double score) :
		x(center_x), y(center_y), size(size), score(score) {}

	// Location of peak center.
	int x, y;

	// Peak size.
	cv::Size size;

	// Detection score.
	double score;
};

struct PeakDetectionParams {
	PeakDetectionParams() :
		scale_count(6), scale_factor(0.75),
		detection_threshold(0.8), rejection_threshold(1.2), max_step(4) {}

	PeakDetectionParams(int scale_count, double scale_factor,
											double detection_threshold, double rejection,
											int max_step) :
		scale_count(scale_count), scale_factor(scale_factor),
		detection_threshold(detection_threshold),
	  rejection_threshold(rejection), max_step(max_step) {}

	// How many scales to use in detection, including the original image.
	int scale_count;

	// Distance in scale between two images (the downsampling starts from the
	// query image).
	double scale_factor;

	// Minimum peak value that is included in detection.
	double detection_threshold;

	// Threshold relative to the previously detected peak in the image. The
	// rejection criteria is:
	// 	previous image score / current score > rejection_threshold.
	double rejection_threshold;

	// Max step for window sliding.
	int max_step;

	bool parse_from_file(const std::string& config_file) {
		std::ifstream in(config_file.c_str());
		if (!in.is_open()) {
			return false;
		}
		in >> scale_count;
		in >> scale_factor;
		in >> detection_threshold;
		in >> rejection_threshold;
		in >> max_step;
		return true;
	}
};

template <typename T>
void get_peaks(
		const cv::Mat& test_image,
		const ClassifierInterface<T>& classifier,
		const ImageClassifierParam& classifier_param,
		const FeatureChannelFactory& fcf,
		const PeakDetectionParams& detection_param,
		std::vector<PeakLocation>* detected_peaks,
		bool show_image);

// Groups nearby peaks and then merges into one regions.
// Removes merged regions that overlap with others.
inline void merge_peaks(std::vector<PeakLocation>* peaks,
												double merge_th = 0.8,
												double suppress_th = 0.6);

} // namespace utils
} // namespace common 
} // namespace learning


// Include template definitions.
#include "eval_utils.tpp"

#endif /* LEARNING_COMMON_EVAL_UTILS_HPP_ */
