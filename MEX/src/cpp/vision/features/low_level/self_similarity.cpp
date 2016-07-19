/*
 * self_similarity.cpp
 *
 *  Created on: Jan 25, 2012
 *      Author: lbossard
 */

#include "self_similarity.hpp"

#include <boost/math/constants/constants.hpp>
#include <boost/foreach.hpp>

namespace vision
{
namespace features
{

SelfSimilarityExtractor::SelfSimilarityExtractor(
        bool color_ssd,
        unsigned int patch_size,
        unsigned int window_radius,
        unsigned int radius_bin_count,
        unsigned int angle_bin_count,
        float var_noise,
        unsigned int auto_var_radius)
{
    color_ssd_ = color_ssd;
    this->setSelfSimilarityParameters(
            patch_size,
            window_radius,
            radius_bin_count,
            angle_bin_count,
            var_noise,
            auto_var_radius);
}

void SelfSimilarityExtractor::setSelfSimilarityParameters(
        unsigned int patch_size,
        unsigned int window_radius,
        unsigned int radius_bin_count,
        unsigned int angle_bin_count,
        float var_noise,
        unsigned int auto_var_radius)
{

    self_similarity_.setParameters(patch_size,
            window_radius,
            radius_bin_count,
            angle_bin_count,
            var_noise,
            auto_var_radius);

}


/*virtual*/ SelfSimilarityExtractor::~SelfSimilarityExtractor()
{

}

/*virtual*/ cv::Mat_<float> SelfSimilarityExtractor::denseExtract(
        const cv::Mat& input_image,
        std::vector<cv::Point>& locations,
        const cv::Mat_<uchar>& mask
) const
{
    const unsigned int radius = 5;

    // generate locations
    locations.clear();
    LowLevelFeatureExtractor::generateGridLocations(
            input_image.size(),
            cv::Size(radius, radius),
            radius,
            radius,
            locations,
            mask);
    if (locations.size() == 0)
    {
        return cv::Mat_<float>();
    }

    // convert to gray if necessary
    cv::Mat image = input_image;
    if (!color_ssd_ && image.type() != CV_8U)
    {
        cv::cvtColor(image, image, CV_BGR2GRAY);
    }

    // allocate memroy
    cv::Mat_<float> features(locations.size(), descriptorLength());

    // loop over locations and compute descriptors
    std::size_t point_idx = 0;
    BOOST_FOREACH(const cv::Point& p, locations)
    {
        cv::Mat_<float> descriptor = features.row(point_idx);
        if (self_similarity_.extract(image, p, descriptor))
        {
            ++point_idx;
        }
    }
    if (point_idx == 0)
    {
        return cv::Mat_<float>();
    }
    features.resize(point_idx);
    return features;
}

/*virtual*/ unsigned int SelfSimilarityExtractor::descriptorLength() const
{
    return self_similarity_.descriptorLength();
}
////////////////////////////////////////////////////////////////////////////////
/**
 *
 * @param patch_size       odd
 * @param window_radius    even
 * @param radius_bin_count
 * @param angle_bin_count
 * @param var_noise
 * @param auto_var_radius
 */
SelfSimilarity::SelfSimilarity(
        unsigned int patch_size,
        unsigned int window_radius,
        unsigned int radius_bin_count,
        unsigned int angle_bin_count,
        float var_noise,
        unsigned int auto_var_radius)
{
    setParameters(patch_size,
            window_radius,
            radius_bin_count,
            angle_bin_count,
            var_noise,
            auto_var_radius);
}
/*virtual*/ SelfSimilarity::~SelfSimilarity()
{

}

void SelfSimilarity::setParameters(unsigned int patch_size,
        unsigned int window_radius,
        unsigned int radius_bin_count,
        unsigned int angle_bin_count,
        float var_noise,
        unsigned int auto_var_radius)
{
    // set parameters
    patch_size_ = patch_size;
    window_radius_ = window_radius;
    radius_bin_count_ = radius_bin_count;
    angle_bin_count_ = angle_bin_count;
    var_noise_ = var_noise;

    // precompute binning and autovar indices
    const int window_size = 2 * window_radius_ + 1;
    bin_map_= -cv::Mat_<int>::ones(window_size, window_size);  // init to -1
    autovar_indices_.clear();
    autovar_indices_.reserve((2*auto_var_radius + 1)*(2*auto_var_radius + 1)); // upper bound
    double angle = 0.f;
    double radius = 0.f;
    int angle_bin = 0;
    int radius_bin = 0;
    int bin_id = 0;
    for (int y = -window_radius_; y < window_size; ++y)
    {
        for (int x = -window_radius_; x < window_size; ++x)
        {
            /*
             * scale log(y) to (bin_count - 1)...0
             */
            radius = std::sqrt(static_cast<float>(x * x + y * y));
            if (radius > window_radius_ || radius == 0.)
            {
                continue;
            }
            radius_bin = static_cast<int>(
                    ( std::log(radius)) / std::log(window_radius_+.5)
                    * radius_bin_count_);

            /*
             * \alpha \in [ -\pi ... +\pi ]
             * bin_id \in [0 ... (bin_count - 1) ]
             * bin_id = floor( (\alpha + \pi) / ( 2 \pi) * bin_count )
             *        = floor( \alpha bin_count / ( 2 \pi) + bin_count/2 )
             */
            angle = std::atan2(y, x); // [-pi ... pi]
            angle_bin = static_cast<int>(
                   ((angle * angle_bin_count_)
                    / ( boost::math::constants::two_pi<double>()))
                    + angle_bin_count_/2.) % angle_bin_count; // atan2 gives [-pi ... pi] and not (-pi ... pi] that's why we mod

            bin_id = angle_bin * radius_bin_count + radius_bin;
            bin_map_(y + window_radius_, x + window_radius_) = bin_id;

            if (radius <= auto_var_radius && radius > 0)
            {
                autovar_indices_.push_back(cv::Point(y + window_radius_, x + window_radius_));
            }

        }
    }
}


bool SelfSimilarity::extract(const cv::Mat& image, const cv::Point& location, cv::Mat_<float>& descriptor) const
{
    // compute the distance surface
    cv::Mat_<float> distance_surface;
    compute_distance_surface(image, location, distance_surface);

    if (distance_surface.rows == 0 || distance_surface.cols == 0)
    {
        return false;
    }

    // put it into the logpolar descriptor
    compute_descriptor(distance_surface, descriptor);
    return true;
}

//void showmat(const std::string titile, const cv::Mat& mat, int size)
//{
//    cv::Mat scaled;
//    cv::resize(mat, scaled, cv::Size(mat.rows * size, mat.cols * size), 0, 0, cv::INTER_AREA);
//    cv::imshow(titile, scaled);
//}

void SelfSimilarity::compute_distance_surface(const cv::Mat& image, const cv::Point& loaction, cv::Mat_<float>& distance_surface) const
{
    const int patch_radius = patch_size_ / 2;
    const int window_size  = window_radius_ * 2 + 1;

    // check boundaries
    if (	   (loaction.x - (int)window_radius_ - patch_radius) < 0
            || (loaction.y - (int)window_radius_ - patch_radius) < 0
            || (loaction.x + (int)window_radius_ + patch_size_) >= image.cols
            || (loaction.y + (int)window_radius_ + patch_size_) >= image.rows)
    {
        distance_surface = cv::Mat_<float>();
        return;
    }

    // allocate memory and precompute some structures
    distance_surface.create(window_size, window_size);

    const cv::Mat inner_patch = image(
            cv::Range(loaction.y - patch_radius, loaction.y + patch_radius + 1),
            cv::Range(loaction.x - patch_radius, loaction.x + patch_radius + 1));

//    assert(distance_surface.rows == window_size);
//    assert(distance_surface.cols == window_size);
    for (unsigned int r = 0; r < window_size; ++r)
    {
        const int y_window_patch_start = loaction.y - window_radius_ + r - patch_radius ;
        const cv::Range y_window_range(
                y_window_patch_start,
                y_window_patch_start + patch_size_);
        for (unsigned int c = 0; c < window_size; ++c)
        {
//            const int bin_idx = bin_map_(r,c);
//            if (bin_idx < 0)
//            {
//                continue;
//            }
            const int x_window_patch_start = loaction.x - window_radius_  + c - patch_radius;
            const cv::Range x_window_range(
                    x_window_patch_start,
                    x_window_patch_start + patch_size_);

            const cv::Mat window_patch = image(y_window_range, x_window_range);
            if (image.channels() == 3)
            {
                distance_surface(r, c) = ssd3(inner_patch, window_patch);
            }
            else
            {
                distance_surface(r, c) = ssd1(inner_patch, window_patch);
            }

//            showmat("inner", inner_patch, 100);
//            showmat("window_patch", window_patch, 100);
//            cv::Mat d = image.clone();
//            // window_patch
//            cv::rectangle(d,
//                    cv::Point(x_window_range.start, y_window_range.start),
//                    cv::Point(x_window_range.end-1,   y_window_range.end-1),
//                    CV_RGB(0,255,255)
//                    );
//            // center_patch
//            cv::rectangle(d,
//                    cv::Point(loaction.x - patch_radius, loaction.y - patch_radius),
//                    cv::Point(loaction.x + patch_radius, loaction.y + patch_radius),
//                    CV_RGB(255,0,255)
//                    );
//            // whole window
//            cv::rectangle(d,
//                    cv::Point(
//                            loaction.x - window_radius_,
//                            loaction.y - window_radius_),
//                    cv::Point(
//                            loaction.x + window_radius_,
//                            loaction.y + window_radius_),
//                    CV_RGB(255,0,255)
//                    );
//            showmat("all", d, 5);
//            cv::waitKey();
        }
    }
}


void SelfSimilarity::compute_descriptor(const cv::Mat_<float>& distance_surface, cv::Mat_<float>& descriptor) const
{
    // allocate log-polar descriptor. we init it with -1 as the e^-x is
    // always > 0 for x < \inf
    const int descriptor_length = radius_bin_count_*angle_bin_count_;
    descriptor.create(1, descriptor_length);
    descriptor = -1;

    // compute auto noise (like original paper matlab implementation):
    // find max ssd at the autovar_indices (<- places with within radius 1)
    float variance = var_noise_;
    for (unsigned int i = 0; i < autovar_indices_.size(); ++i)
    {
        const cv::Point& p = autovar_indices_[i];
        variance = std::max(variance, distance_surface(p.y, p.x));
    }

    // compute finally the descriptor
    float min_correlation = std::numeric_limits<float>::max();
    float max_correlation = std::numeric_limits<float>::min();
    for (int r = 0; r < distance_surface.rows; ++r)
    {
        for (int c = 0; c < distance_surface.cols; ++c)
        {
            const int bin_idx = bin_map_(r,c);
            if (bin_idx < 0)
            {
                continue;
            }
            // compute S_q(x,y)
            float correlation = std::exp(-distance_surface(r, c) / variance);
            // we store only the max ssd
            const float current_value = descriptor(bin_idx);
            if (current_value < correlation)
            {
                descriptor(bin_idx) = correlation;
                min_correlation = std::min(correlation, min_correlation);
                max_correlation = std::max(correlation, max_correlation);
            }

        }
    }
    // finally: normalize to [0 ... 1]
    //XXX: Note: in the original implementation, there would be only stretching to max without substracting min
    // however, the paper states "normalized by linearly streticht its values to the range [0...1]"
//    descriptor = (descriptor - min_correlation) / (max_correlation - min_correlation);
    //XXX: strange enough: "correct" normalization gives a segfault while clustering
    descriptor = descriptor / max_correlation;  // normalisation from the paper implementation

}

} /* namespace features */
} /* namespace vision */
