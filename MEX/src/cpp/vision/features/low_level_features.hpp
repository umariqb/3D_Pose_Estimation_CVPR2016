/*
 * Features.hpp
 *
 *  Created on: Oct 11, 2011
 *      Author: lbossard
 */

#ifndef FEATURES_LOW_LEVEL_FEATURES_HPP_
#define FEATURES_LOW_LEVEL_FEATURES_HPP_

#include "low_level/low_level_feature_extractor.hpp"
#include "low_level/surf.hpp"
#include "low_level/dense_surf.hpp"
#include "low_level/hog.hpp"
#include "low_level/felzen_hog.hpp"
#include "low_level/lbp.hpp"
#include "low_level/color.hpp"
#include "low_level/self_similarity.hpp"
#include "low_level/holbp.hpp"
#include "low_level/root_sift.hpp"

namespace vision
{
namespace features
{

namespace feature_type
{
enum feature_type
{
    Surf       = 1 << 0, //  1
    Hog        = 1 << 1, //  2
    Color      = 1 << 2, //  4
    Lbp        = 1 << 3, //  8
    Ssd        = 1 << 4, // 16
    ColorSsd   = 1 << 5, // 32
    Gist       = 1 << 6, // 64
    ColorGist  = 1 << 7, // 128
    RootSurf   = 1 << 8, // 256
    FelzenHog  = 1 << 9, // 512
    HoLbp      = 1 << 10, // 1024
		DenseSurf	 = 1 << 11, // 2048
		RootSift   = 1 << 12, // 4096

    None    = 0,
      //         1 +    2 +   4 +    8    + 16
//    All     = Surf | Hog | Color | Lbp | Ssd,
};
typedef feature_type T;

T from_string(const std::string& feature_str);

std::string to_string(T type);

}


class ExtractorFactory
{
public:
    static LowLevelFeatureExtractor* createExtractor(const std::string& class_name);
    static LowLevelFeatureExtractor* createExtractor(const feature_type::T feature_type);
private:
    ExtractorFactory();
};

} /* namespace features */
} /* namespace vision */
#endif /* FEATURES_LOW_LEVEL_FEATURES_HPP_ */
