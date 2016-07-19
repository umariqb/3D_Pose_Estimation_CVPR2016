/*
 * eval_utils.hpp
 *
 *  Created on: Apr 24, 2013
 *      Author: gandrada
 */

#ifndef LEARNING_EVAL_UTILS_HPP_
#define LEARNING_EVAL_UTILS_HPP_

#include <fstream>

#include <opencv2/opencv.hpp>

#include "cpp/learning/common/image_sample.hpp"
#include "cpp/learning/forest/forest.hpp"
#include "cpp/utils/string_utils.hpp"
#include "cpp/vision/features/feature_channels/feature_channel_factory.hpp"

namespace learning {
namespace forest {
namespace utils {


template <typename T>
void evaluate_binary_problem(
    const Forest<T>& forest,
		const std::vector<T>& sample,
		std::vector<float>* responses);

template <typename T>
void get_voting_map(
		const learning::common::Image& sample,
		const Forest<T>& forest,
		cv::Mat& voting_map,
		const cv::Rect roi,
		int step_size = 1,
		bool blur = true,
		bool normalize = false,
		cv::Rect sliding_window = cv::Rect(0,0,0,0));

template <typename T>
void get_conditional_voting_map(
		const learning::common::Image& sample,
		const Forest<T>& forest,
		cv::Mat& voting_map,
		const cv::Rect roi,
		int step_size = 1,
		bool blur = true,
		bool normalize = false,
		cv::Rect sliding_window = cv::Rect(0,0,0,0),
    std::vector<double> cond_reg_weights = std::vector<double>());

template <typename T>
void get_attr_wise_conditional_voting_map(
		const learning::common::Image& sample,
		const Forest<T>& forest,
		std::vector<cv::Mat_<float> >& voting_maps,
		const cv::Rect roi,
		int step_size = 1,
		bool blur = true,
		bool normalize = true,
		cv::Rect sliding_window = cv::Rect(0,0,0,0),
		std::vector<double> cond_reg_weights = std::vector<double>());

// sliding window multi-class forest
template <typename T>
void eval_mc_forest(
		const Forest<T>& forest,
		const learning::common::Image& sample,
    int num_classes,
		int step_size,
    cv::vector<cv::Mat>& voting_maps,
		cv::Mat& foreground_map,
		bool use_class_weights = false,
		bool blurr = true);

} // namespace utils
} // namespace forest
} // namespace learning


// Include template definitions.
#include "eval_utils.tpp"

#endif /* LEARNING_EVAL_UTILS_HPP_ */
