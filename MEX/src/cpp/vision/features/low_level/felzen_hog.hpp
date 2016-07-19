/*
 * felzen_hog.hpp
 *
 *  Created on: Sep 2, 2013
 *      Author: lbossard
 */

#ifndef VISON__FEATURES__LOW_LEVEL__FELZEN_HOG_HPP_
#define VISON__FEATURES__LOW_LEVEL__FELZEN_HOG_HPP_

#include "low_level_feature_extractor.hpp"

// forward declaration for vlfeat structure.
struct VlHog_;
typedef VlHog_ VlHog;

namespace vision {
namespace features {


class FelzenHogExtracor {
public:
  explicit FelzenHogExtracor(int num_orientations=9, uint32_t cell_size=8);

  ~FelzenHogExtracor();

  uint32_t descriptor_length(uint32_t patch_width, uint32_t patch_height) const;

  void extract(const cv::Mat& patch, cv::Mat_<float>* descriptor_) const;

  void visualize(const cv::Mat_<float>& descriptor, cv::Mat_<uchar>* vis) const;

  inline uint32_t cell_size() const {return _cell_size; }
  inline uint32_t num_orientation_bins() const {return _num_orientation_bins; }

private:
  VlHog* _vl_hog;

  uint32_t _num_orientation_bins;
  uint32_t _cell_size;
};


// PROBALBY NOT THREADSAFE!
class FelzenHog : public LowLevelFeatureExtractor {
public:
  FelzenHog();

  /**
   * patch_size and grid width is only relevant for dense extract
   * @param num_orientations
   * @param cell_size
   * @param patch_size
   * @param grid_width
   */
  FelzenHog(int num_orientations, int cell_size, int patch_size=8, int grid_width=8);

  virtual ~FelzenHog();

  virtual void extract_at_extremas(const cv::Mat& image,
      cv::Mat_<float>* descriptors,
      const cv::Mat_<uchar>& mask = cv::Mat_<char>()) const {
    CHECK(false) << "not supported";
  }

  virtual cv::Mat_<float> denseExtract(
      const cv::Mat& image,
      std::vector<cv::Point>& descriptor_locations,
      const cv::Mat_<uchar>& mask = cv::Mat_<char>()
  ) const;

  virtual unsigned int descriptorLength() const;


private:
  FelzenHogExtracor _extractor;

	uint8_t _grid_width;
  uint32_t _patch_width;
  uint32_t _patch_height;

};

//==============================================================================
// implementation

} /* namespace features */
} /* namespace vision */
#endif /* VISON__FEATURES__LOW_LEVEL__FELZEN_HOG_HPP_ */
