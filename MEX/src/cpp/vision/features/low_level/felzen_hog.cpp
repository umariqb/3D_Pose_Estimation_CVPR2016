/*
 * felzen_hog.cpp
 *
 *  Created on: Sep 2, 2013
 *      Author: lbossard
 */

#include "felzen_hog.hpp"

extern "C" {
  #include "cpp/third_party/vlfeat/vl/hog.h"
}

namespace vision {
namespace features {

FelzenHogExtracor::FelzenHogExtracor(int num_orientations, uint32_t cell_size){
  _cell_size = cell_size;
  _num_orientation_bins = num_orientations;
  _vl_hog = vl_hog_new(VlHogVariantUoctti, _num_orientation_bins, /*img_is_colmajor*/ VL_FALSE);
}

FelzenHogExtracor::~FelzenHogExtracor(){
  vl_hog_delete(_vl_hog);
}

uint32_t FelzenHogExtracor::descriptor_length(uint32_t patch_width, uint32_t patch_height) const {
  const uint32_t hog_width = (patch_width + _cell_size/2) / _cell_size ;
  const uint32_t hog_height = (patch_height + _cell_size/2) / _cell_size;
  const uint32_t hog_dims = vl_hog_get_dimension(_vl_hog);
  return hog_width * hog_height * hog_dims;
}

void FelzenHogExtracor::extract(const cv::Mat& patch, cv::Mat_<float>* descriptor_) const {

  cv::Mat_<float> continuous_patch;

  // bgr image
  if (patch.channels() == 1){
    patch.convertTo(continuous_patch, CV_32FC1, 1./255);
  }
  else {
    /*
     * in case of three channels, copy to vlfeat format:
     *   channels * width* height + row + height * col
     */
    CHECK(patch.channels() == 3);
    cv::Mat_<cv::Vec3b> bgr_patch = patch;
    continuous_patch.create(3 * patch.rows, patch.cols);
    float* dest_r = continuous_patch[0 * patch.rows];
    float* dest_g = continuous_patch[1 * patch.rows];
    float* dest_b = continuous_patch[2 * patch.rows];

    for (int r = 0; r < bgr_patch.rows; ++r){
      for (int c = 0; c < bgr_patch.cols; ++c) {
        cv::Vec3b& bgr = bgr_patch(r,c);
        *dest_b++ = bgr[0] / 255.;
        *dest_g++ = bgr[1] / 255.;
        *dest_r++ = bgr[2] / 255.;
      }
    }
  }
  DCHECK(continuous_patch.isContinuous());

  vl_hog_put_image(_vl_hog,
      continuous_patch[0],
      patch.cols,
      patch.rows,
      patch.channels(),
      _cell_size
  );

  cv::Mat_<float>& descriptor = *descriptor_;
  uint32_t descriptor_dim = descriptor_length(patch.cols, patch.rows);
  descriptor.create(1, descriptor_dim);
  vl_hog_extract(_vl_hog, descriptor[0]);

}



void FelzenHogExtracor::visualize(const cv::Mat_<float>& descriptor, cv::Mat_<uchar>* vis) const {

  const int glyph_size = vl_hog_get_glyph_size(_vl_hog) ;
  const int img_height = glyph_size * vl_hog_get_height(_vl_hog);
  const int img_width = glyph_size * vl_hog_get_width(_vl_hog);
  cv::Mat_<float> float_img = cv::Mat_<float>::zeros(img_width, img_height);
  vl_hog_render(_vl_hog, float_img[0], descriptor[0], vl_hog_get_width(_vl_hog), vl_hog_get_height(_vl_hog)) ;
  const float max_val = *std::max_element(float_img.begin(), float_img.end());
  float_img.convertTo(*vis, cv::DataType<uchar>::type, 255./max_val);
}

////////////////////////////////////////////////////////////////////////////////

FelzenHog::FelzenHog()
: _extractor(/*num_orientations*/ 9, /*cell_size*/ 8)
{
  _grid_width = 8;
  _patch_width = 8;
  _patch_height = 8;
}


FelzenHog::FelzenHog(
    int num_orientations,
    int cell_size,
    int patch_size,
    int grid_width)
: _extractor(num_orientations, cell_size)
{
  _grid_width = grid_width;
  _patch_width = patch_size;
  _patch_height = patch_size;
}

FelzenHog::~FelzenHog() {
}


/*virtual*/ unsigned int FelzenHog::descriptorLength() const {
  return _extractor.descriptor_length(_patch_width, _patch_height);
}

/*virtual*/ cv::Mat_<float> FelzenHog::denseExtract(
    const cv::Mat& image,
    std::vector<cv::Point>& locations,
    const cv::Mat_<uchar>& mask
) const {
  // compute dense grid points
  locations.clear();
  LowLevelFeatureExtractor::generateGridLocations(
      image.size(),
      cv::Size(_grid_width, _grid_width),
      _grid_width,
      _grid_width,
      locations,
      mask);
  if (locations.size() == 0) {
    return cv::Mat_<float>();
  }

  cv::Mat_<float> descriptors(locations.size(), descriptorLength());
  for (size_t i = 0; i < locations.size(); ++i) {

    cv::Rect r = cv::Rect(
        locations[i].x - _patch_width/2,
        locations[i].y - _patch_height/2,
        _patch_width,
        _patch_height);
    CHECK(r.x >= 0 && r.y >= 0 && r.x + r.width <= image.cols && r.y + r.height <= image.rows);
    cv::Mat patch = image(r);
    cv::Mat_<float> row = descriptors.row(i);
    _extractor.extract(patch, &row);
  }
  return descriptors;
}

} /* namespace features */
} /* namespace vision */
