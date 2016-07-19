/*
 * BowDescriptor.hpp
 *
 *  Created on: Oct 14, 2011
 *      Author: lbossard
 */

#ifndef FEATURES_BOWDESCRIPTOR_HPP_
#define FEATURES_BOWDESCRIPTOR_HPP_

#include <vector>

#include <boost/noncopyable.hpp>

#include <opencv2/core/core.hpp>
#include <opencv2/flann/flann.hpp>

namespace vision
{
namespace features
{

class BowExtractor : boost::noncopyable
{
public:
    typedef int WordId;
    typedef cv::Mat_<int> RowHistograms;

    explicit BowExtractor(const cv::Mat_<float>& vocabulary,
                          cvflann::flann_algorithm_t=cvflann::FLANN_INDEX_LINEAR);
    virtual ~BowExtractor();

    void match(const cv::Mat_<float>& features,
            std::vector<WordId>& words);

    void match(
            const cv::Mat_<float>& features,
            cv::Mat_<WordId>& indices,
            cv::Mat_<float>& dists,
            unsigned int knn);

    void sumPool( const std::vector<WordId>& words,
            const std::vector<cv::Point>& locations,
            const cv::Rect& roi,
            const cv::Mat_<uchar>& mask,
            const unsigned int levels,
            RowHistograms& histograms
            ) const;

    void createHistogram(
                const std::vector<WordId>& words,
                const std::vector<cv::Point>& locations,
                const cv::Rect& roi,
                const cv::Mat_<uchar>& mask,
                RowHistograms& histogram) const;
    // T == cv::Mat_<U>
    template <typename T>
    static void sumPool(
            const std::vector<WordId>& words,
            const std::vector<cv::Point>& locations,
            const cv::Rect& roi,
            const cv::Mat_<uchar>& mask,
            const unsigned int word_count,
            const unsigned int levels,
            cv::Mat_<T>& histograms);
    // T == cv::Mat_<U>
    template <typename T>
    static void createHistogram(
            const std::vector<WordId>& words,
            const std::vector<cv::Point>& locations,
            const cv::Rect& roi,
            const cv::Mat_<uchar>& mask,
            const unsigned int max_word_count,
            cv::Mat_<T>& histogram);

    /**
     * Get number of histograms for a given level. level must be greater than 0
     * @param levels
     * @return
     */
    static inline int getHistogramCount(const unsigned int levels);

    inline WordId maxWordId() const;
    inline std::size_t wordCount() const;

protected:
    cv::Mat vocabulary_;

    cvflann::SearchParams search_params_;
    cv::flann::GenericIndex<cvflann::L2<float> > index_;

private:
    BowExtractor();

};

//------------------------------------------------------------------------------
inline BowExtractor::WordId BowExtractor::maxWordId() const
{
    //TODO: empty vocabulary? -> underflow !111
    return vocabulary_.rows - 1;
}
inline std::size_t BowExtractor::wordCount() const
{
    return vocabulary_.rows;
}
/*static*/ inline int BowExtractor::getHistogramCount(const unsigned int levels)
{
    return (std::pow(2, 2 * levels) - 1 ) / 3; // same as  ((2 << ((2 * levels) - 1)) - 1 ) / 3 which only works for levels > 0;
}

///*static*/ inline BowExtractor::getLevel(const unsigned int index, const unsigned int vocsize)
//{
//    return ceil(log2( 3 * index + 1)/ 2.f);
//}

template <typename T>
/*static*/ void BowExtractor::sumPool(
        const std::vector<WordId>& words,
        const std::vector<cv::Point>& locations,
        const cv::Rect& roi,
        const cv::Mat_<uchar>& mask,
        const unsigned int word_count,
        const unsigned int levels,
        cv::Mat_<T>& histograms)
{
    if (levels < 1)
    {
        throw "levels > 0 !!111";
    }

    // compute number of histograms
    const int histo_count = getHistogramCount(levels);

    // one histo per row
    histograms.create(histo_count, word_count);
    histograms = 0;

    // compute histograms at lowest scale
    {
        const int box_count = std::pow(2, levels - 1);
        const int box_width = roi.width / box_count;
        const int box_height = roi.height / box_count;
        const int histograms_idx_offset = histo_count - (box_count * box_count);
        for (int c = box_count - 1; c >= 0 ; --c)
        {
            for (int r = box_count - 1; r >= 0; --r)
            {
                const cv::Rect rect(roi.x + c * box_width, roi.y +  r * box_height, box_width, box_height);
//        std::cout << rect.x << " "  << rect.y << " "<< rect.width << " "<< rect.height << " "<<  ((image_dims & rect) == rect) << " " <<  c * box_count + r << " "<<  c * box_count + r + histograms_idx_offset << " "<< std::endl;
                const int histogram_idx = c * box_count + r + histograms_idx_offset;
                cv::Mat_<T> histogram = histograms.row(histogram_idx);
                BowExtractor::createHistogram(words, locations, rect, mask, word_count, histogram);
            }
        }
    }

    // derive histo for upper layers
    for (int level = levels - 2 ; level >= 0; --level)
    {
        const int current_histo_idx_offset = getHistogramCount(level);
        const int lower_histo_idx_offset = getHistogramCount(level + 1);
        const int box_count = std::pow(2, level + 1);

        for (int c = 0; c < box_count ; ++c)
        {
            for (int r = 0; r < box_count ; ++r)
            {
                const int current_level_histo_ix = current_histo_idx_offset + c/2 * box_count/2 + r/2;
                const int lower_histo_idx = lower_histo_idx_offset + c * box_count + r;
                histograms.row(current_level_histo_ix) += histograms.row(lower_histo_idx);
            }
        }
    }
}


template <typename T>
/*static*/ void BowExtractor::createHistogram(
        const std::vector<WordId>& words,
        const std::vector<cv::Point>& locations,
        const cv::Rect& roi,
        const cv::Mat_<uchar>& mask,
        const unsigned int max_word_count,
        cv::Mat_<T>& histogram)
{
    histogram.create(1,max_word_count);
    histogram = 0;
    std::size_t item_count = words.size();

    if (!mask.data)
    {
        for (unsigned int i = 0; i < item_count; ++i)
        {
            const cv::Point& p = locations[i];
            if (roi.contains(p))
            {
                histogram(words[i]) += 1;
            }
        }
    }
    else
    {
        for (unsigned int i = 0; i < item_count; ++i)
        {
            const cv::Point& p = locations[i];
            if (roi.contains(p) && mask(p.y, p.x))
            {
                histogram(words[i]) += 1;
            }
        }
    }
}

} /* namespace features */
} /* namespace vision */
#endif /* FEATURES_BOWDESCRIPTOR_HPP_ */
