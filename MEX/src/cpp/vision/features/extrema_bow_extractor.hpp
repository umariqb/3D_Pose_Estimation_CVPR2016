/*
 * extrema_bow_extractor.hpp
 *
 *  Created on: Aug 15, 2013
 *      Author: mdantone
 */

#ifndef SURF_BOW_EXTRACTOR_HPP_
#define SURF_BOW_EXTRACTOR_HPP_
#include "bow_extractor.hpp"
#include "cpp/vision/features/low_level_features.hpp"

#include <boost/noncopyable.hpp>
#include <boost/scoped_ptr.hpp>

namespace vision {
namespace features {

class ExtremaBowExtractor : boost::noncopyable {

public:

  ExtremaBowExtractor(std::string feature_typestr,
                      const cv::Mat_<float>& vocabulary);

  ExtremaBowExtractor(const vision::features::feature_type::T feature_type,
                      const cv::Mat_<float>& vocabulary);

  void extract(const cv::Mat& image,
               cv::Mat_<int>& histogram,
               const cv::Mat_<uchar>& mask = cv::Mat_<char>() );
private:

  BowExtractor bow_extractor_;
  boost::scoped_ptr<vision::features::LowLevelFeatureExtractor> extractor;

};

} /* namespace features */
} /* namespace vision */
#endif /* SURF_BOW_EXTRACTOR_HPP_ */
