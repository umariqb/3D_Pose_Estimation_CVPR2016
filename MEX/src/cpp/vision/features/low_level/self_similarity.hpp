/*
 * self_similarity.hpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#ifndef VISION_FEATURES_SELF_SIMILARITY_HPP_
#define VISION_FEATURES_SELF_SIMILARITY_HPP_

#include "low_level_feature_extractor.hpp"

#include <iostream>

#include <boost/math/constants/constants.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
namespace vision
{
namespace features
{


class SelfSimilarity
{
public:
    // Andrea Vedaldi: Multiple Kernels for Object Detection: 5 40 3 10
    // Ken Chatfield: Efficient Retrieval of Deformable Shape Classes using Local Self-Similarities  5 40 12 3

    SelfSimilarity(
            unsigned int patch_size = 5,
            unsigned int window_radius = 40,
            unsigned int radius_bin_count = 3,
            unsigned int angle_bin_count = 10,
            float var_noise=25*3*16,
            unsigned int auto_var_radius=1);

    virtual ~SelfSimilarity();

    void setParameters(unsigned int patch_size,
            unsigned int window_radius,
            unsigned int radius_bin_count,
            unsigned int angle_bin_count,
            float var_noise,
            unsigned int auto_var_radius);

    bool extract(const cv::Mat& image, const cv::Point& location, cv::Mat_<float>& descriptor) const;

    void compute_distance_surface(const cv::Mat& image, const cv::Point& loaction, cv::Mat_<float>& distance_surface) const;

    void compute_descriptor(const cv::Mat_<float>& distance_surface, cv::Mat_<float>& descriptor) const;

    inline const cv::Mat_<int>& getBinMap() const;
    inline static float ssd_slow(const cv::Mat_<cv::Vec3b>& a, const cv::Mat_<cv::Vec3b>& b);

    inline static float ssd3(const cv::Mat_<cv::Vec3b>& patch_a, const cv::Mat_<cv::Vec3b>& patch_b);
    inline static float ssd1(const cv::Mat_<uchar>& patch_a, const cv::Mat_<uchar>& patch_b);

    inline unsigned int descriptorLength() const;

protected:

private:

    unsigned int patch_size_; // dimension of the inner patch
    unsigned int window_radius_; // dimension of the outer path
    unsigned int radius_bin_count_;
    unsigned int angle_bin_count_;
    float var_noise_;

    cv::Mat_<int> bin_map_;
    std::vector<cv::Point> autovar_indices_;

};


class SelfSimilarityExtractor : public LowLevelFeatureExtractor
{
public:
    SelfSimilarityExtractor(
                bool color_ssd = false,
                unsigned int patch_size = 5,
                unsigned int window_radius = 40,
                unsigned int radius_bin_count = 3,
                unsigned int angle_bin_count = 10,
                float var_noise=25*3*16,
                unsigned int auto_var_radius=1);

    virtual ~SelfSimilarityExtractor();


    void setSelfSimilarityParameters(
                unsigned int patch_size,
                unsigned int window_radius,
                unsigned int radius_bin_count,
                unsigned int angle_bin_count,
                float var_noise,
                unsigned int auto_var_radius);

    virtual void extract_at_extremas(const cv::Mat& image,
             cv::Mat_<float>* descriptors,
             const cv::Mat_<uchar>& mask) const {
      CHECK(false) << "not implemented.";
    }

    virtual cv::Mat_<float> denseExtract(
            const cv::Mat& image,
            std::vector<cv::Point>& descriptor_locations,
            const cv::Mat_<uchar>& mask = cv::Mat_<char>()
    ) const;

    virtual unsigned int descriptorLength() const;
private:
    SelfSimilarity self_similarity_;
    bool color_ssd_;

};
////////////////////////////////////////////////////////////////////////////////

inline /*static*/ float SelfSimilarity::ssd3(const cv::Mat_<cv::Vec3b>& patch_a, const cv::Mat_<cv::Vec3b>& patch_b)
{
    int ssd = 0;
    int diff_r, diff_g, diff_b;
    for (int r = 0; r < patch_a.rows; ++r)
    {
        for (int c = 0; c < patch_a.cols; ++c)
        {
            const cv::Vec3b& a = patch_a(r, c);
            const cv::Vec3b& b = patch_b(r, c);
            diff_r = a[0] - b[0];
            diff_g = a[1] - b[1];
            diff_b = a[2] - b[2];
            ssd +=    (diff_r * diff_r)
                    + (diff_g * diff_g)
                    + (diff_b * diff_b);
        }
    }
    return ssd;
}

inline /*static*/ float SelfSimilarity::ssd1(const cv::Mat_<uchar>& patch_a, const cv::Mat_<uchar>& patch_b)
{
    int ssd = 0;
    int diff;
    for (int r = 0; r < patch_a.rows; ++r)
    {
        for (int c = 0; c < patch_a.cols; ++c)
        {
            diff = static_cast<int>(patch_a(r, c)) - patch_b(r, c);
            ssd += (diff * diff);
        }
    }
    return ssd;
}

inline const cv::Mat_<int>& SelfSimilarity::getBinMap() const
{
    return bin_map_;
}
inline unsigned int SelfSimilarity::descriptorLength() const
{
    return radius_bin_count_ * angle_bin_count_;
}

} /* namespace features */
} /* namespace vision */
#endif /* VISION_FEATURES_SELF_SIMILARITY_HPP_ */
