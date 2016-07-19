/*
 * classifier_interface.hpp
 *
 *  Created on: May 24, 2013
 *      Author: Andrada Georgescu
 */

#ifndef LEARNING_COMMON_CLASSIFIER_INTERFACE_
#define LEARNING_COMMON_CLASSIFIER_INTERFACE_

#include <fstream>
#include <string>
#include <vector>
#include <opencv2/opencv.hpp>

#include "cpp/vision/features/feature_channels/feature_channel_factory.hpp"

namespace learning {
namespace common {

template <class Sample>
class ClassifierInterface {
public:
	virtual double predict(const Sample& sample) const = 0;

	virtual ~ClassifierInterface() {}
};

struct ImageClassifierParam {
public:
	ImageClassifierParam() {}

	ImageClassifierParam(const cv::Size& size,
											 const std::vector<int>& f)
		: patch_size(size),
			features(f) {}

	static bool parse_from_file(const std::string& config_file,
															ImageClassifierParam* param) {
		std::ifstream in(config_file.c_str());
		if (!in.is_open()) {
			return false;
		}
		int width, height;
		in >> width >> height;
		param->patch_size = cv::Size(width, height);
		size_t n;
		in >> n;
		param->features.resize(n);
		for (size_t i = 0; i < n; ++i) {
			std::string channel_name;
			in >> channel_name;
			param->features[i] =
				vision::features::feature_channels::FeatureChannelFactory::to_channel(channel_name);
		}
		in.close();
		return true;
	}

	// Size of training patches.
	cv::Size patch_size;

	// Training features.
	std::vector<int> features;
};

template <class Sample>
class ImageClassifier : virtual public ClassifierInterface<Sample> {
public:
	virtual void set_image_classifier_param(const ImageClassifierParam& param) {
		image_classifier_param_ = param;
	}

	virtual ImageClassifierParam image_classifier_param() const {
		return image_classifier_param_;
	};

protected:
	ImageClassifierParam image_classifier_param_;
};

} // namespace common
} // namespace learning

#endif /* LEARNING_COMMON_CLASSIFIER_INTERFACE_ */
