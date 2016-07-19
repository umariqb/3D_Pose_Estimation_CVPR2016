#ifndef FASHION_SKIN_COLOR_MODEL_GAUSSIAN_H__
#define FASHION_SKIN_COLOR_MODEL_GAUSSIAN_H__

#include <cstddef>
#include <opencv2/core/core.hpp>

#include "SkinColorModel.h"


namespace fashion
{
    class SkinColorModelGaussian : public SkinColorModel
    {
        static const unsigned int TABLE_ENTRY_SHIFT = 2;
        static const unsigned int NUM_TABLE_ENTRIES_PER_CHANNEL = 256 >> TABLE_ENTRY_SHIFT;
        static const unsigned int NUM_CHANNELS = 3;

        public:
            SkinColorModelGaussian();

            virtual bool isSkin(int color[3]) const;
            virtual float skinProb(int color[3]) const;
            bool isSkin(const cv::Vec3b& bgr_colors) const;

            float skinProb(int color[3]);
            virtual ~SkinColorModelGaussian();

        private:
            float max_p;

            void buildLookupTables(std::size_t bin_start = 0, std::size_t bin_end = 256);
            float gaussianValue(int color[3], float mean[3], float covariance[3], float weight);

            float skinClass_[NUM_TABLE_ENTRIES_PER_CHANNEL][NUM_TABLE_ENTRIES_PER_CHANNEL][NUM_TABLE_ENTRIES_PER_CHANNEL];
            float nonskinClass_[NUM_TABLE_ENTRIES_PER_CHANNEL][NUM_TABLE_ENTRIES_PER_CHANNEL][NUM_TABLE_ENTRIES_PER_CHANNEL];
    };
}

#endif /* FASHION_SKIN_COLOR_MODEL_GAUSSIAN_H__ */
