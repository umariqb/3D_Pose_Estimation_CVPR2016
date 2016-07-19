/*
 * mean_shift.hpp
 *
 *  Created on: Jul 22, 2012
 *      Author: Matthias Dantone
 */

#ifndef MEAN_SHIFT_HPP_
#define MEAN_SHIFT_HPP_

#include <vector>
#include <opencv2/opencv.hpp>

namespace vision {
namespace mean_shift {

struct Vote {
  Vote(): check(false){};
  cv::Point2i pos;
  cv::Point2i origin;
  float weight;
  bool check;
};


struct MeanShiftOption {
  MeanShiftOption() :
      kernel_size(10), max_iterations(15), stopping_criteria(0.8) {
  };
  int kernel_size;
  int max_iterations;
  float stopping_criteria;
};

class MeanShift {
public:
  MeanShift() {
  };

  static float dist_l2(const cv::Point_<float> a, const cv::Point_<float> b) {
    return sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
  }

  static void shift(const std::vector<Vote>& votes, cv::Point_<int>& result,
      MeanShiftOption& option) {
    shift(votes, result, option.max_iterations,
        option.kernel_size, option.stopping_criteria);
  }
  static void shift(const std::vector<Vote>& votes, cv::Point_<int>& result,
      int num_iterations, int kernel, float stopping_criteria) {
    bool covergenz = false;
    cv::Point_<float> mean;
    getMean(votes, mean);

    for (int i = 0; i < num_iterations and covergenz == false; i++) {
      cv::Point_<float> shifted_mean;
      getWeightedMean(votes, mean, kernel, shifted_mean);
      if (dist_l2(shifted_mean, mean) < stopping_criteria)
        covergenz = true;
      mean = shifted_mean;
    }
    result.x = static_cast<int>(mean.x);
    result.y = static_cast<int>(mean.y);
  }

  virtual ~MeanShift() {
  };
private:

  static void getWeightedMean(const std::vector<Vote>& votes,
      const cv::Point_<float> mean, float lamda, cv::Point_<float>& shifted_mean) {
    shifted_mean = cv::Point(0.0, 0.0);
    float sum_w = 0;

    std::vector<Vote>::const_iterator it;
    for (it = votes.begin(); it < votes.end(); ++it) {
      const Vote& v = (*it);
      if (!v.check)
        continue;

      float d = dist_l2(mean, v.pos);
      d = 1.0 / exp(d / lamda);
      float w = v.weight * d;
      shifted_mean.x += v.pos.x * w;
      shifted_mean.y += v.pos.y * w;
      sum_w += w;

    }
    if (sum_w > 0) {
      shifted_mean.x /= sum_w;
      shifted_mean.y /= sum_w;
    }
  }

  static void getMean(const std::vector<Vote>& votes, cv::Point_<float>& mean) {

    mean = cv::Point(0.0, 0.0);
    float sum_w = 0;
    std::vector<Vote>::const_iterator it;
    for (it = votes.begin(); it < votes.end(); ++it) {
      const Vote& v = (*it);
      if (!v.check)
        continue;

      float w = v.weight;
      mean.x += v.pos.x*w;
      mean.y += v.pos.y*w;
      sum_w += w;
    }
    if (sum_w > 0) {
      mean.x /= sum_w;
      mean.y /= sum_w;
    }
  }
};

} //namespace mean_shift
} //namespace vision

#endif /* MEAN_SHIFT_HPP_ */
