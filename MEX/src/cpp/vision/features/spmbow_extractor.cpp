/*
 * spmbow_extractor.cpp
 *
 *  Created on: Oct 29, 2011
 *      Author: lbossard
 */

#include <glog/logging.h>

#include "spmbow_extractor.hpp"
#include "cpp/utils/serialization/opencv_serialization.hpp"
#include "cpp/utils/serialization/serialization.hpp"

namespace vision
{
namespace features
{

SpmBowExtractor::SpmBowExtractor(unsigned int pyramid_levels,
    cv::Mat& surf_voc,
    cv::Mat& hog_voc,
    cv::Mat& color_voc,
    cv::Mat& ssd_voc,
    const cv::Mat& holbp_voc,
    const cv::Mat& dense_surf_voc)
:
  pyramid_levels_(pyramid_levels),
  surf_(surf_voc),
  hog_(hog_voc),
  color_(color_voc),
  ssd_(ssd_voc),
	holbp_(holbp_voc),
	dense_surf_(dense_surf_voc),
	feature_types_(vision::features::feature_type::None)
{

}

SpmBowExtractor::SpmBowExtractor( unsigned int pyramid_levels,
        feature_type::T feature_types,
        cv::Mat& surf_voc,
        cv::Mat& hog_voc,
        cv::Mat& color_voc,
        cv::Mat& ssd_voc,
        const cv::Mat& holbp_voc,
        const cv::Mat& dense_surf_voc) :
      pyramid_levels_(pyramid_levels),
      surf_(surf_voc),
      hog_(hog_voc),
      color_(color_voc),
      ssd_(ssd_voc),
      holbp_(holbp_voc),
      dense_surf_(dense_surf_voc),
      feature_types_(feature_types) {

}

SpmBowExtractor::~SpmBowExtractor()
{
}

void SpmBowExtractor::extractSpm(
            const cv::Mat& image,
            cv::Mat_<int>& spm_histogram,
            feature_type::T feature_types)
{
    static const cv::Mat_<uchar> mask;
    extractSpm(image, mask, spm_histogram, feature_types);
}

void SpmBowExtractor::extractSpm(const cv::Mat& image, const cv::Mat_<uchar>& mask, cv::Mat_<int>& spm_histogram, feature_type::T feature_types)
{
    const std::size_t histogram_count = BowExtractor::getHistogramCount(pyramid_levels_);
    const cv::Rect roi = cv::Rect(0,0, image.cols, image.rows);

    const std::size_t histo_dim = compute_histogram_length(feature_types, histogram_count);
    spm_histogram.create(1, histo_dim);
    std::size_t last_offset = 0;

    // extract surf
    if (feature_types & feature_type::Surf)
    {
        cv::Mat_<int> surf_histo = getHistogramView(
                spm_histogram,
                0,
                surf_.wordCount(),
                histogram_count);
        extract_feature(surf_extractor_, surf_, image, roi, mask, surf_histo);
        last_offset += surf_histo.total();
    }

    // extract hog
    if (feature_types & feature_type::Hog)
    {
        cv::Mat_<int> hog_histo = getHistogramView(
                spm_histogram,
                last_offset,
                hog_.wordCount(),
                histogram_count);
        extract_feature(hog_extractor_, hog_, image, roi, mask, hog_histo);
        last_offset += hog_histo.total();
    }

    // extract color
    if (feature_types & feature_type::Color)
    {
        cv::Mat_<int> color_histo = getHistogramView(
                spm_histogram,
                last_offset,
                color_.wordCount(),
                histogram_count);
        extract_feature(color_extractor_, color_, image, roi, mask, color_histo);
        last_offset += color_histo.total();
    }

    // extract lbp
    if (feature_types & feature_type::Lbp)
    {
        cv::Mat_<int> lbp_histo = getHistogramView(
                spm_histogram,
                last_offset,
                lbp_.wordCount(),
                histogram_count);
        lbp_.sumPool(
                image,
                roi,
                mask,
                lbp_.wordCount(),
                pyramid_levels_,
                lbp_histo);
        last_offset += lbp_histo.total();
    }

    // extract ssd
    if ((feature_types & feature_type::Ssd) || (feature_types & feature_type::ColorSsd))
    {
        cv::Mat_<int> ssd_histo = getHistogramView(
                spm_histogram,
                last_offset,
                ssd_.wordCount(),
                histogram_count);
        extract_feature(ssd_extractor_, ssd_, image, roi, mask, ssd_histo);
        last_offset += ssd_histo.total();
    }

    // extract holbp
    if (feature_types & feature_type::HoLbp)
    {
        cv::Mat_<int> holbp_histo = getHistogramView(
                spm_histogram,
                last_offset,
                holbp_.wordCount(),
                histogram_count);
        extract_feature(holbp_extractor_, holbp_, image, roi, mask, holbp_histo);
        last_offset += holbp_histo.total();
    }

    // extract dense_surf 
    if (feature_types & feature_type::DenseSurf)
    {
        cv::Mat_<int> dense_surf_histo = getHistogramView(
                spm_histogram,
                last_offset,
                dense_surf_.wordCount(),
                histogram_count);
        extract_feature(dense_surf_extractor_, dense_surf_, image, roi, mask,
												dense_surf_histo);
        last_offset += dense_surf_histo.total();
    }
}

void SpmBowExtractor::extract_feature(
        const LowLevelFeatureExtractor& extractor,
        BowExtractor& bow_extractor,
        const cv::Mat& image,
        const cv::Rect& roi,
        const cv::Mat_<uchar>& mask,
        cv::Mat_<int>& histogram)
{
    std::vector<cv::Point> locations;
    std::vector<BowExtractor::WordId> words;

    cv::Mat descriptors = extractor.denseExtract(image, locations);
    if (!descriptors.data || descriptors.rows == 0)
    {
        return;
    }
    bow_extractor.match(descriptors, words);
    bow_extractor.sumPool(
            words,
            locations,
            roi,
            mask,
            pyramid_levels_,
            histogram);
}


std::size_t SpmBowExtractor::compute_histogram_length(
    const feature_type::T feature_types) const
{
    return compute_histogram_length(feature_types,
        BowExtractor::getHistogramCount(pyramid_levels_));
}

std::size_t SpmBowExtractor::compute_histogram_length(
    const feature_type::T feature_types,
    std::size_t histogram_count) const
{
      std::size_t histo_dim = 0;
      if (feature_types & feature_type::Surf)
      {
          histo_dim += histogram_count * surf_.wordCount();
      }
      if (feature_types & feature_type::Hog)
      {
           histo_dim += histogram_count * hog_.wordCount();
      }
      if (feature_types & feature_type::Color)
      {
          histo_dim += histogram_count * color_.wordCount();
      }
      if (feature_types & feature_type::Lbp)
      {
          histo_dim += histogram_count * lbp_.wordCount();
      }
      if (feature_types & feature_type::Ssd)
      {
          histo_dim += histogram_count * ssd_.wordCount();
      }
      if (feature_types & feature_type::ColorSsd)
      {
           histo_dim += histogram_count * ssd_.wordCount();
      }
      if (feature_types & feature_type::HoLbp)
      {
           histo_dim += histogram_count * holbp_.wordCount();
      }
      if (feature_types & feature_type::DenseSurf)
      {
           histo_dim += histogram_count * dense_surf_.wordCount();
      }
      return histo_dim;
}
} /* namespace features */
} /* namespace vision */


