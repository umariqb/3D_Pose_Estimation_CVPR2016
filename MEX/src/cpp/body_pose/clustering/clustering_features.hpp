/*
 * clustering_features.hpp
 *
 *  Created on: Jul 30, 2013
 *      Author: mdantone
 */

#ifndef CLUSTERING_FEATURES_HPP_
#define CLUSTERING_FEATURES_HPP_

#include <opencv2/opencv.hpp>
#include "cpp/utils/string_utils.hpp"
#include "cpp/body_pose/common.hpp"
#include "cpp/body_pose/body_pose_types.hpp"

namespace body_pose {
namespace clustering {

enum ClusterMethod
{
   PART_POSE=1,
   GLOBAL_POSE=2,
   GIST_APPEARANCE=3,
   BOW_SPM=4,
   MULTI_PARTS_POSE=5
};

class FeatureExtractor {
public:
  virtual int feature_size() const = 0;
  virtual void extract_feature(const Annotation& ann, cv::Mat& feature) = 0;
  virtual std::string get_name() const = 0;
  virtual bool check(const Annotation& ann) const = 0;
  virtual ~FeatureExtractor(){};
};


FeatureExtractor* feature_extractor_factory(ClusterMethod method,
    const std::vector<int>& part_indices,
    body_pose::BodyPoseTypes pose_type);

} /* namespace clustering */
} /* namespace body_pose */
#endif /* CLUSTERING_FEATURES_HPP_ */
