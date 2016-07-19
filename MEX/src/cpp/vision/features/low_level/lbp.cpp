/*
 * lbp.cpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#include "lbp.hpp"

#include <opencv2/imgproc/imgproc.hpp>

#include "../bow_extractor.hpp"

namespace vision
{
namespace features
{

/*virtual*/ unsigned int Lbp::descriptorLength() const
{
    return 1;
}


/*virtual*/ cv::Mat_<float> Lbp::denseExtract(
            const cv::Mat& image,
            std::vector<cv::Point>& locations,
            const cv::Mat_<uchar>& mask
            ) const
{
    const int step_width = 1;

    // prepare image
    cv::Mat_<uchar> gray;
    if (image.type() != CV_8U)
    {
        cv::cvtColor(image, gray, CV_BGR2GRAY);
    }
    else
    {
        gray = image;
    }

    // reserve space locations
    locations.resize(image.rows*image.cols);
    cv::Mat_<unsigned char> feature_vector(image.rows * image.cols, descriptorLength());

    int index = 0;
    for (int row = 1; row < gray.rows - 1; ++row)
    {
        for (int col = 1; col < gray.cols - 1; ++col)
        {
            if (!mask.data || mask(row, col))
            {
                cv::Point& p = locations[index];
                p.x = col;
                p.y = row;

                feature_vector(index) = get_lbp_code(row, col, gray, step_width);
                ++index;
            }
        }
    }
    // resize to actual number of extracted features
    locations.resize(index);
    feature_vector.resize(index);

    // features are in floats...
    cv::Mat_<float> float_features;
    feature_vector.convertTo(float_features, CV_32F);
    return float_features;

}

void Lbp::denseExtractHistogram(
            const cv::Mat& image,
            cv::Mat_<int>& histogram,
            const cv::Mat_<uchar>& mask
            ) const
{
    const int step_width = 1;
    const unsigned int max_word_count = 256;

    // prepare image
    cv::Mat_<uchar> gray;
    if (image.type() != CV_8U)
    {
        cv::cvtColor(image, gray, CV_BGR2GRAY);
    }
    else
    {
        gray = image;
    }

    // reserve space locations
    histogram.create(1, max_word_count);
    histogram = 0;

    for (int row = 1; row < gray.rows - 1; ++row)
    {
        for (int col = 1; col < gray.cols - 1; ++col)
        {
            if (!mask.data || mask(row, col))
            {
                ++histogram(get_lbp_code(row, col, gray, step_width));
            }
        }
    }
}

void Lbp::sumPool(
        const cv::Mat& image,
        const cv::Rect& roi,
        const cv::Mat_<uchar>& mask,
        const unsigned int word_count,
        const unsigned int levels,
        cv::Mat_<int>& histograms)
{
    if (levels < 1)
    {
        throw "levels > 0 !!111";
    }

    // compute number of histograms
    const int histo_count =  BowExtractor::getHistogramCount(levels);

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
                const int histogram_idx = c * box_count + r + histograms_idx_offset;
                cv::Mat_<int> histogram = histograms.row(histogram_idx);
                denseExtractHistogram(image(rect), histogram, mask);
            }
        }
    }

    // derive histo for upper layers
    for (int level = levels - 2 ; level >= 0; --level)
    {
        const int current_histo_idx_offset = BowExtractor::getHistogramCount(level);
        const int lower_histo_idx_offset = BowExtractor::getHistogramCount(level + 1);
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

} /* namespace features */
} /* namespace vision */
