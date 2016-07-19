/*
 * gist.cpp
 *
 *  Created on: Sep 11, 2012
 *      Author: lbossard
 */

#include "gist.hpp"

#include <numeric>

#include <opencv2/imgproc/imgproc.hpp>
#include <boost/shared_ptr.hpp>

#include "cpp/vision/image_utils.hpp"


namespace vision
{
namespace features
{
namespace global
{

namespace
{


	cv::Mat prepareCvImgGrey(const cv::Mat& bgr_img)
	{

		cv::Mat gray_mat = bgr_img;

		if (gray_mat.type() != CV_8U)
		{
			cv::cvtColor(bgr_img, gray_mat, CV_BGR2GRAY);
		}

		if (!gray_mat.isContinuous())
		{
			gray_mat = gray_mat.clone();
		}

		gray_mat.convertTo(gray_mat, CV_32F);

		return gray_mat;
	}

	struct BgrChannels
	{
		cv::Mat r_channel;
		cv::Mat g_channel;
		cv::Mat b_channel;

		void create(int rows, int cols)
		{
			r_channel.create(rows, cols, CV_32F);
			g_channel.create(rows, cols, CV_32F);
			b_channel.create(rows, cols, CV_32F);
		}

		void from_bgr_image(const cv::Mat_<cv::Vec3f>& bgr_img)
		{
			static const int from_to[] = { 0,2,  1,1,  2,0};

			this->create(bgr_img.rows, bgr_img.cols);
			cv::Mat out[] = { r_channel, g_channel, b_channel };

			cv::mixChannels(&bgr_img, 1,
							out, 3,
							from_to, 3 );
		}
	};


	void mat2GistColorImage(const BgrChannels& bgr_mat, color_image_t& img_t)
	{

		img_t.width = bgr_mat.r_channel.cols;
		img_t.height = bgr_mat.r_channel.rows;
		img_t.c1 = reinterpret_cast<float*>(bgr_mat.r_channel.data);     // r
		img_t.c2 = reinterpret_cast<float*>(bgr_mat.g_channel.data);     // g
		img_t.c3 = reinterpret_cast<float*>(bgr_mat.b_channel.data);     // b
	}

	void mat2ImagePtr(const cv::Mat_<float>& grey_mat, image_t& img_t)
	{
		img_t.width = grey_mat.cols;
		img_t.height = grey_mat.rows;
		img_t.stride = grey_mat.step.p[0];
		img_t.data = reinterpret_cast<float*>(grey_mat.data);

	}

	struct MallocDeleter
	{
	    void operator()(void* x)
	    {
	        free(x);
	    }
	};

}


void Gist::extractColor(const cv::Mat& img, cv::Mat_<float>& gist, const unsigned int n_blocks, const unsigned int a, const unsigned int b, const unsigned int c)
{
	std::vector<int> orientations_per_scale(3);
	orientations_per_scale[0] = a;
	orientations_per_scale[1] = b;
	orientations_per_scale[2] = c;
//	extractScaleTabColor(img, gist, n_blocks, orientations_per_scale);

}

void Gist::extract(const cv::Mat& img, cv::Mat_<float>& gist, const unsigned int n_blocks, const unsigned int a, const unsigned int b, const unsigned int c)
{
	std::vector<int> orientations_per_scale(3);
	orientations_per_scale[0] = a;
	orientations_per_scale[1] = b;
	orientations_per_scale[2] = c;
//	extractScaleTab(img, gist, n_blocks, orientations_per_scale);

}

//void Gist::extractScaleTabColor(const cv::Mat& img, cv::Mat_<float>& gist, const unsigned int n_blocks, const std::vector<int>& orientations_per_scale)
//{
//	const int num_scales = orientations_per_scale.size();
//	const int total_bin_count = std::accumulate(orientations_per_scale.begin(), orientations_per_scale.end(), 0);
//
//	BgrChannels img_channels;
//	color_image_t gist_img;
//
//
//	// prepare img
//	cv::Mat_<cv::Vec3f> float_img;
//	img.convertTo(float_img, CV_32F); // makes it continuous?
//	assert(float_img.isContinuous());
//	img_channels.from_bgr_image(float_img);
//	mat2GistColorImage(img_channels, gist_img);
//
//	// compute gist
//	boost::shared_ptr<float> descriptor(
//			::color_gist_scaletab(&gist_img, n_blocks, num_scales, &orientations_per_scale[0]),
//			MallocDeleter()
//			 );
//	if (descriptor == NULL)
//	{
//		gist.create(0,0);
//		return;
//	}
//
//	// copy to output
//	const int descriptor_dim = n_blocks * n_blocks * total_bin_count * 3;
//	gist.create(1, descriptor_dim);
//	::memcpy(gist.data, descriptor.get(), descriptor_dim * sizeof(float));
//
//}

//void Gist::extractScaleTab(const cv::Mat& img, cv::Mat_<float>& gist, const unsigned int n_blocks, const std::vector<int>& orientations_per_scale)
//{
//	const int num_scales = orientations_per_scale.size();
//	const int total_bin_count = std::accumulate(orientations_per_scale.begin(), orientations_per_scale.end(), 0);
//
//	// prepare img
//	cv::Mat gray_img = img;
//	image_t gist_img;
//	gray_img = prepareCvImgGrey(gray_img);
//	mat2ImagePtr(gray_img, gist_img);
//
//	// compute gist
//	boost::shared_ptr<float> descriptor(
//			::bw_gist_scaletab(&gist_img, n_blocks, num_scales , &orientations_per_scale[0]),
//			MallocDeleter());
//	if (descriptor == NULL)
//	{
//		gist.create(0,0);
//		return;
//	}
//
//	// copy to output
//	const std::size_t descriptor_dim = n_blocks * n_blocks * total_bin_count;
//	gist.create(1, descriptor_dim);
//	::memcpy(gist.data, descriptor.get(), descriptor_dim * sizeof(float));
//
//}


} /* namespace global */
} /* namespace features */
} /* namespace vision */
