/*
 * holbp.hpp
 *
 *  Created on: Oct 12, 2013
 *      Author: mdantone
 */

#ifndef HOLBP_HPP_
#define HOLBP_HPP_

#include "lbp.hpp"
#include "low_level_feature_extractor.hpp"
#include <opencv2/objdetect/objdetect.hpp>

namespace vision {
namespace features {


class HoLbp : public LowLevelFeatureExtractor {
public:
  HoLbp( int cell_size_ = 16, int step_width_ = 1, int grid_width_ = 4) :
      cell_size(cell_size_), step_width(step_width_), grid_width(grid_width_) {
  };


  ~HoLbp() {};

  virtual void extract_at_extremas(const cv::Mat& image,
           cv::Mat_<float>* descriptors,
           const cv::Mat_<uchar>& mask) const {
    CHECK(false) << "not implemented.";
  }

  virtual unsigned int descriptorLength() const;

  virtual cv::Mat_<float> denseExtract(
              const cv::Mat& image,
              std::vector<cv::Point>& descriptor_locations,
              const cv::Mat_<uchar>& mask = cv::Mat_<char>()
              ) const;

private:

  void denseExtract( const cv::Mat_<uchar>& img_src,
                cv::Mat_<int>& img_dst,
                const cv::Mat_<uchar>& mask,
                int step_width) const;

  void exract_hist( const cv::Mat_<uchar>& image,
                    cv::Mat_<float>& desc,
                    const cv::Mat_<uchar>& mask) const ;

  void exract_hist( const cv::Mat_<uchar>& image,
                    const cv::Mat_<int>& lbp,
                    cv::Mat_<float>& desc) const;

  int cell_size;  // lbp hist cell size
  int step_width; // lbp stepwidht
  int grid_width; // stepsize grid


};

} /* namespace features */
} /* namespace vision */
#endif /* HOLBP_HPP_ */
