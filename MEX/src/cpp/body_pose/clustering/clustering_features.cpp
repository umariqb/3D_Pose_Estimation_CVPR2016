/*
 * clustering_features.cpp
 *
 *  Created on: Jul 30, 2013
 *      Author: mdantone
 */

#include "clustering_features.hpp"

#include <opencv2/opencv.hpp>
#include <fstream>

#include <boost/lexical_cast.hpp>
#include <boost/filesystem/path.hpp>
#include <boost/format.hpp>
#include <boost/serialization/vector.hpp>
#include <boost/serialization/utility.hpp>
#include <boost/iostreams/device/file.hpp>
#include <boost/iostreams/stream.hpp>
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>

#include "cpp/vision/features/global/gist.hpp"
#include "cpp/vision/features/spmbow_extractor.hpp"
#include "cpp/vision/features/low_level_features.hpp"


#include "cpp/utils/serialization/opencv_serialization.hpp"
#include "cpp/utils/serialization/serialization.hpp"


using namespace std;
using namespace cv;
namespace body_pose {
namespace clustering {


class GlobalPose: public FeatureExtractor {
public:
  GlobalPose():num_joints(13){}
  GlobalPose(body_pose::BodyPoseTypes pose_type):
            num_joints(static_cast<int>(pose_type)), _pose_type(pose_type){}
  int virtual feature_size() const {
    return num_joints*4;
  }
  void virtual extract_feature(const Annotation& ann, Mat& feature) {

    CHECK_EQ(feature.cols, feature_size());
    CHECK_EQ(feature.cols, ann.parts.size()*4);

    vector<int> parents;
    get_joint_constalation(parents, _pose_type);
    Point head = ann.parts[0];

    for(int i=0; i < ann.parts.size(); i++) {


      const Point& part = ann.parts[i];
      const Point& parent = ann.parts[parents[i]];
      Point offset_parent = part - parent;
      feature.at<float>(0,i*4)   = ann.parts[i].x - head.x;
      feature.at<float>(0,i*4+1) = ann.parts[i].y - head.y;
      feature.at<float>(0,i*4+2) = offset_parent.x;
      feature.at<float>(0,i*4+3) = offset_parent.y;
    }
  }
  string virtual get_name() const {
    return "global_pose";
  }

  bool check(const Annotation& ann) const {
    bool all_parts_present = true;
    for(int j=0; j < ann.parts.size(); j++) {
      if(ann.parts[j].x < 0 || ann.parts[j].y < 0)
        all_parts_present = false;
    }
    return all_parts_present;
  }

private:
  int num_joints;
  body_pose::BodyPoseTypes _pose_type;
};

class MultiPartPose: public FeatureExtractor {
public:

  MultiPartPose(const std::vector<int>& part_indices, const body_pose::BodyPoseTypes pose_type, bool include_head_offset = false )
    : _part_indices(part_indices), _pose_type(pose_type), _include_head_offset(false){
  }

  int virtual feature_size() const {
    if(_include_head_offset) {
      return _part_indices.size()*4;
    }else{
      return _part_indices.size()*2;
    }
  }
  void virtual extract_feature(const Annotation& ann, Mat& feature) {
    CHECK_EQ(feature.cols, feature_size());
    vector<int> parents;
    get_joint_constalation(parents, _pose_type);

    for(int i=0; i < _part_indices.size(); i++) {
      int part_id = _part_indices[i];
      const Point& part = ann.parts[part_id];
      const Point& parent = ann.parts[parents[part_id]];
      Point offset_parent = part - parent;

      if(_include_head_offset){
        Point head = ann.parts[0];
        feature.at<float>(0,i*4)   = offset_parent.y;
        feature.at<float>(0,i*4+1) = offset_parent.x;
        feature.at<float>(0,i*4+2) = ann.parts[i].x - head.x;
        feature.at<float>(0,i*4+3) = ann.parts[i].y - head.y;
      }else{
        feature.at<float>(0,i*2)   = offset_parent.y;
        feature.at<float>(0,i*2+1) = offset_parent.x;
      }

    }
  }
  string virtual get_name() const {
    return "global_pose";
  }

  bool check(const Annotation& ann) const {
    bool all_parts_present = true;
    for(int j=0; j < ann.parts.size(); j++) {
      if(ann.parts[j].x < 0 || ann.parts[j].y < 0)
        all_parts_present = false;
    }
    return all_parts_present;
  }

private:
  std::vector<int> _part_indices;
  bool _include_head_offset;
  body_pose::BodyPoseTypes _pose_type;
};

class GistAppearance: public FeatureExtractor {
public:
  int virtual feature_size() const {
    return 320;
  }
  void virtual extract_feature(const Annotation& ann, Mat& feature) {

    Mat_<float> gist_feature;

    Mat img = cv::imread(ann.url, 0);
    CHECK(img.data != NULL);
    vision::features::global::Gist::extract(img, gist_feature);
    CHECK_EQ(gist_feature.cols, feature.cols);
    for(int i=0; i < gist_feature.cols; i++) {
      feature.at<float>(0,i) = gist_feature.at<float>(0,i);
    }
  }
  string virtual get_name() const {
    return "gist_app";
  }

  bool check(const Annotation& ann) const {
    bool all_parts_present = true;
    for(int j=0; j < ann.parts.size(); j++) {
      if(ann.parts[j].x < 0 || ann.parts[j].y < 0)
        all_parts_present = false;
    }
    return all_parts_present;
  }
};

class BowSPM : public FeatureExtractor {
public:
  BowSPM():
    surf_file( "/scratch_net/giggo/mdantone/grid/pose_leed/bow/surf_1024_4096imgs.voc"),
    hog_file(  "/scratch_net/giggo/mdantone/grid/pose_leed/bow/hog_1024_4096imgs.voc"),
    color_file("/scratch_net/giggo/mdantone/grid/pose_leed/bow/color_256_4096imgs.voc"){

    utils::serialization::read_binary_archive(surf_file, surf_voc);
    utils::serialization::read_binary_archive(hog_file, hog_voc);
    utils::serialization::read_binary_archive(color_file, color_voc);
    feature_types = static_cast<vision::features::feature_type::T>(
        vision::features::feature_type::Surf +
        vision::features::feature_type::Hog +
        vision::features::feature_type::Color);

  }
   int virtual feature_size() const {
    return 48384;
   }
   void virtual extract_feature(const Annotation& ann, Mat& feature) {
     Mat_<int> spm_histogram;
     Mat img = cv::imread(ann.url, 1);
     CHECK(img.data != NULL);
     Mat ssd_voc;
     vision::features::SpmBowExtractor spm_extractor(
         3,
         surf_voc,
         hog_voc,
         color_voc,
         ssd_voc
     );

     spm_extractor.extractSpm(img, spm_histogram, feature_types );
     for(int i=0; i < spm_histogram.cols; i++) {
       feature.at<float>(0,i) = spm_histogram.at<int>(0,i);
     }
   }
   string virtual get_name() const {
     return "bow_spm";
   }

   bool check(const Annotation& ann) const {
     bool all_parts_present = true;
     for(int j=0; j < ann.parts.size(); j++) {
       if(ann.parts[j].x < 0 || ann.parts[j].y < 0)
         all_parts_present = false;
     }
     return all_parts_present;
   }

private:
   std::string surf_file;
   std::string hog_file;
   std::string color_file;
   vision::features::feature_type::T feature_types;
   cv::Mat surf_voc;
   cv::Mat hog_voc;
   cv::Mat color_voc;
};

class RelativePartOffset : public FeatureExtractor {
public:

  RelativePartOffset(int part_id, int parent_id) :
    _part_id(part_id), _parent_id(parent_id) {
    CHECK_GE(_part_id, 0);
    CHECK_GE(_parent_id, 0);
  }

  int virtual feature_size() const {
    return 2;
  }

  void virtual extract_feature(const Annotation& ann, Mat& feature) {

    CHECK_GT(ann.parts.size(),_part_id);
    CHECK_GT(ann.parts.size(),_parent_id);

    const Point& part = ann.parts[_part_id];
    const Point& parent = ann.parts[_parent_id];
    Point offset_parent = part - parent;

    CHECK(part.x >= 0);
    CHECK(part.y >= 0);
    CHECK(parent.x >= 0);
    CHECK(parent.y >= 0);

    if( abs(offset_parent.x) > 200  || abs(offset_parent.y) > 200 ){
      LOG(INFO) << ann.url;
      LOG(INFO) << offset_parent.x << " " << offset_parent.y;
    }
    feature.at<float>(0,0) = offset_parent.x;
    feature.at<float>(0,1) = offset_parent.y;
  }
  string virtual get_name() const {
    return "part_offset";
  }

  bool check(const Annotation& ann) const {
    const Point& part = ann.parts[_part_id];
    const Point& parent = ann.parts[_parent_id];
    if( part.x < 0 || part.y < 0)
      return false;
    if( parent.x < 0 || parent.y < 0)
      return false;
    return true;
  }

private:
  int _part_id;
  int _parent_id;
};

FeatureExtractor* feature_extractor_factory(ClusterMethod method,
    const std::vector<int>& part_indices,
    body_pose::BodyPoseTypes pose_type) {

  if (method == PART_POSE) {
    // relative part offset
    CHECK_EQ(part_indices.size(), 2);
    int part_id = part_indices[0];
    int parent_id = part_indices[1];
    return new RelativePartOffset(part_id, parent_id);

  }else if(method == GLOBAL_POSE){
    return new GlobalPose(pose_type);

  }else if(method == GIST_APPEARANCE){
    return new GistAppearance();

  }else if(method == BOW_SPM){
    return new BowSPM();

  }else if(method == MULTI_PARTS_POSE ){
    return new MultiPartPose(part_indices, pose_type);

  }else{
    CHECK(false);
  }
  return 0;
}



} /* namespace clustering */
} /* namespace body_pose */
