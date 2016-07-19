
#include "SkinSegmentation.h"

#include <opencv2/imgproc/imgproc.hpp>

#include "SkinColorModelGaussian.h"
#include <iostream>
namespace fashion
{
    SkinSegmentation::SkinSegmentation()
    {
        num_segments_ = 150;
        fraction_skin_pixels_required_ = 0.99f;
        bounding_box_height_multiplicator_ = 4.0f;
        bounding_box_width_to_height_fraction_ = 0.5;
        min_segment_radius_fraction_ = 0.2f;

    }

    const SkinColorModelGaussian& SkinSegmentation::getColorModel() const
    {
        return color_model_;
    }

    void SkinSegmentation::createSkinMap(const cv::Mat& input, cv::Mat* output, bool bSegment)
    {
        cv::Mat& output_ref = *output;

        cv::Mat skin_pixel_map;
        this->createSkinPixelMap(input, &skin_pixel_map);

        if (bSegment)
        {
            cv::Mat skin_segment_map;
            this->createSkinSegmentMap(skin_pixel_map, &skin_segment_map);

            std::vector<SkinSegment> skin_segments;
            std::vector<std::vector<cv::Point> > contours;
            this->createSkinSegments(skin_segment_map, &skin_segments, &contours);

            float row_scale = static_cast<float>(input.rows) / skin_segment_map.rows;
            float col_scale = static_cast<float>(input.cols) / skin_segment_map.cols;

            for (size_t i = 0; i < contours.size(); ++i)
            {
                for (size_t j = 0; j < contours[i].size(); ++j)
                {
                    contours[i][j].x *= col_scale;
                    contours[i][j].y *= row_scale;
                }
            }

            output_ref = cv::Mat::zeros(input.size(), CV_8UC1);
            cv::drawContours(output_ref, contours, -1, cv::Scalar(255), CV_FILLED);

            // count the skin pixels in both skin pixel map and skin segment map
            int count_pixel_map = 0;
            int count_segment_map = 0;
            for (int r = 0; r < output_ref.rows; ++r)
            {
                for (int c = 0; c < output_ref.cols; ++c)
                {
                    int position = r * output_ref.step[0] + c;
                    if (output_ref.data[position])
                        ++count_segment_map;
                    if (skin_pixel_map.data[position])
                        ++count_pixel_map;
                }
            }

            // if skin segments cover a greater area than skin pixels, ignore segments and just return skin pixel map
            if (count_segment_map > count_pixel_map)
                output_ref = skin_pixel_map;
        }
        else
        {
            output_ref = skin_pixel_map;
        }
    }

    unsigned int SkinSegmentation::createClothingProbabilityMap(const cv::Mat& input, cv::Mat* output)
    {
        cv::Mat skin_pixel_map;
        this->createSkinPixelMap(input, &skin_pixel_map);

        cv::Mat skin_segment_map;
        this->createSkinSegmentMap(skin_pixel_map, &skin_segment_map);

        std::vector<SkinSegment> skin_segments;
        std::vector<std::vector<cv::Point> > contours;
        this->createSkinSegments(skin_segment_map, &skin_segments);

        cv::Mat clothing_probability_map;
        unsigned int max = this->createClothingProbabilityMap(skin_segments, &clothing_probability_map, skin_segment_map.size());

        cv::resize(clothing_probability_map, *output, input.size(), 0, 0, cv::INTER_NEAREST);

        return max;
    }


    void SkinSegmentation::createSkinPixelMap(const cv::Mat& image, cv::Mat* skin_pixel_map) const
    {
        cv::Mat& output_ref = *skin_pixel_map;
        output_ref.create(image.size(), CV_8UC1);

        const SkinColorModelGaussian& color_model = SkinSegmentation::getColorModel();

        for (int r = 0; r < image.rows; ++r)
        {
            for (int c = 0; c < image.cols; ++c)
            {
                int offset = r * image.step[0] + c * image.step[1];

                int color[3] =
                {
                    image.data[offset + 2], // R
                    image.data[offset + 1], // G
                    image.data[offset + 0]  // B
                };

                output_ref.data[r * output_ref.step[0] + c * output_ref.step[1]] = color_model.isSkin(color) * 255;
            }
        }
    }

    void SkinSegmentation::createSkinPixelMapThreshold(const cv::Mat& image, cv::Mat* skin_pixel_map, float min_prob) const
    {
        cv::Mat& output_ref = *skin_pixel_map;
        output_ref.create(image.size(), CV_8UC1);

        const SkinColorModelGaussian& color_model = SkinSegmentation::getColorModel();
        const float MIN_BOUND = 0;
        const float MAX_BOUND = 3.55519e-06;
        for (int r = 0; r < image.rows; ++r)
        {
            for (int c = 0; c < image.cols; ++c)
            {
                int offset = r * image.step[0] + c * image.step[1];

                int color[3] =
                {
                    image.data[offset + 2], // R
                    image.data[offset + 1], // G
                    image.data[offset + 0]  // B
                };

                float p = color_model.skinProb(color);
                std::cout << p << std::endl;
//                p = MIN(1,(p - MIN_BOUND) / (MAX_BOUND - MIN_BOUND)) *255;

                if( p < min_prob) {
                  output_ref.at<unsigned char>(r,c) = 0;
                }else{
                  output_ref.at<unsigned char>(r,c) = 255;
                }
            }
        }
    }

    void SkinSegmentation::createSkinProbabilityMap(const cv::Mat& input, cv::Mat* skin_probability_map) const
    {
      cv::Mat& output_ref = *skin_probability_map;
      output_ref.create(input.size(), CV_8UC1);

      const SkinColorModelGaussian& color_model = SkinSegmentation::getColorModel();
      const float MIN_BOUND = 0;
      const float MAX_BOUND = 3.55519e-06;
      for (int r = 0; r < input.rows; ++r)
      {
          for (int c = 0; c < input.cols; ++c)
          {
              int offset = r * input.step[0] + c * input.step[1];

              int color[3] =
              {
                  input.data[offset + 2], // R
                  input.data[offset + 1], // G
                  input.data[offset + 0]  // B
              };
              float p = color_model.skinProb(color);
              output_ref.at<unsigned char>(r,c) = MIN(1,(p - MIN_BOUND) / (MAX_BOUND - MIN_BOUND)) *255;
          }
      }
      cv::blur(output_ref, output_ref, cv::Size(3,3) );
    }


    void SkinSegmentation::createSkinSegmentMap(const cv::Mat& skin_pixel_map, cv::Mat* skin_segment_map)
    {
        int min_dimension = std::min(skin_pixel_map.rows, skin_pixel_map.cols);
        int step = min_dimension / this->num_segments_;

        if (step == 0)
            return;

        cv::Mat& output_ref = *skin_segment_map;
        output_ref.create(skin_pixel_map.rows / step, skin_pixel_map.cols / step, CV_8UC1);

        for (int r_outer = 0, r = 0; r_outer < skin_pixel_map.rows - step + 1; r_outer += step, ++r)
        {
            for (int c_outer = 0, c = 0; c_outer < skin_pixel_map.cols - step + 1; c_outer += step, ++c)
            {
                unsigned int count = 0;

                for (int r_inner = r_outer; r_inner < r_outer + step; ++r_inner)
                    for (int c_inner = c_outer; c_inner < c_outer + step; ++c_inner)
                        if (skin_pixel_map.data[r_inner * skin_pixel_map.step[0] + c_inner * skin_pixel_map.step[1]])
                            ++count;

                bool is_skin_segment = (float)count / (step * step) >= this->fraction_skin_pixels_required_;

                output_ref.data[r * output_ref.step[0] + c * output_ref.step[1]] = is_skin_segment * 255;
            }
        }
    }

    void SkinSegmentation::createSkinSegments(cv::Mat& skin_segment_map, std::vector<SkinSegment>* skin_segments, std::vector<std::vector<cv::Point> >* contours_output)
    {
        if (!skin_segment_map.data)
            return;

        std::vector<SkinSegment>& output_ref = *skin_segments;
        std::vector<SkinSegment> temp;

        std::vector<std::vector<cv::Point> > contours;
        cv::findContours(skin_segment_map, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);

        unsigned int max_radius = 0;
        for (size_t c = 0; c < contours.size(); ++c)
        {
            cv::Mat contour = cv::Mat(contours[c]);

            cv::Point2f center;
            float radius;
            minEnclosingCircle(contour, center, radius);

            SkinSegment segment(center.x, center.y, radius, this->bounding_box_height_multiplicator_, this->bounding_box_width_to_height_fraction_);
            temp.push_back(segment);

            if (radius > max_radius)
                max_radius = radius;
        }

        for (size_t i = 0; i < temp.size(); ++i)
        {
            if (temp[i].radius_ >= max_radius * this->min_segment_radius_fraction_)
            {
                output_ref.push_back(temp[i]);

                if (contours_output)
                    contours_output->push_back(contours[i]);
            }
        }
    }

    unsigned int SkinSegmentation::createClothingProbabilityMap(const std::vector<SkinSegment>& skin_segments, cv::Mat* clothing_probability_map, const cv::Size& size)
    {
        cv::Mat& output_ref = *clothing_probability_map;
        output_ref.create(size, CV_8UC1);

        unsigned int max = 0;
        for (int r = 0; r < output_ref.rows; ++r)
        {
            for (int c = 0; c < output_ref.cols; ++c)
            {
                unsigned int count = 0;
                for (size_t i = 0; i < skin_segments.size(); ++i)
                {
/*
                    int distance = ((int)c - skin_segments[i].center_[0]) * ((int)c - skin_segments[i].center_[0]) / this->bounding_box_width_to_height_fraction_  + (((int)r - skin_segments[i].center_[1]) * ((int)r - skin_segments[i].center_[1]));
                    if (distance < this->bounding_box_height_multiplicator_ * this->bounding_box_height_multiplicator_ * skin_segments[i].radius_ * skin_segments[i].radius_)
                        ++count;
*/
                    if ((int)r >= skin_segments[i].top_ && (int)r <= skin_segments[i].bottom_ && (int)c >= skin_segments[i].left_ && (int)c <= skin_segments[i].right_)
                        ++count;
                }

                output_ref.data[r * output_ref.step[0] + c * output_ref.step[1]] = (unsigned char)count;

                if (count > max)
                    max = count;
            }
        }

        return max;
    }
}
