/*
 * Features.cpp
 *
 *  Created on: Oct 11, 2011
 *      Author: lbossard
 */

#include "low_level_features.hpp"

#include <boost/algorithm/string/case_conv.hpp>

namespace vision
{
namespace features
{

namespace feature_type
{
T from_string(const std::string& feature_str)
{
    std::string class_name_lower = boost::algorithm::to_lower_copy(feature_str);
    if (class_name_lower == "surf")
    {
        return Surf;
    }
		else if (class_name_lower == "rootsurf")
    {
        return RootSurf;
    }
    else if (class_name_lower == "rootsift")
    {
        return RootSift;
    }
		else if (class_name_lower == "densesurf")
		{
				return DenseSurf;
		}
    else if (class_name_lower == "hog")
    {
        return Hog;
    }
    else if (class_name_lower == "felzhog")
    {
        return FelzenHog;
    }
    else if (class_name_lower == "color")
    {
        return Color;
    }
    else if (class_name_lower == "lbp")
    {
        return Lbp;
    }
    else if (class_name_lower == "ssd")
    {
        return Ssd;
    }
    else if (class_name_lower == "colorssd")
    {
        return ColorSsd;
    }
    else if (class_name_lower == "gist")
    {
    	return Gist;
    }
    else if (class_name_lower == "colorgist")
    {
    	return ColorGist;
    }
    else if(class_name_lower == "holbp") {
      return HoLbp;
    }else
    {
        return None;
    }
}

void inline concatenate(const std::string extension, std::string* src  ) {
  if(*src != "") {
    *src +="_";
  }
  *src += extension;
}
std::string to_string(const T feature_types)
{

  std::string s = "";

  if (feature_types & Surf) {
    concatenate("surf", &s);
  }

  if (feature_types & RootSurf) {
    concatenate("rootsurf", &s);
  }
  if (feature_types & RootSift) {
    concatenate("rootsift", &s);
  }

  if (feature_types & Hog) {
    concatenate("hog", &s);
  }

  if (feature_types & FelzenHog) {
    concatenate("felzhog", &s);
  }

  if (feature_types & Color) {
    concatenate("color", &s);
  }

  if (feature_types & Lbp) {
    concatenate("lbp", &s);
  }

  if (feature_types & Ssd) {
    concatenate("ssd", &s);
  }

  if (feature_types & ColorSsd) {
    concatenate("colorssd", &s);
  }

  if (feature_types & Gist) {
    concatenate("gist", &s);
  }

  if (feature_types & ColorGist) {
    concatenate("colorgist", &s);
  }

  if (feature_types & HoLbp) {
    concatenate("holbp", &s);
  }

  if( s == "") {
    return "INVALID";
  }

  return s;
}

} // namespace feature_type

///////////////////////////////////////////////////////////////////////////////
// Factory

/**
 * Return extractor with the specific name
 * @param class_name extractor name
 * @return
 */
/*static*/ LowLevelFeatureExtractor* ExtractorFactory::createExtractor(const std::string& feature_type)
{
    return createExtractor(feature_type::from_string(feature_type));
}

/*static*/ LowLevelFeatureExtractor* ExtractorFactory::createExtractor(const feature_type::T type)
{

    switch(type)
    {
    case feature_type::Surf:
        return new Surf();
        break;
    case feature_type::RootSurf:
        return new RootSurf();
        break;
    case feature_type::Hog:
        return new Hog();
        break;
//    case feature_type::FelzenHog:
//        return new FelzenHog();
//        break;
    case feature_type::Color:
        return new Color();
        break;
    case feature_type::Lbp:
        return new Lbp();
        break;
    case feature_type::Ssd:
        return new SelfSimilarityExtractor(false);
        break;
    case feature_type::ColorSsd:
        return new SelfSimilarityExtractor(true);
        break;
    case feature_type::HoLbp:
        return new HoLbp();
        break;
		case feature_type::DenseSurf:
				return new DenseSurf();
				break;
//    case feature_type::RootSift:
//        return new RootSift();
//        break;

    case feature_type::Gist:
    case feature_type::ColorGist:
      std::cout << "Color-/Gist is not a LowLevelFeatureExtractor" << std::endl;
      return NULL;
      break;
    case feature_type::None:
        return NULL;
        break;
    }
    return NULL;
}




} /* namespace features */
} /* namespace vision */
