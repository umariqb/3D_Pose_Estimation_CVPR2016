/*
 * extractor_factory.hpp
 *
 *  Created on: Jan 14, 2014
 *      Author: mdantone
 */

#ifndef EXTRACTOR_FACTORY_HPP_
#define EXTRACTOR_FACTORY_HPP_

#include "cpp/vision/features/extractor.hpp"
//#include "cpp/vision/features/extractor_param.pb.h"

#include "cpp/vision/features/spmbow_extractor.hpp"



namespace vision {
namespace features {



  Extractor* createExtractor(  vision::features::ExtractorParam param );

  SpmBowExtractor* createSpmBowExtractor(
      vision::features::SpmBowExtractorParam spm_parm );


} /* namespace features */
} /* namespace vision */
#endif /* EXTRACTOR_FACTORY_HPP_ */
