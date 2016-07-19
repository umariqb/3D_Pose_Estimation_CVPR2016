/*
 * hog_extractor.h
 *
 *  Created on: Mar 22, 2012
 *      Author: mdantone
 */

#ifndef HOG_EXTRACTOR_H_
#define HOG_EXTRACTOR_H_

#include "cpp/third_party/hog/hog.h"


namespace vision {
namespace features {
namespace feature_channels {

class HOGExtractor {
public:
	void extractFeatureChannels(const cv::Mat& img,
															std::vector<cv::Mat>& channels);

	void extractFeatureChannels9(const cv::Mat& img,
	                              std::vector<cv::Mat>& Channels,
	                              bool use_max_filter = true);

	void extractFeatureChannels15(const cv::Mat& img,
																std::vector<cv::Mat>& channels);

private:
	HoG hog;
};

} // namespace vision 
} // namespace features
} // namespace feature_channels
#endif /* HOG_EXTRACTOR_H_ */
