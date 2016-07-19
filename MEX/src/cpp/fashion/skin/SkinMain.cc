
#include <iostream>


#include <opencv2/imgproc/imgproc.hpp>

#include "SkinSegmentation.h"

namespace fashion
{
    void skin_main(const cv::Mat& image)
    {
        // Compute clothing probability
        SkinSegmentation skin_segmentation;

        cv::Mat skin_map;
        skin_segmentation.createSkinPixelMap(image, &skin_map);

        cv::Mat skin_segment_map;
        skin_segmentation.createSkinSegmentMap(skin_map, &skin_segment_map);

        std::vector<SkinSegment> skin_segments;
        std::vector<std::vector<cv::Point> > contours;
        skin_segmentation.createSkinSegments(skin_segment_map, &skin_segments, &contours);

        cv::Mat clothing_probability_map;
        unsigned int max = skin_segmentation.createClothingProbabilityMap(skin_segments, &clothing_probability_map, skin_segment_map.size());



        // Display original image
        cv::Mat original;
        cv::resize(image, original, cv::Size(), 0.5, 0.5);

        // Display the different steps in one big image
        unsigned int scaling_factor = 1;
        cv::Size steps_images_size = cv::Size(skin_segment_map.cols * scaling_factor, skin_segment_map.rows * scaling_factor);

        cv::Mat step1;
        cv::resize(skin_map, step1, steps_images_size, 0, 0, cv::INTER_NEAREST);
        cvtColor(step1, step1, CV_GRAY2BGR);

        cv::Mat step2;
        cv::drawContours(skin_segment_map, contours, -1, cv::Scalar(255));
        cv::resize(skin_segment_map, step2, steps_images_size, 0, 0, cv::INTER_AREA);
        cvtColor(step2, step2, CV_GRAY2BGR);

        cv::Mat step3;
        cv::resize(image, step3, steps_images_size);
        (step3 /= 2) |= step2;
        for (size_t i = 0; i < skin_segments.size(); ++i)
            cv::circle(step3, cv::Point(skin_segments[i].center_[0] * scaling_factor, skin_segments[i].center_[1] * scaling_factor), skin_segments[i].radius_ * scaling_factor, cv::Scalar(0, 0, 255), 2);

        cv::Mat step4;
        cv::resize(clothing_probability_map, step4, steps_images_size, 0, 0, cv::INTER_AREA);
        if (max)
            step4 *= (255 / max);
        cvtColor(step4, step4, CV_GRAY2BGR);

        cv::Mat step1to4(steps_images_size.height * 2, steps_images_size.width * 2, CV_8UC3);
        for (int r = 0; r < step1to4.rows / 2; ++r)
        {
            memcpy(step1to4.data + r * step1to4.step[0], step1.data + r * step1.step[0], step1.step[0]);
            memcpy(step1to4.data + r * step1to4.step[0] + step1to4.step[0] / 2, step2.data + r * step2.step[0], step2.step[0]);
        }
        for (int r = 0; r < step1to4.rows / 2; ++r)
        {
            memcpy(step1to4.data + (r + step1to4.rows / 2) * step1to4.step[0], step3.data + r * step3.step[0], step3.step[0]);
            memcpy(step1to4.data + (r + step1to4.rows / 2) * step1to4.step[0] + step1to4.step[0] / 2, step4.data + r * step4.step[0], step4.step[0]);
        }


        // Display the final result
        cv::Mat result;
        cv::resize(clothing_probability_map, result, image.size(), 0, 0, cv::INTER_AREA);
        if (max)
            result *= (255 / max);
        cvtColor(result, result, CV_GRAY2BGR);
        cv::multiply(result, image, result, 1.0 / 255);

    }
}
