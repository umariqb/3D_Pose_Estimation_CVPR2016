/*
 * min_max_filter.hpp
 *
 *  Created on: Oct 6, 2013
 *      Author: mdantone
 */

#ifndef MIN_MAX_FILTER_HPP_
#define MIN_MAX_FILTER_HPP_

#include "opencv2/core/core.hpp"

namespace vision {

class MinMaxFilter {

public:
  static void maxfilt(cv::Mat &src, unsigned int width);

  static void minfilt(cv::Mat &src, cv::Mat &dst, unsigned int width);

  static void maxfilt(uchar* data, uchar* maxvalues, unsigned int step,
                      unsigned int size, unsigned int width);

  static void maxfilt(uchar* data, unsigned int step, unsigned int size,
                      unsigned int width);

  static void minfilt(uchar* data, uchar* minvalues, unsigned int step,
                      unsigned int size, unsigned int width);

  static void minfilt(uchar* data, unsigned int step, unsigned int size,
                      unsigned int width);


};

} /* namespace vision */
#endif /* MIN_MAX_FILTER_HPP_ */
