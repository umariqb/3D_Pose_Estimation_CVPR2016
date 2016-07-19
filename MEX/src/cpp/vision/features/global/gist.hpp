/*
 * gist.hpp
 *
 *  Created on: Sep 11, 2012
 *      Author: lbossard
 */

#ifndef VISION__FEATURES__GLOBAL__GIST_HPP_
#define VISION__FEATURES__GLOBAL__GIST_HPP_

#include <vector>

#include <opencv2/core/core.hpp>

extern "C" {
	#include "cpp/third_party/lear_gist/gist.h"
	#include "cpp/third_party/lear_gist/standalone_image.h"
}


namespace vision
{
namespace features
{
namespace global
{

class Gist
{
public:

	virtual ~Gist();

	static void extractColor(
			const cv::Mat& img,
			cv::Mat_<float>& gist,
			unsigned int n_blocks=4,
			unsigned int a=8,
			unsigned int b=8,
			unsigned int c=4);

	static void extract(const cv::Mat& img,
			cv::Mat_<float>& gist,
			unsigned int n_blocks=4,
			unsigned int a=8,
			unsigned int b=8,
			unsigned int c=4);

	static void extractScaleTabColor(const cv::Mat& img, cv::Mat_<float>& gist, const unsigned int n_blocks, const std::vector<int>& orientations_per_scale);

	static void extractScaleTab(const cv::Mat& img, cv::Mat_<float>& gist, const unsigned int n_blocks, const std::vector<int>& orientations_per_scale);

private:
	Gist();

};

} /* namespace global */
} /* namespace features */
} /* namespace vision */
#endif /* VISION__FEATURES__GLOBAL__GIST_HPP_ */
