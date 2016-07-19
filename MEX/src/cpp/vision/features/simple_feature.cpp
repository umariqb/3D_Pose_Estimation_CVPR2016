/*
 * simple_feature.cpp
 *
 *  Created on: Jan 3, 2013
 *      Author: mdantone
 */

#include "cpp/vision/features/simple_feature.hpp"

namespace vision {
namespace features {

typedef boost::variate_generator<boost::mt19937&, boost::uniform_int<> >
	RandGen;

// PixelValueFeatuers implementation.
int PixelValueFeatuers::extract(const std::vector<cv::Mat>& images,
                                const cv::Rect& rect,
                                bool is_integral_image) const {
  CHECK(!is_integral_image);
  CHECK_LT(featureChannel, images.size());

  CHECK_LT((rect.x + point.x), images[featureChannel].cols);
  CHECK_LT((rect.x + point.x), images[featureChannel].cols);


  return images[featureChannel].at<unsigned char>(
      cv::Point(rect.x + point.x, rect.y + point.y));
}

void PixelValueFeatuers::generate(int width,
                                  int height,
                                  boost::mt19937* rng,
                                  int num_feature_channels) {
  if (num_feature_channels > 1) {
    boost::uniform_int<> dist_feat(0, num_feature_channels - 1);
    RandGen rand_feat(*rng, dist_feat);
    featureChannel = rand_feat();
  } else {
    featureChannel = 0;
  }

  boost::uniform_int<> dist_size_x(1, width-1);
  RandGen rand_x(*rng, dist_size_x);
  boost::uniform_int<> dist_size_y(1, height-1);
  RandGen rand_y(*rng, dist_size_y);

  point.x = rand_x();
}

void PixelValueFeatuers::print() {
  std::cout << "FC: " << featureChannel << std::endl;
  std::cout << "Point " << point.x << ", " << point.y << std::endl;
}




// SimplePatchFeature implementation.
void PatchComparisionFeature::generate(int patch_width,
                                  int patch_height,
                                  boost::mt19937* rng,
																	int num_feature_channels,
																	float max_sub_patch_ratio) {
  if (num_feature_channels > 1) {
      boost::uniform_int<> dist_feat(0, num_feature_channels - 1);
      RandGen rand_feat(*rng, dist_feat);
      featureChannel = rand_feat();
    } else {
      featureChannel = 0;
    }


    int width = patch_width * max_sub_patch_ratio;
    int height = patch_height * max_sub_patch_ratio;

    boost::uniform_int<> dist_size_x(1, width-1);
    RandGen rand_width(*rng, dist_size_x);
    boost::uniform_int<> dist_size_y(1, height-1);
    RandGen rand_height(*rng, dist_size_y);

    rectA.width = rand_width();
    rectA.height = rand_height();
    rectB.width = rand_width();
    rectB.height = rand_height();

    boost::uniform_int<> dist_x(0, patch_width - rectA.width - 1);
    RandGen rand_x(*rng, dist_x);
    rectA.x = rand_x();

    boost::uniform_int<> dist_y(0, patch_height - rectA.height - 1);
    RandGen rand_y(*rng, dist_y);
    rectA.y = rand_y();

    boost::uniform_int<> dist_x_b(0, patch_width - rectB.width - 1);
    RandGen rand_x_b(*rng, dist_x_b);
    rectB.x = rand_x_b();

    boost::uniform_int<> dist_y_b(0, patch_height - rectB.height - 1);
   	RandGen rand_y_b(*rng, dist_y_b);
    rectB.y = rand_y_b();

    CHECK_GE(rectA.x, 0);
    CHECK_GE(rectA.y, 0);
    CHECK_GE(rectB.x, 0);
    CHECK_GE(rectB.y, 0);
    CHECK_LT(rectA.x+rectA.width, patch_width);
    CHECK_LT(rectA.y+rectA.height, patch_height);
    CHECK_LT(rectB.x+rectB.width, patch_width);
    CHECK_LT(rectB.y+rectB.height, patch_height);
}

int PatchComparisionFeature::extract(const std::vector<cv::Mat>& featureChannels,
																const cv::Rect& rect,
																const int feature_channel,
																bool is_integral_image) {
	const cv::Mat& ptC = featureChannels[feature_channel];
	if (!is_integral_image) {
		return (sum(ptC(rect)))[0] / static_cast<float>(rect.width * rect.height);
	} else {
		float a = ptC.at<float>(rect.y, rect.x);
		float b = ptC.at<float>(rect.y, rect.x + rect.width);
		float c = ptC.at<float>(rect.y + rect.height, rect.x);
		float d = ptC.at<float>(rect.y + rect.height, rect.x + rect.width);
		return (d - b - c + a) / static_cast<float>(rect.width * rect.height);
	}
}

int PatchComparisionFeature::extract(const std::vector<cv::Mat>& images,
																const cv::Rect& rect,
																bool is_integral_image) const {
	cv::Rect rect_a = cv::Rect(rectA.x + rect.x, rectA.y + rect.y,
														 rectA.width, rectA.height);
	cv::Rect rect_b = cv::Rect(rectB.x + rect.x, rectB.y + rect.y,
														 rectB.width, rectB.height);

	return extract(images, rect_a, featureChannel, is_integral_image) -
		extract(images, rect_b, featureChannel, is_integral_image);
}

void PatchComparisionFeature::print() {
	std::cout << "FC: " << featureChannel << std::endl;
	std::cout << "Rect A " << rectA.x << ", " << rectA.y
						<< ", " << rectA.width << " " << rectA.height << std::endl;
	std::cout << "Rect B " << rectB.x << ", " << rectB.y
						<< ", " << rectB.width << " " << rectB.height << std::endl;
}




// SimplePixelFeature implementation.
int PixelComparisonFeature::extract(const std::vector<cv::Mat>& images,
																const cv::Rect& rect,
																bool is_integral_image) const {
	CHECK(!is_integral_image);
	CHECK_LT(featureChannel_a, images.size());
	CHECK_LT(featureChannel_b, images.size());

	CHECK_LT((rect.x + point_a.x), images[featureChannel_a].cols);
	CHECK_LT((rect.x + point_b.x), images[featureChannel_b].cols);
	CHECK_LT((rect.y + point_a.y), images[featureChannel_a].rows) << ", rect (" << rect.x << ", " << rect.y << ")" << ", point a (" << point_a.x << ", " << point_a.y << ")" ;
	CHECK_LT((rect.y + point_b.y), images[featureChannel_b].rows);


	unsigned char a = images[featureChannel_a].at<unsigned char>(
			cv::Point(rect.x + point_a.x, rect.y + point_a.y));
	unsigned char b = images[featureChannel_b].at<unsigned char>(
			cv::Point(rect.x + point_b.x, rect.y + point_b.y));
	return a - b;
}

void PixelComparisonFeature::generate(int width,
                                  int height,
																	boost::mt19937* rng,
																	int num_feature_channels,
																	int max_distance) {
	if (num_feature_channels > 1) {
		boost::uniform_int<> dist_feat(0, num_feature_channels - 1);
		RandGen rand_feat(*rng, dist_feat);
		featureChannel_a = rand_feat();
		featureChannel_b = featureChannel_a;
	} else {
		featureChannel_a = 0;
		featureChannel_b = 0;
	}

	boost::uniform_int<> dist_size_x(1, width-1);
	RandGen rand_x(*rng, dist_size_x);
	boost::uniform_int<> dist_size_y(1, height-1);
	RandGen rand_y(*rng, dist_size_y);

	point_a.x = rand_x();
	point_a.y = rand_y();
	while(true) {
		point_b.x = rand_x();
		point_b.y = rand_y();

		int d = sqrt((point_a.x - point_b.x) * (point_a.x - point_b.x) +
								 (point_a.y - point_b.y) * (point_a.y - point_b.y));

		if( d < max_distance ) {
			CHECK_LT(point_a.x, width);
			CHECK_LT(point_b.x, width);

			CHECK_LT(point_a.y, height);
			CHECK_LT(point_b.y, height);

			break;
		}
	}
}

void PixelComparisonFeature::print() {
	std::cout << "FC: " << featureChannel_a << std::endl;
	std::cout << "Point A " << point_a.x << ", " << point_a.y << std::endl;
	std::cout << "Point B " << point_b.x << ", " << point_b.y << std::endl;
}



// SimpleLineFeature implementation.
void SimpleLineFeature::extract(const std::vector<cv::Mat>& img,
																const cv::Rect& roi,
																std::vector<float>& desc) const {
	desc.resize(points.size());
	for (int i=0; i < points.size(); i++) {
		unsigned char a = img[featureChannel].at<unsigned char>(
				cv::Point(roi.x + points[i].x, roi.y + points[i].y));
		desc[i] = static_cast<float>(a) / 255;
	}
}

void SimpleLineFeature::generate(int patch_width,
                                 int patch_height,
                                 boost::mt19937* rng,
																 int num_feature_channels,
																 int num_points) {
	if (num_feature_channels > 1) {
		boost::uniform_int<> dist_feat(0, num_feature_channels - 1);
		RandGen rand_feat(*rng, dist_feat);
		featureChannel = rand_feat();
	} else {
		featureChannel = 0;
	}

  boost::uniform_int<> dist_size_x(1, patch_width-1);
  RandGen rand_x(*rng, dist_size_x);
  boost::uniform_int<> dist_size_y(1, patch_height-1);
  RandGen rand_y(*rng, dist_size_y);


	cv::Point start(rand_x(), rand_y());
	cv::Point end(rand_x(), rand_y());

	int dx = end.x - start.x;
	int dy = end.y - start.y;
	points.push_back(start);
	for (int i = 0; i < num_points - 2; i++) {
		cv::Point p = start;
		p.x += (dx / (num_points - 2)) * i;
		p.y += (dy / (num_points - 2)) * i;
		points.push_back(p);
	}
	points.push_back(end);
}

void SimpleLineFeature::show(int wait) {
	cv::Mat plot = cv::Mat(100,100, CV_8UC3);
	plot.setTo(0);
	for (int i=0; i <points.size(); i++) {
		cv::circle(plot, points[i], 1, cv::Scalar(255, 0, 255, 0));
	}

	cv::imshow("line feature", plot);
	cv::waitKey(wait);
}

// SURFFeature implementation.
void SURFFeature::extract(const std::vector<cv::Mat>& img,
													const cv::Rect& roi,
													std::vector<float>& desc) const {
	desc.resize(coordinates.size() * 4);

	bool is_integral_image = false;
	if (img[0].depth() == 5) {
		is_integral_image = true;
	}

	// extract descriptor
	for (int i = 0; i < coordinates.size(); i++) {
		cv::Rect rect = coordinates[i];
		rect.x += roi.x;
		rect.y += roi.y;

		int sum_dx_pos = PatchComparisionFeature::extract(img, rect, 0,
																								 is_integral_image);
		int sum_dx_neg = PatchComparisionFeature::extract(img, rect, 1,
																								 is_integral_image);
		int sum_dy_pos = PatchComparisionFeature::extract(img, rect, 2,
																								 is_integral_image);
		int sum_dy_neg = PatchComparisionFeature::extract(img, rect, 3,
																								 is_integral_image);
		desc[i * 4 + 0] = sum_dx_pos - sum_dx_neg;
		desc[i * 4 + 1] = sum_dx_pos + sum_dx_neg;
		desc[i * 4 + 2] = sum_dy_pos - sum_dy_neg;
		desc[i * 4 + 3] = sum_dy_pos + sum_dy_neg;
	}

	// normalize desc
	float val, sqlen = 0.0, fac;
	for (int i =0; i < desc.size(); i++) {
		val = desc[i];
		sqlen += val * val;
	}
	if (sqlen > 0) {
		fac = 1.0 / sqrt(sqlen);
		for(int i = 0; i < desc.size(); i++) {
			desc[i] *= fac;
		}
	}
}

void SURFFeature::generate(int patch_width,
													 int patch_height,
													 const cv::Rect& bbox,
													 int num_feature_channels) {
	CHECK_EQ(num_feature_channels, 4);
	CHECK_LT(bbox.x, patch_width);
	CHECK_LE(bbox.x + bbox.width, patch_width);
	CHECK_LT(bbox.y, patch_height);
	CHECK_LE(bbox.y + bbox.height, patch_height);

	// devide bbox into 4 subrectangles
	int w_0 = bbox.x;
	int h_0 = bbox.y;
	int w_2 = bbox.width/2;
	int h_2 = bbox.height/2;
	coordinates.push_back(cv::Rect(w_0, 			h_0, 				w_2, h_2));
	coordinates.push_back(cv::Rect(w_0 + w_2, h_0,				w_2, h_2));
	coordinates.push_back(cv::Rect(w_0, 			h_0 + h_2, 	w_2, h_2));
	coordinates.push_back(cv::Rect(w_0 + w_2, h_0 + h_2, 	w_2, h_2));

	//LOG(INFO) <<  bbox.x << " " <<  bbox.y << " " << bbox.width << " " << bbox.height;
	//show(0, patch_width, patch_height);
}

void SURFFeature::generate(int patch_width,
													 int patch_height,
													 boost::mt19937* rng,
													 int num_feature_channels) {
	const int MIN_SIZE = 8;

	CHECK_GE(patch_width, MIN_SIZE);
	CHECK_GE(patch_height, MIN_SIZE);

	boost::uniform_int<> dist_width(0, patch_width - MIN_SIZE);
	RandGen rand_width(*rng, dist_width);

	boost::uniform_int<> dist_height(0, patch_height - MIN_SIZE);
	RandGen rand_height(*rng, dist_height);

	cv::Rect bbox;
	bbox.width = rand_width() + MIN_SIZE;
	bbox.height = rand_height() + MIN_SIZE;

	boost::uniform_int<> dist_x(0, patch_width - bbox.width);
	RandGen rand_x(*rng, dist_x);
	bbox.x = rand_x();

	boost::uniform_int<> dist_y(0, patch_height - bbox.height);
	RandGen rand_y(*rng, dist_y);
	bbox.y = rand_y();

	bbox.width = std::min(bbox.width, patch_width - bbox.x);
	bbox.height = std::min(bbox.height, patch_height - bbox.y);

	generate(patch_width, patch_height, bbox, num_feature_channels);
}

void SURFFeature::show(int wait, int w, int h) const {
	cv::Mat plot = cv::Mat(h, w, CV_8UC3);
	plot.setTo(0);
	for( int i=0; i <coordinates.size(); i++ ){
		cv::rectangle(plot, coordinates[i],cv::Scalar(255, 0, 255, 0));
	}

	cv::imshow("surf feature", plot);
	cv::waitKey(wait);
}

void T2SURFFeature::extract(const std::vector<cv::Mat>& img,
														const cv::Rect& roi,
														std::vector<float>& desc) const {
	desc.resize(coordinates.size() * 8);

	bool is_integral_image = false;
	if (img[0].depth() == 5) {
		is_integral_image = true;
	}

	// extract descriptor
	for (int i = 0; i < coordinates.size(); i++) {
		cv::Rect rect = coordinates[i];
		rect.x += roi.x;
		rect.y += roi.y;

		int sum_dx_pos = PatchComparisionFeature::extract(img, rect, 0,
																								 is_integral_image);
		int sum_dx_neg = PatchComparisionFeature::extract(img, rect, 1,
																								 is_integral_image);
		int sum_dy_pos = PatchComparisionFeature::extract(img, rect, 2,
																								 is_integral_image);
		int sum_dy_neg = PatchComparisionFeature::extract(img, rect, 3,
																								 is_integral_image);
		desc[i * 8 + 0] = sum_dx_pos - sum_dx_neg;
		desc[i * 8 + 1] = sum_dx_pos + sum_dx_neg;
		desc[i * 8 + 2] = sum_dy_pos - sum_dy_neg;
		desc[i * 8 + 3] = sum_dy_pos + sum_dy_neg;

		int sum_dxt_pos = PatchComparisionFeature::extract(img, rect, 4,
																									is_integral_image);
		int sum_dxt_neg = PatchComparisionFeature::extract(img, rect, 5,
																									is_integral_image);
		int sum_dyt_pos = PatchComparisionFeature::extract(img, rect, 6,
																									is_integral_image);
		int sum_dyt_neg = PatchComparisionFeature::extract(img, rect, 7,
																								 is_integral_image);
		desc[i * 8 + 4] = sum_dxt_pos - sum_dxt_neg;
		desc[i * 8 + 5] = sum_dxt_pos + sum_dxt_neg;
		desc[i * 8 + 6] = sum_dyt_pos - sum_dyt_neg;
		desc[i * 8 + 7] = sum_dyt_pos + sum_dyt_neg;
	}

	// L2 normalization. 
	float sqlen = 1e-6;
	for (int i = 0; i < desc.size(); i++) {
		sqlen += desc[i] * desc[i];
	}
	float f = 1.0 / sqrt(sqlen);
	for (int i = 0; i < desc.size(); i++) {
		desc[i] *= f;
	}

	// Clipping.
	const float theta = 2.0 / sqrt(desc.size());
	for (int i = 0; i < desc.size(); ++i) {
		desc[i] = std::min(desc[i], theta);
		desc[i] = std::max(desc[i], -theta);
	}

	// Again L2 normalization. 
	sqlen = 1e-6;
	for (int i = 0; i < desc.size(); i++) {
		sqlen += desc[i] * desc[i];
	}
	f = 1.0 / sqrt(sqlen);
	for (int i = 0; i < desc.size(); i++) {
		desc[i] *= f;
	}
}

} // namespace features
} // namespace vision
