/*
 * spmbow_extractor.hpp
 *
 *  Created on: Oct 29, 2011
 *      Author: lbossard
 */

#ifndef FEATURES_SPMBOW_EXTRACTOR_HPP_
#define FEATURES_SPMBOW_EXTRACTOR_HPP_

#include <boost/noncopyable.hpp>

#include <opencv2/core/core.hpp>

#include "low_level_features.hpp"
#include "bow_extractor.hpp"
#include "local_word_container.hpp"

#include <glog/logging.h>
#include "cpp/vision/features/extractor.hpp"

/*
TODO(luk): Feature extraction class hierarchy should be cleaned up. then those
           function here in this class would get *much* simpler

                  histgram_features  low_level_features
                    /            \    /        \
               bow_extractor    lbp, color     suf, hog,

 lets call some of them mix-ins :P
*/

namespace vision
{
namespace features
{

/**
 * Extracts bag of words in a spatial pyramid
 */
class SpmBowExtractor : public Extractor
{
public:
    /**
     * we take ownership !11
     * @param pyramid_levels
     * @param surf_voc
     * @param hog_voc
     * @param color_voc
     */
    SpmBowExtractor(
            unsigned int pyramid_levels,
            cv::Mat& surf_voc,
            cv::Mat& hog_voc,
            cv::Mat& color_voc,
            cv::Mat& ssd_voc,
						const cv::Mat& holbp_voc = cv::Mat(),
						const cv::Mat& dense_surf_voc = cv::Mat());

    SpmBowExtractor(
            unsigned int pyramid_levels,
            feature_type::T feature_types,
            cv::Mat& surf_voc,
            cv::Mat& hog_voc,
            cv::Mat& color_voc,
            cv::Mat& ssd_voc,
            const cv::Mat& holbp_voc = cv::Mat(),
            const cv::Mat& dense_surf_voc = cv::Mat());

    SpmBowExtractor();

    virtual ~SpmBowExtractor();

    void extractSpm(
            const cv::Mat& image,
            const cv::Mat_<uchar>& mask,
            cv::Mat_<int>& spm_histogram,
            feature_type::T feature_types);

    void extractSpm(
                const cv::Mat& image,
                cv::Mat_<int>& spm_histogram,
                feature_type::T feature_types);

    template <typename T>
    void extractSpm(
        const std::vector<LocalWordContainer*>& local_words,
        const cv::Rect& roi,
        const cv::Mat_<uchar>& mask,
        cv::Mat_<T>& spm_histogram);

    template <typename T>
    static inline cv::Mat_<T> getHistogramView(
        const cv::Mat_<T>& histo,
        const std::size_t offset,
        const std::size_t histogram_dimensions,
        const std::size_t histogram_count);

    std::size_t compute_histogram_length(
        const feature_type::T feature_types,
        std::size_t histogram_count) const;

    std::size_t compute_histogram_length(
        const feature_type::T feature_types) const;

    Surf* get_surf_extractor(){return &surf_extractor_;};



    virtual int feature_dimensions() {
      return compute_histogram_length(feature_types_);
    }

    virtual void extract_features( const cv::Mat& image,
                           cv::Mat_<int>& features,
                           const cv::Mat_<uchar>& mask = cv::Mat()) {
      extractSpm(image, mask, features, feature_types_);
    }


private:

    const unsigned int pyramid_levels_;

    // extractors
    Surf surf_extractor_;
    Hog hog_extractor_;
    Color color_extractor_;
    SelfSimilarityExtractor ssd_extractor_;
		HoLbp holbp_extractor_;
		DenseSurf dense_surf_extractor_;

    // bow creators
    BowExtractor surf_;
    BowExtractor hog_;
    BowExtractor color_;
    BowExtractor ssd_;
    BowExtractor holbp_;
		BowExtractor dense_surf_;
    Lbp lbp_;


    vision::features::feature_type::T feature_types_;

    void extract_feature(
            const LowLevelFeatureExtractor& extractor,
            BowExtractor& bow_extractor,
            const cv::Mat& image,
            const cv::Rect& roi,
            const cv::Mat_<uchar>& mask,
            cv::Mat_<int>& histogram);

};


////////////////////////////////////////////////////////////////////////////////
template <typename T>
/*static*/ inline cv::Mat_<T> SpmBowExtractor::getHistogramView(
        const cv::Mat_<T>& histo,
        const std::size_t offset,
        const std::size_t histogram_dimensions,
        const std::size_t histogram_count)
{
    const std::size_t width = histogram_count * histogram_dimensions;
    return histo(cv::Rect(offset,0 , width, 1)).reshape(0, histogram_count);
}

template <typename T>
void SpmBowExtractor::extractSpm(
    const std::vector<LocalWordContainer*>& local_words,
    const cv::Rect& roi,
    const cv::Mat_<uchar>& mask,
    cv::Mat_<T>& spm_histogram)
{
    const std::size_t histogram_count = BowExtractor::getHistogramCount(pyramid_levels_);
    const std::size_t container_count = local_words.size();

    // count total size and allocate histogram
    std::size_t histo_dim = 0;
    for (std::size_t i = 0; i < container_count; ++i){
        histo_dim += local_words[i]->wordCount();
    }
    spm_histogram.create(1, histo_dim);

    // extract features
    std::size_t last_offset = 0;
    for (std::size_t i = 0; i < container_count; ++i){
        const LocalWordContainer& word_container = *local_words[i];
        cv::Mat_<int> histo = getHistogramView(
            spm_histogram,
            last_offset,
            word_container.wordCount(),
            histogram_count);
        word_container.getBow(roi, pyramid_levels_, histo);
        last_offset += histo.total();
    }
}
} /* namespace features */
} /* namespace vision */
#endif /* FEATURES_SPMBOW_EXTRACTOR_HPP_ */
