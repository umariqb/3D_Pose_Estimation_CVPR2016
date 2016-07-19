/*
 * lbp.hpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#ifndef VISON_FEATURES_LOW_LEVEL_LBP_HPP_
#define VISON_FEATURES_LOW_LEVEL_LBP_HPP_

#include "low_level_feature_extractor.hpp"

namespace vision
{
namespace features
{
class Lbp : public LowLevelFeatureExtractor
{
public:
    typedef int WordId;

    virtual void extract_at_extremas(const cv::Mat& image,
             cv::Mat_<float>* descriptors,
             const cv::Mat_<uchar>& mask) const {
      CHECK(false) << "not implemented.";
    }

    virtual cv::Mat_<float> denseExtract(
            const cv::Mat& image,
            std::vector<cv::Point>& descriptor_locations,
            const cv::Mat_<uchar>& mask = cv::Mat_<char>()
            ) const ;

    void denseExtractHistogram(
                const cv::Mat& image,
                cv::Mat_<int>& histogram,
                const cv::Mat_<uchar>& mask = cv::Mat_<char>()
                ) const;

    void sumPool(
            const cv::Mat& image,
            const cv::Rect& roi,
            const cv::Mat_<uchar>& mask,
            const unsigned int word_count,
            const unsigned int levels,
            cv::Mat_<int>& histograms);

    virtual unsigned int descriptorLength() const;

    static inline WordId maxWordId();
    static inline std::size_t wordCount();

private:
};

inline unsigned char get_lbp_code(
        const int row, const int col,
        const cv::Mat_<uchar>& gray,
        const int step_width
        )
{
    uchar current_pixel = gray(row, col);
    uchar feature = 0;
    // precompute dx dy
    const int bottom = row + step_width;
    const int top    = row - step_width;
    const int right  = col - step_width;
    const int left   = col + step_width;
    // compute feature code
    feature |= (current_pixel > gray(top,    col  )) * (0x1 << 0);
    feature |= (current_pixel > gray(top,    left )) * (0x1 << 1);
    feature |= (current_pixel > gray(row,    left )) * (0x1 << 2);
    feature |= (current_pixel > gray(bottom, left )) * (0x1 << 3);
    feature |= (current_pixel > gray(bottom, col  )) * (0x1 << 4);
    feature |= (current_pixel > gray(bottom, right)) * (0x1 << 5);
    feature |= (current_pixel > gray(row,    right)) * (0x1 << 6);
    feature |= (current_pixel > gray(top,    right)) * (0x1 << 7);

    return feature;
}

////////////////////////////////////////////////////////////////////////////////
// implementation
inline Lbp::WordId Lbp::maxWordId()
{
    return 255;
}
inline std::size_t Lbp::wordCount()
{
    return 256;
}

} /* namespace features */
} /* namespace vision */
#endif /* LBP_HPP_ */
