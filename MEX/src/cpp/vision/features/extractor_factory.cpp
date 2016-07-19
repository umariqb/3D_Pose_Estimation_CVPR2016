/*
 * extractor_factory.cpp
 *
 *  Created on: Jan 14, 2014
 *      Author: mdantone
 */

#include "extractor_factory.hpp"
#include "cpp/utils/serialization/opencv_serialization.hpp"
#include "cpp/utils/serialization/serialization.hpp"

namespace vision {
namespace features {

  Extractor* createExtractor( vision::features::ExtractorParam param  ) {

    if( param.has_spm_extractor_param() ) {
      return createSpmBowExtractor( param.spm_extractor_param() );
    }else{
      return NULL;
    }
  }



  SpmBowExtractor* createSpmBowExtractor( SpmBowExtractorParam spm_parm ) {

    cv::Mat surf_voc;
    cv::Mat hog_voc;
    cv::Mat color_voc;
    cv::Mat ssd_voc;
    cv::Mat holbp_voc;
    cv::Mat dense_surf_voc;
    int pyramid_levels = 1;
    if(spm_parm.has_pyramid_levels()) {
      pyramid_levels = spm_parm.pyramid_levels();
    }

    if(spm_parm.has_surf_param()) {
      LowLevelFeatureParam param = spm_parm.surf_param();
      CHECK(utils::serialization::read_binary_archive(param.voc_path(), surf_voc));
    }

    if(spm_parm.has_hog_param()) {
      LowLevelFeatureParam param = spm_parm.hog_param();
      CHECK(utils::serialization::read_binary_archive(param.voc_path(), hog_voc));
    }

    if(spm_parm.has_color_param()) {
      LowLevelFeatureParam param = spm_parm.color_param();
      CHECK(utils::serialization::read_binary_archive(param.voc_path(), color_voc));
    }

    if(spm_parm.has_ssd_param()) {
      LowLevelFeatureParam param = spm_parm.ssd_param();
      CHECK(utils::serialization::read_binary_archive(param.voc_path(), ssd_voc));
    }

    if(spm_parm.has_holbp_param()) {
      LowLevelFeatureParam param = spm_parm.holbp_param();
      CHECK(utils::serialization::read_binary_archive(param.voc_path(), holbp_voc));
    }

    if(spm_parm.has_dense_surf_param()) {
      LowLevelFeatureParam param = spm_parm.dense_surf_param();
      CHECK(utils::serialization::read_binary_archive(param.voc_path(), dense_surf_voc));
    }

    vision::features::feature_type::T feature_type = vision::features::feature_type::None;
    if (spm_parm.has_feature_types()) {
      feature_type = (vision::features::feature_type::T) spm_parm.feature_types();
    }
    SpmBowExtractor* spm_bow_ext = new SpmBowExtractor(pyramid_levels,
          feature_type,
          surf_voc, hog_voc, color_voc,
          ssd_voc, holbp_voc, dense_surf_voc);

    if(feature_type == vision::features::feature_type::Surf &&
        spm_parm.has_grid_width()) {
      vision::features::Surf* surf_ext = spm_bow_ext->get_surf_extractor();
      surf_ext->set_grid_spacing(spm_parm.grid_width());
    }
    return spm_bow_ext;
  };



} /* namespace features */
} /* namespace vision */
