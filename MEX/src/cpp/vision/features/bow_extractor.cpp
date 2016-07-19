/*
 * BowExtractor.cpp
 *
 *  Created on: Oct 14, 2011
 *      Author: lbossard
 */

#include "bow_extractor.hpp"
#include <iostream>
#include <glog/logging.h>

namespace vision
{
namespace features
{

cvflann::SearchParams create_params(cvflann::flann_algorithm_t algo)
{
    cvflann::SearchParams p;
    p["algorithm"] = algo ;
    return p;

}


BowExtractor::BowExtractor(const cv::Mat_<float>& vocabulary, cvflann::flann_algorithm_t algo)
: vocabulary_(vocabulary),
  search_params_(create_params(algo )),
  index_(vocabulary_, search_params_) {
}

BowExtractor::~BowExtractor() {
}



void BowExtractor::match(const cv::Mat_<float>& features, std::vector<WordId>& words)
{
    if (features.cols != vocabulary_.cols)
    {
        std::cerr << "WARNING: feature dimension does not match vocabulary dimension" << std::endl;
        std::cerr << "features.cols: " << features.cols << std::endl;
        std::cerr << "vocabulary_.cols: " << vocabulary_.cols << std::endl;
    }

    static const int knn = 1;
    words.resize(features.rows);
    cv::Mat_<int> indices(words, false);
    cv::Mat_<float> dists;

    match(features, indices, dists, knn);
}

void BowExtractor::match(
        const cv::Mat_<float>& features,
        cv::Mat_<WordId>& indices,
        cv::Mat_<float>& dists,
        unsigned int knn)
{
    const std::size_t feature_count = features.rows;
    indices.create(feature_count, knn);
    dists.create(feature_count, knn);

    index_.knnSearch(features, indices, dists, knn, search_params_);
}


void BowExtractor::sumPool( const std::vector<WordId>& words,
                const std::vector<cv::Point>& locations,
                const cv::Rect& roi,
                const cv::Mat_<uchar>& mask,
                const unsigned int levels,
                RowHistograms& histograms
                ) const
{

    BowExtractor::sumPool(words, locations, roi, mask, this->wordCount(), levels, histograms);
}

void BowExtractor::createHistogram(
        const std::vector<WordId>& words,
        const std::vector<cv::Point>& locations,
        const cv::Rect& roi,
        const cv::Mat_<uchar>& mask,
        RowHistograms& histogram)  const
{
    BowExtractor::createHistogram(words, locations, roi, mask, this->wordCount(), histogram);
}



} /* namespace features */
} /* namespace vision */
