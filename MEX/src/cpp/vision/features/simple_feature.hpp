/*
 * simple_feature.hpp
 *
 *  Created on: Jan 3, 2013
 *      Author: mdantone
 */

#ifndef VISION_FEATURE_SIMPLE_FEATURE_HPP_
#define VISION_FEATURE_SIMPLE_FEATURE_HPP_

#include <opencv2/opencv.hpp>
#include <boost/random.hpp>
#include <glog/logging.h>
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>
#include <opencv2/highgui/highgui.hpp>

#include "cpp/utils/serialization/opencv_serialization.hpp"
#include <boost/serialization/split_member.hpp>

namespace vision {
namespace features {


class DummyFeature {
public:
  DummyFeature(){};

private:
  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {

  }
};

class FeatureInterface {
public:
	virtual void extract(const std::vector<cv::Mat>& feature_channels,
											 const cv::Rect& roi,
											 std::vector<float>& descriptor) const = 0;

	virtual ~FeatureInterface() {}
};

class PixelValueFeatuers {
public:
  PixelValueFeatuers(): featureChannel(-1){};
  int featureChannel;
  cv::Point_<int> point;


  void print();

  int extract(const std::vector<cv::Mat>& images,
              const cv::Rect& rect,
              bool is_integral_image) const;

  void generate(int patch_width,
                int patch_height,
                boost::mt19937* rng,
                int num_feature_channels = 0);

  void generate(int patch_size,
                boost::mt19937* rng,
                int num_feature_channels = 0,
                float max_sub_patch_ratio = 1) {
    generate(patch_size, patch_size, rng, num_feature_channels);
  }

  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {
    ar & featureChannel;
    ar & point;
  }
};




class PatchComparisionFeature {
public:
  int featureChannel;
  cv::Rect_<int> rectA;
  cv::Rect_<int> rectB;

  void print();

	void generate(int patch_width,
                int patch_height,
                boost::mt19937* rng,
                int num_feature_channels = 0,
                float max_sub_patch_ratio = 1.0);

	static int extract(const std::vector<cv::Mat>& featureChannels,
										 const cv::Rect& rect,
										 const int feature_channel,
										 bool is_integral_image);

  int extract(const std::vector<cv::Mat>& images,
							const cv::Rect& rect,
							bool is_integral_image) const;

  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {
    ar & featureChannel;
    ar & rectA;
    ar & rectB;
  }
};


class PixelComparisonFeature {
public:
  PixelComparisonFeature(): featureChannel_a(-1), featureChannel_b(-1), type(true){};
  int featureChannel_a;
  int featureChannel_b;
  cv::Point_<int> point_a;
  cv::Point_<int> point_b;
  bool type;

	void print();

	int extract(const std::vector<cv::Mat>& images,
							const cv::Rect& rect,
							bool is_integral_image) const;

  void generate(int patch_width,
                int patch_height,
                boost::mt19937* rng,
                int num_feature_channels = 0,
                int max_distance = 24);

  void generate(int patch_size,
                boost::mt19937* rng,
                int num_feature_channels = 0,
                float max_sub_patch_ratio = 0.5) {
		generate(patch_size, patch_size, rng, num_feature_channels,
						 patch_size * max_sub_patch_ratio);
	}

  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {
    ar & featureChannel_a;
    ar & featureChannel_b;
    ar & point_a;
    ar & point_b;
		// ar & type;
  }
};

class SimpleLineFeature {

public:
	SimpleLineFeature() : featureChannel(0) {}

  int featureChannel;
  std::vector<cv::Point_<int> > points;

	void extract(const std::vector<cv::Mat>& img,
							 const cv::Rect& roi,
							 std::vector<float>& desc) const;

  void generate(int patch_width,
                int patch_height,
                boost::mt19937* rng,
                int num_feature_channels = 0,
                int num_points = 5);

	void show(int wait = 0);

private:
  friend class boost::serialization::access;
  template<class Archive>
	void serialize(Archive & ar, const unsigned int version) {
      ar & featureChannel;
      ar & points;
  }
};

class SURFFeature : public FeatureInterface {
public:
  SURFFeature() {}

	virtual void extract(const std::vector<cv::Mat>& img,
											 const cv::Rect& roi,
											 std::vector<float>& desc) const;

	virtual void generate(int patch_width,
												int patch_height,
												const cv::Rect& bbox,
												int num_feature_channels = 4);

	virtual void generate(int patch_width,
												int patch_height,
												boost::mt19937* rng,
												int num_feature_channels);

	virtual void generate(int patch_size,
												boost::mt19937* rng,
												int num_feature_channels) {
		generate(patch_size, patch_size, rng, num_feature_channels);
  }

  void show(int wait = 0, int w = 100, int h = 100) const;

	bool compare_rect(const cv::Rect& r1, const cv::Rect& r2) const {
		if (r1.x != r2.x) {
			return r1.x < r2.x;
		}
		if (r1.y != r2.y) {
			return r1.y < r2.y;
		}
		if (r1.width != r2.width) {
			return r1.width < r2.width;
		}
		return r1.height < r2.height;
	}

	bool operator<(const SURFFeature& other) const {
		if (coordinates.size() != other.coordinates.size()) {
			return coordinates.size() < other.coordinates.size();
		}
		for (size_t i = 0; i < coordinates.size(); ++i) {
			if (coordinates[i] != other.coordinates[i]) {
				return compare_rect(coordinates[i], other.coordinates[i]);
			}
		}
		return false;
	}

protected:
  std::vector<cv::Rect> coordinates;

  friend class boost::serialization::access;
  template<class Archive>
	void serialize(Archive & ar, const unsigned int version) {
		ar & coordinates;
  }
};

class T2SURFFeature : public SURFFeature {
public:
  T2SURFFeature() {}

	T2SURFFeature(int patch_width, int patch_height,
								const cv::Rect& bbox,
								int xratio = 1, int yratio = 1) {
		CHECK_LT(bbox.x, patch_width);
		CHECK_LE(bbox.x + bbox.width, patch_width);
		CHECK_LT(bbox.y, patch_height);
		CHECK_LE(bbox.y + bbox.height, patch_height);
		CHECK((xratio == 1 && yratio == 1) ||
					(xratio == 4 && yratio == 1) ||
					(xratio == 1 && yratio == 4));
		CHECK(bbox.width % xratio == 0);
		CHECK(bbox.height % yratio == 0);

		if (xratio == 1 && yratio == 1) {
			generate11(bbox);
		} else if (xratio == 1 && yratio == 4) {
			generate14(bbox);
		} else if (xratio == 4 && yratio == 1) {
			generate41(bbox);
		}
		//show(0, patch_width, patch_height);
	}

	void generate11(const cv::Rect& bbox) {
		// devide bbox into 4 subrectangles
		int w_0 = bbox.x;
		int h_0 = bbox.y;
		int w_2 = bbox.width/2;
		int h_2 = bbox.height/2;
		coordinates.push_back(cv::Rect(w_0, 			h_0, 				w_2, h_2));
		coordinates.push_back(cv::Rect(w_0 + w_2, h_0,				w_2, h_2));
		coordinates.push_back(cv::Rect(w_0, 			h_0 + h_2, 	w_2, h_2));
		coordinates.push_back(cv::Rect(w_0 + w_2, h_0 + h_2, 	w_2, h_2));
	}

	void generate14(const cv::Rect& bbox) {
		int w = bbox.width;
		int h_4 = bbox.height / 4;
		coordinates.push_back(cv::Rect(bbox.x, bbox.y + 0 * h_4, w, h_4));
		coordinates.push_back(cv::Rect(bbox.x, bbox.y + 1 * h_4, w, h_4));
		coordinates.push_back(cv::Rect(bbox.x, bbox.y + 2 * h_4, w, h_4));
		coordinates.push_back(cv::Rect(bbox.x, bbox.y + 3 * h_4, w, h_4));
	}

	void generate41(const cv::Rect& bbox) {
		int w_4 = bbox.width / 4;
		int h = bbox.height;
		coordinates.push_back(cv::Rect(bbox.x + 0 * w_4, bbox.y, w_4, h));
		coordinates.push_back(cv::Rect(bbox.x + 1 * w_4, bbox.y, w_4, h));
		coordinates.push_back(cv::Rect(bbox.x + 2 * w_4, bbox.y, w_4, h));
		coordinates.push_back(cv::Rect(bbox.x + 3 * w_4, bbox.y, w_4, h));
	}

	void extract(const std::vector<cv::Mat>& img,
							 const cv::Rect& roi,
							 std::vector<float>& desc) const;
};




class ExemplarHoGFeature {
public:

  ExemplarHoGFeature(): hog_blockSize_(cv::Size(16,16)),
    hog_blockStride_(cv::Size(8,8)),
    hog_cellSize_(cv::Size(8,8)),
    hog_nbins_(9){

    };

  int extract(const std::vector<cv::Mat>& images,
              const cv::Rect& rect,
              bool is_integral_image) const {
    std::vector<float> desc;
    extract(images, rect, desc);
    CHECK_GT(svm_weights_.size(), 0);
    float result =  0;
    for(unsigned int i=0; i < desc.size(); i++) {
      result += (desc[i]*svm_weights_[i]);
    }
    return result*100;
  }

  void extract(const std::vector<cv::Mat>& img,
                       const cv::Rect& roi,
                       std::vector<float>& desc) const {

    CHECK_EQ(roi.width, hog_win_size_.width);
    CHECK_EQ(roi.height, hog_win_size_.height);
    std::vector<cv::Point> locations;
    locations.push_back(cv::Point(roi.x, roi.y));
    hog_extractor_.compute(img[0], desc, cv::Size(), cv::Size(), locations);
  }

  void generate(int patch_width,
                int patch_height,
                boost::mt19937* rng,
                int num_feature_channels = 0) {
    CHECK_EQ(num_feature_channels, 1);

    hog_win_size_ = cv::Size(patch_width, patch_height);
    CHECK_EQ((hog_win_size_.width - hog_blockSize_.width) % hog_blockStride_.width , 0);
    CHECK_EQ((hog_win_size_.height - hog_blockSize_.height) % hog_blockStride_.height, 0);

    // creating the hog-extractor
    hog_extractor_ = cv::HOGDescriptor(hog_win_size_,
                                   hog_blockSize_,
                                   hog_blockStride_,
                                   hog_cellSize_,
                                   hog_nbins_);

  }

  void set_svm_weights(std::vector<float> svm_weights) {
    svm_weights_ = svm_weights;
  }

private:

  cv::HOGDescriptor hog_extractor_;
  cv::Size hog_win_size_;
  cv::Size hog_blockSize_;
  cv::Size hog_blockStride_;
  cv::Size hog_cellSize_;
  int hog_nbins_;

  std::vector<float> svm_weights_;

  friend class boost::serialization::access;
  template <class Archive>
  void load(Archive& ar, const unsigned int version) {
    ar & hog_blockSize_;
    ar & hog_blockStride_;
    ar & hog_cellSize_;
    ar & hog_nbins_;
    ar & hog_win_size_;
    ar & svm_weights_;
    hog_extractor_ = cv::HOGDescriptor(hog_win_size_, hog_blockSize_,
                                       hog_blockStride_, hog_cellSize_,
                                       hog_nbins_);
  }

  template <class Archive>
  void save(Archive& ar, const unsigned int version) const {
    ar & hog_blockSize_;
    ar & hog_blockStride_;
    ar & hog_cellSize_;
    ar & hog_nbins_;
    ar & hog_win_size_;
    ar & svm_weights_;
  }

  BOOST_SERIALIZATION_SPLIT_MEMBER();


};



} // namespace features
} // namespace vision

#endif /* VISION_FEATURE_SIMPLE_FEATURE_HPP_ */
