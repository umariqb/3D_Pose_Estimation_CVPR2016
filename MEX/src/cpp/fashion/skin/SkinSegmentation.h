#ifndef FASHION_SKIN_SEGMENTATION_H__
#define FASHION_SKIN_SEGMENTATION_H__

#include <vector>
#include <opencv2/core/core.hpp>
#include "SkinColorModelGaussian.h"
namespace fashion
{
    struct SkinSegment
    {
        SkinSegment(unsigned int center_x, unsigned int center_y, unsigned int radius, float bounding_box_height_multiplicator, float bounding_box_width_to_height_fraction) : radius_(radius)
        {
            this->center_[0] = center_x;
            this->center_[1] = center_y;

            this->top_    = center_y - radius * bounding_box_height_multiplicator;
            this->bottom_ = center_y + radius * bounding_box_height_multiplicator;
            this->left_   = center_x - radius * bounding_box_height_multiplicator * bounding_box_width_to_height_fraction;
            this->right_  = center_x + radius * bounding_box_height_multiplicator * bounding_box_width_to_height_fraction;
        }

        unsigned int center_[2];
        unsigned int radius_;

        int top_;
        int bottom_;
        int left_;
        int right_;
    };


    class SkinSegmentation
    {
        public:
            SkinSegmentation();

            void createSkinMap(const cv::Mat& input, cv::Mat* output, bool bSegment = true);
            void createSkinPixelMapThreshold(const cv::Mat& input, cv::Mat* output, float createSkinPixelMapThreshold) const;

            void createSkinProbabilityMap(const cv::Mat& input, cv::Mat* output) const;

            unsigned int createClothingProbabilityMap(const cv::Mat& input, cv::Mat* output);

            void createSkinPixelMap(const cv::Mat& image, cv::Mat* skin_pixel_map) const;
            void createSkinSegmentMap(const cv::Mat& skin_pixel_map, cv::Mat* skin_segment_map);
            void createSkinSegments(cv::Mat& skin_segment_map, std::vector<SkinSegment>* skin_segments, std::vector<std::vector<cv::Point> >* contours_output = 0);
            unsigned int createClothingProbabilityMap(const std::vector<SkinSegment>& skin_segments, cv::Mat* clothing_probability_map, const cv::Size& size);

            const SkinColorModelGaussian& getColorModel() const;

            virtual ~SkinSegmentation (){};
        private:
            SkinColorModelGaussian color_model_;
            int num_segments_;
            float fraction_skin_pixels_required_;
            float bounding_box_height_multiplicator_;
            float bounding_box_width_to_height_fraction_;
            float min_segment_radius_fraction_;
    };
}

#endif /* FASHION_SKIN_SEGMENTATION_H__ */
