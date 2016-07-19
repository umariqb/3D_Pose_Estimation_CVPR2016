/*
 * bow_histogram.hpp
 *
 *  Created on: Feb 8, 2012
 *      Author: lbossard
 */

#ifndef VISION_FEATURES_BOW_HISTOGRAM_HPP_
#define VISION_FEATURES_BOW_HISTOGRAM_HPP_

#include <cmath>

#include <boost/noncopyable.hpp>
#include <boost/serialization/access.hpp>

#include <opencv2/core/core.hpp>

#include <glog/logging.h>

#include "low_level_features.hpp"

#include "bow_extractor.hpp"

namespace vision
{
namespace features
{

template <typename T>
class BowHistogram_
{
public:
    typedef typename cv::Mat_<T> Histogram;

    BowHistogram_();

    BowHistogram_(Histogram& histogram, feature_type::T feature_type, std::size_t bow_count);
    virtual ~BowHistogram_();

    void set(Histogram& histogram, feature_type::T feature_type, std::size_t bow_count);


    /**
     * Returns the histograms for the specified level. One Histogram per row.
     * @param spm_level 0, ..., spm_levels() - 1
     * @return
     */
    Histogram histogram_view(unsigned int spm_level) const;

    /**
     * Returns one histogram with the given part_id. part_id goes from 0...part_count()-1
     * @param part_id 0...part_count()-1
     * @return
     */
    Histogram histogram_part(unsigned int part_id) const;

    inline const Histogram& histogram() const;
    inline Histogram& histogram();
    inline const feature_type::T fature_type() const;
    inline const int bow_count() const;
    inline unsigned int spm_levels() const;
    inline unsigned int part_count() const;


private:

    // members
    feature_type::T feature_type_;
    std::size_t bow_count_;
    Histogram histogram_ ;

    // derived members
    unsigned int spm_levels_;





    friend class boost::serialization::access;
    template <class Archive>
    void serialize(Archive& archive, const unsigned int /*version*/)
    {
        archive & feature_type_;
        archive & bow_count_;
        archive & spm_levels_;
        archive & histogram_;
    }
};

typedef BowHistogram_<float> BowHistogramFloat;
typedef BowHistogram_<double> BowHistogramDouble;
typedef BowHistogram_<int> BowHistogram;



////////////////////////////////////////////////////////////////////////////////
// Implementation

template <typename T>
/*inline*/ const
typename BowHistogram_<T>::Histogram&
BowHistogram_<T>::histogram() const
{
    return histogram_;
}

template <typename T>
/*inline*/
typename BowHistogram_<T>::Histogram&
BowHistogram_<T>::histogram()
{
    return histogram_;
}

template <typename T>
inline const feature_type::T BowHistogram_<T>::fature_type() const
{
    return feature_type_;
}

template <typename T>
inline const int BowHistogram_<T>::bow_count() const
{
    return bow_count_;
}

template <typename T>
inline unsigned int BowHistogram_<T>::spm_levels() const
{
    return spm_levels_;
}

template <typename T>
inline unsigned int BowHistogram_<T>::part_count() const
{
    return histogram_.cols / bow_count_;
}

template <typename T>
BowHistogram_<T>::BowHistogram_(Histogram& histogram, feature_type::T feature_type, std::size_t bow_count)
{
    set(histogram, feature_type, bow_count);
}

template <typename T>
BowHistogram_<T>::BowHistogram_()
{

}

template <typename T>
BowHistogram_<T>::~BowHistogram_()
{
    histogram_.release();
}

template <typename T>
void BowHistogram_<T>::set(Histogram& histogram, feature_type::T feature_type, std::size_t bow_count)
{
    histogram_ = histogram.reshape(1);
    assert(histogram_.rows == 1);
    feature_type_ = feature_type;
    bow_count_ = bow_count;
    spm_levels_ = static_cast<unsigned int>(
            log2f(3.f* histogram_.cols / bow_count + 1.f) / 2.f);

    if (BowExtractor::getHistogramCount(spm_levels_) * bow_count != histogram_.cols)
    {
        LOG(ERROR) << "dimensions of histogram does not match spm levels" << std::endl;
    }

}

template <typename T>
typename BowHistogram_<T>::Histogram
BowHistogram_<T>::histogram_view(unsigned int level) const
{
    if (level >= spm_levels_)
    {
        LOG(INFO) << "requested level (" << level
                << ") exceeds saved levels ("<< spm_levels_ << ")" << std::endl;
        return Histogram();
    }

    int histogram_count = std::pow(2, 2 * level);
    int offset = BowExtractor::getHistogramCount(level) * bow_count_;
    int width = histogram_count * bow_count_;

    // reshape http://code.opencv.org/issues/1942
    return histogram_(cv::Rect(offset,0 , width, 1)).reshape(0, histogram_count);
}

template <typename T>
typename BowHistogram_<T>::Histogram
BowHistogram_<T>::histogram_part(unsigned int part) const
{
    if (part > histogram_.cols / bow_count_)
    {
        LOG(INFO) << "requested part (" << part
                << ") exceeds saved parts ("<< histogram_.cols / bow_count_ << ")" << std::endl;
        return Histogram();
    }

    const int offset = part * bow_count_;
    const int width = bow_count_;

    return histogram_(cv::Rect(offset, 0, width, 1));

}


} /* namespace features */
} /* namespace vision */
#endif /* VISION_FEATURES_BOW_HISTOGRAM_HPP_ */
