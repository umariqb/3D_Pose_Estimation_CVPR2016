/*
 * Extractor.hpp
 *
 *  Created on: Jan 14, 2014
 *      Author: mdantone
 */

#ifndef EXTRACTOR_HPP_
#define EXTRACTOR_HPP_

#include <boost/noncopyable.hpp>
#include <opencv2/core/core.hpp>

namespace vision {
namespace features {

  class Extractor : boost::noncopyable {
    public:

    virtual int feature_dimensions() = 0;


    virtual void extract_features( const cv::Mat& image,
                           cv::Mat_<int>& features,
                           const cv::Mat_<uchar>& mask = cv::Mat()) = 0;

    Extractor(){};
    virtual ~Extractor(){};
  };

} /* namespace features */
} /* namespace vision */
#endif /* EXTRACTOR_HPP_ */
