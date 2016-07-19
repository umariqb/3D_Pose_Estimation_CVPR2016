/*
 * surf_bow_extractor.cpp
 *
 *  Created on: Aug 15, 2013
 *      Author: mdantone
 */

#include "extrema_bow_extractor.hpp"

#include "glog/logging.h"

namespace vf = vision::features;

namespace vision {
namespace features {

ExtremaBowExtractor::ExtremaBowExtractor(std::string feature_typestr,
    const cv::Mat_<float>& vocabulary):
        bow_extractor_(vocabulary),
        extractor(vf::ExtractorFactory::createExtractor(
            vf::feature_type::from_string(feature_typestr))) {
}

ExtremaBowExtractor::ExtremaBowExtractor(const vision::features::feature_type::T f_type,
    const cv::Mat_<float>& vocabulary)
    : bow_extractor_(vocabulary), extractor(vf::ExtractorFactory::createExtractor(f_type)){
}


void ExtremaBowExtractor::extract(const cv::Mat& image,
             cv::Mat_<int>& histogram,
             const cv::Mat_<uchar>& mask ) {

  histogram = cv::Mat::zeros(1,bow_extractor_.wordCount(),cv::DataType<int>::type);

  cv::Mat_<float> desc;
  extractor->extract_at_extremas(image, &desc, mask);
  if(desc.rows > 0) {
    cv::Mat_<float> dists;
    static const int knn = 1;

    cv::Mat_<int> indices;
    bow_extractor_.match(desc, indices, dists, knn);

    for(int i=0; i < indices.rows; i++) {
      histogram(indices(i)) ++;
    }
  }
}

} /* namespace features */
} /* namespace vision */
