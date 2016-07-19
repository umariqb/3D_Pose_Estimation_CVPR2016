
#include "SkinColorModelGaussian.h"

#include <iostream>
#include <cmath>


#include <glog/logging.h>

//#include "../base/config.hpp"

namespace fashion
{
    SkinColorModelGaussian::SkinColorModelGaussian()
    {
          this->buildLookupTables();
    }

    /*virtual*/ SkinColorModelGaussian::~SkinColorModelGaussian(){

    }

    float SkinColorModelGaussian::skinProb(int color[3]) const
    {
        int color_shifted[3] = {color[0] >> TABLE_ENTRY_SHIFT, color[1] >> TABLE_ENTRY_SHIFT, color[2] >> TABLE_ENTRY_SHIFT};

        float p = (this->skinClass_[color_shifted[0]][color_shifted[1]][color_shifted[2]] );
        return p;// - (this->nonskinClass_[color_shifted[0]][color_shifted[1]][color_shifted[2]]) ;
    }

    bool SkinColorModelGaussian::isSkin(int color[3]) const
    {
        int color_shifted[3] = {color[0] >> TABLE_ENTRY_SHIFT, color[1] >> TABLE_ENTRY_SHIFT, color[2] >> TABLE_ENTRY_SHIFT};

        return (this->skinClass_[color_shifted[0]][color_shifted[1]][color_shifted[2]] >
                this->nonskinClass_[color_shifted[0]][color_shifted[1]][color_shifted[2]]);
    }

    bool SkinColorModelGaussian::isSkin(const cv::Vec3b& bgr_colors) const
    {
      int color_shifted[3] = {
          static_cast<int>(bgr_colors[2]) >> TABLE_ENTRY_SHIFT, // r
          static_cast<int>(bgr_colors[1]) >> TABLE_ENTRY_SHIFT, // g
          static_cast<int>(bgr_colors[0]) >> TABLE_ENTRY_SHIFT}; // b

        return (this->skinClass_[color_shifted[0]][color_shifted[1]][color_shifted[2]] >
                this->nonskinClass_[color_shifted[0]][color_shifted[1]][color_shifted[2]]);
    }

    void SkinColorModelGaussian::buildLookupTables(std::size_t bin_start, std::size_t bin_end)
    {
        // Source of the following values:
        //   Statistical color models with application to skin detection (1999)
        //   by Michael J. Jones, James M. Rehg
        //   International Journal of Computer Vision

        static const unsigned int NUM_GAUSSIAN_KERNELS_PER_CLASS = 16;

        static float skinClassGaussianMeans[NUM_GAUSSIAN_KERNELS_PER_CLASS][NUM_CHANNELS] =
        {
            {73.53, 29.94, 17.76},
            {249.71, 233.94, 217.49},
            {161.68, 116.25, 96.95},
            {186.07, 136.62, 114.40},
            {189.26, 98.37, 51.18},
            {247.00, 152.20, 90.84},
            {150.10, 72.66, 37.76},
            {206.85, 171.09, 156.34},
            {212.78, 152.82, 120.04},
            {234.87, 175.43, 138.94},
            {151.19, 97.74, 74.59},
            {120.52, 77.55, 59.82},
            {192.20, 119.62, 82.32},
            {214.29, 136.08, 87.24},
            {99.57, 54.33, 38.06},
            {238.88, 203.08, 176.91}
        };
        static float skinClassGaussianCovariances[NUM_GAUSSIAN_KERNELS_PER_CLASS][NUM_CHANNELS] =
        {
            {765.40, 121.44, 112.80},
            {39.94, 154.44, 396.05},
            {291.03, 60.48, 162.85},
            {274.95, 64.60, 198.27},
            {633.18, 222.40, 250.69},
            {65.23, 691.53, 609.92},
            {408.63, 200.77, 257.57},
            {530.08, 155.08, 572.79},
            {160.57, 84.52, 243.90},
            {163.80, 121.57, 279.22},
            {425.40, 73.56, 175.11},
            {330.45, 70.34, 151.82},
            {152.76, 92.14, 259.15},
            {204.90, 140.17, 270.19},
            {448.13, 90.18, 151.29},
            {178.38, 156.27, 404.99}
        };
        static float skinClassGaussianWeights[NUM_GAUSSIAN_KERNELS_PER_CLASS] =
        {
            0.0294,
            0.0331,
            0.0654,
            0.0756,
            0.0554,
            0.0314,
            0.0454,
            0.0469,
            0.0956,
            0.0763,
            0.1100,
            0.0676,
            0.0755,
            0.0500,
            0.0667,
            0.0749
        };

        static float nonskinClassGaussianMeans[NUM_GAUSSIAN_KERNELS_PER_CLASS][NUM_CHANNELS] =
        {
            {254.37, 254.41, 253.82},
            {9.39, 8.09, 8.52},
            {96.57, 96.95, 91.53},
            {160.44, 162.49, 159.06},
            {74.98, 63.23, 46.33},
            {121.83, 60.88, 18.31},
            {202.18, 154.88, 91.04},
            {193.06, 201.93, 206.55},
            {51.88, 57.14, 61.55},
            {30.88, 26.84, 25.32},
            {44.97, 85.96, 131.95},
            {236.02, 236.27, 230.70},
            {207.86, 191.20, 164.12},
            {99.83, 148.11, 188.17},
            {135.06, 131.92, 123.10},
            {135.96, 103.89, 66.88}
        };
        static float nonskinClassGaussianCovariances[NUM_GAUSSIAN_KERNELS_PER_CLASS][NUM_CHANNELS] =
        {
            {2.77, 2.81, 5.46},
            {46.84, 33.59, 32.48},
            {280.69, 156.79, 436.58},
            {355.98, 115.89, 591.24},
            {414.84, 245.95, 361.27},
            {2502.24, 1383.53, 237.18},
            {957.42, 1766.94, 1582.52},
            {562.88, 190.23, 447.28},
            {344.11, 191.77, 433.40},
            {222.07, 118.65, 182.41},
            {651.32, 840.52, 963.67},
            {225.03, 117.29, 331.95},
            {494.04, 237.69, 533.52},
            {955.88, 654.95, 916.70},
            {350.35, 130.30, 388.43},
            {806.44, 642.20, 350.36}
        };
        static float nonskinClassGaussianWeights[NUM_GAUSSIAN_KERNELS_PER_CLASS] =
        {
            0.0637,
            0.0516,
            0.0864,
            0.0636,
            0.0747,
            0.0365,
            0.0349,
            0.0649,
            0.0656,
            0.1189,
            0.0362,
            0.0849,
            0.0368,
            0.0389,
            0.0943,
            0.0477
        };

        for (unsigned int c1 = bin_start; c1 < bin_end; c1 += 4)
        {
            for (unsigned int c2 = 0; c2 < 256; c2 += 4)
            {
                for (unsigned int c3 = 0; c3 < 256; c3 += 4)
                {
                    int color[3] = {c1, c2, c3};

                    float skin_score = 0.0f;
                    for (unsigned int gaussian = 0; gaussian < NUM_GAUSSIAN_KERNELS_PER_CLASS; ++gaussian)
                    {
                        skin_score += gaussianValue(color,
                                                    skinClassGaussianMeans[gaussian],
                                                    skinClassGaussianCovariances[gaussian],
                                                    skinClassGaussianWeights[gaussian]);
                    }

                    float nonskin_score = 0.0f;
                    for (unsigned int gaussian = 0; gaussian < NUM_GAUSSIAN_KERNELS_PER_CLASS; ++gaussian)
                    {
                        nonskin_score += gaussianValue(color,
                                                       nonskinClassGaussianMeans[gaussian],
                                                       nonskinClassGaussianCovariances[gaussian],
                                                       nonskinClassGaussianWeights[gaussian]);
                    }

                    this->skinClass_[c1 >> TABLE_ENTRY_SHIFT][c2 >> TABLE_ENTRY_SHIFT][c3 >> TABLE_ENTRY_SHIFT] = skin_score;
                    this->nonskinClass_[c1 >> TABLE_ENTRY_SHIFT][c2 >> TABLE_ENTRY_SHIFT][c3 >> TABLE_ENTRY_SHIFT] = nonskin_score;
                }
            }
        }
    }

    float SkinColorModelGaussian::gaussianValue(int color[3], float mean[3], float covariance[3], float weight)
    {
        static float pi = 3.14159265358979323846f;
        static float const_factor = sqrt(8.0f * pi * pi * pi);

        float covariance_determinant = covariance[0] * covariance[1] * covariance[2];
        float distance[3] = {color[0] - mean[0], color[1] - mean[1], color[2] - mean[2]};
        float exponent = -0.5 * (distance[0] * distance[0] / covariance[0] +
                                 distance[1] * distance[1] / covariance[1] +
                                 distance[2] * distance[2] / covariance[2]);

        float value = weight / (const_factor * sqrt(covariance_determinant)) * exp(exponent);

        return value;
    }
}
