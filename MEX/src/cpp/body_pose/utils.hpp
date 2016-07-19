/*
 * utils.hpp
 *
 *  Created on: Jan 19, 2012
 *      Author: Matthias Dantone
 */

#ifndef BODY_PART_UTILS_HPP_
#define BODY_PART_UTILS_HPP_

#include <boost/assign/std/vector.hpp>
#include <opencv2/opencv.hpp>
#include <boost/filesystem/path.hpp>
#include "cpp/learning/forest/forest.hpp"
#include "cpp/learning/pictorial_structure/model.hpp"
#include "cpp/learning/pictorial_structure/utils.hpp"
#include "cpp/body_pose/body_part_sample.hpp"
#include "cpp/body_pose/common.hpp"
#include "cpp/learning/common/eval_utils.hpp"
#include "cpp/body_pose/body_pose_types.hpp"



void clean_annotations(const std::vector< Annotation>& annotations_org,
    std::vector< Annotation >& annotations);

void cluster_annotations(std::vector<Annotation>& anns, int num_clusters, std::vector<int> parents, int part_id = -1 );


void non_max_suspression(const cv::Mat& vote_map, int num_maximas,
    int non_max_suspression, std::vector<cv::Point>& maximas);



void flip_image(cv::Mat& img, Annotation& ann );


void get_mask(int part_id, const cv::Mat& img, const Annotation ann, cv::Mat_<uchar>& mask, body_pose::BodyPoseTypes pose_type, bool debug = false );

void get_mask(const cv::Mat& img, const Annotation& ann, cv::Mat_<uchar>& mask, body_pose::BodyPoseTypes pose_type, int size = 10, bool debug = false);
void get_mask(const cv::Mat& img, const std::vector<cv::Point>& parts, cv::Mat_<uchar>& mask, body_pose::BodyPoseTypes pose_type, int size = 10, bool debug = false);


void rescale_img(const cv::Mat& src, cv::Mat& dest, float scale,
    Annotation& ann);

void rescale_ann(Annotation& ann, float scale);

void extract_roi( const cv::Mat& img, Annotation& ann, cv::Mat& img_roi , int offset_x, int offset_y, cv::Rect* extracted_region= 0);
void extract_roi( const cv::Mat& img, Annotation& ann, cv::Mat& img_roi, cv::Rect* extracted_region, float ratio = 0.5);

void extract_roi(std::vector<cv::Mat>& images,
                  std::vector<cv::Mat>& roi_images,
                   std::vector<cv::Rect>& bboxes,
                    cv::Rect& best_bbox, float ratio = 0.5);



void rotate_image(const cv::Mat& src,  const Annotation& ann,
    cv::Point center, double angle,
    cv::Mat& dst, Annotation& rotated_ann);

//void plot_votes(const cv::Mat& img,
//    std::vector<std::vector<vision::mean_shift::Vote> >& votes, std::vector<cv::Point> results,
//    std::vector<cv::Point> gt,
//    int i_image=-1,
//    int norm_factor = 100,
//    std::string file_name = "");
//
//bool crop_image_using_mask(cv::Mat& img, cv::Mat& mask, Annotation& ann, int offset );

void get_multiple_forground_map(const learning::common::Image& sample,
    const std::vector<learning::forest::Forest<BodyPartSample> >& forest,
    std::vector<cv::Mat_<float> >& foreground_maps,
    const cv::Rect roi,
    int step_size = 1,
    bool blur = true, int num_threads = 0);

void create_image_sample_mt(const std::vector<cv::Mat>& images,
    std::vector<int>& features,
    std::vector<learning::common::Image>& samples,
    bool use_integral = false, int num_threads = 0, int global_attr_label = -1);


void create_virtual_samples(std::vector<Annotation>& annotations,
    std::vector<cv::Mat>& samples,
    int num_virtal_sample_per_sample,
    boost::mt19937* rng,
    int anker_part_id = -1);

void eval_forests(const std::vector<learning::forest::Forest<BodyPartSample> >& forests,
      const learning::common::Image& sample,
      std::vector<cv::Mat_<float> >& voting_maps,
      int stepsize = 1, bool regression = false,
      int num_threads = 0,
      bool cond_regression = false,
      std::vector<std::vector<double> > cond_reg_weights = std::vector<std::vector<double> >(), bool blur = true);

void eval_attr_wise_forests(const std::vector<learning::forest::Forest<BodyPartSample> >& forests,
      const learning::common::Image& sample,
      std::vector<std::vector<cv::Mat_<float> > >& voting_maps,
      int stepsize,
      bool regression,
      int num_threads,
      int num_global_attr,
      bool blur = false);

bool load_data(std::string index_file,
    std::vector<cv::Mat>& images,
    std::vector<Annotation>& annotations,
    body_pose::BodyPoseTypes pose_type,
    int num_images,
    int part_id = -1,
    int n_clusters = -1,
    std::vector<int> clusterIds = std::vector<int>(),
    bool use_flipped_annotations = false);

template <typename T>
bool load_forests(std::string base_url,
    std::vector<learning::forest::Forest<T> >& forests,
    bool loadBinary,
    int max_trees = -1,
    int max_depth = 20,
    std::vector<std::string> pair_names=std::vector<std::string>(),
    int cond_class = -1){

  std::vector<std::string> config_files;
  {
    using namespace boost::assign;
    //pair_names += "head", "shoulder_r", "shoulder_l", "hip_r", "hip_l","elbow_r","hand_r","elbow_l","hand_l","knee_r","feet_r","knee_l","feet_l";
    if(pair_names.size() < 1){
      pair_names += "head", "shoulder_l", "shoulder_r", "hip_l", "hip_r", "elbow_l", "hand_l", "elbow_r", "hand_r", "knee_l", "feet_l", "knee_r", "feet_r";
    }
  }

  for(int i =0; i < pair_names.size(); i++) {
    std::string f_name;
    if(cond_class < 0){
      f_name = base_url+"/"+pair_names[i]+"/config.txt";
    }
    else{
      f_name = base_url+"/"+pair_names[i]+"/class_"+boost::lexical_cast<std::string>(cond_class)+"/config.txt";
    }
    config_files.push_back(f_name);
  }

  for(int i=0; i < config_files.size(); i++) {
    learning::forest::ForestParam param_part;
    learning::forest::Forest<T> forest;
    CHECK(learning::forest::loadConfigFile(config_files[i], param_part));
    forest.load(param_part.tree_path, param_part, loadBinary, max_trees);

    if(param_part.max_depth > max_depth) {
      forest.prune_trees(max_depth);
    }

    forests.push_back(forest);
  }
  return forests.size() == pair_names.size();
}


template <typename T>
void inline get_multiple_forground_map_mt(const learning::common::Image& sample,
    const std::vector<learning::forest::Forest<T> >& forests,
    std::vector<cv::Mat_<float> >& foreground_maps,
    const cv::Rect roi,
    int step_size = 1,
    bool blur = true) {

  int num_threads = 1; //utils::system::get_available_logical_cpus();
  if(num_threads > 1 ) {
    boost::thread_pool::executor e(num_threads);
    foreground_maps.resize(forests.size());
    for(unsigned int i = 0; i < forests.size(); i++) {
      cv::Rect s_win(0,0,0,0);
//      e.submit(boost::bind(&learning::forest::utils::get_forground_map,
//          boost::ref(sample),
//          boost::ref(forests[i]),
//          boost::ref(foreground_maps[i]),
//          roi, step_size, blur, s_win));
    }
    e.join_all();
  }else{
    for(unsigned int i = 0; i < forests.size(); i++) {
      learning::forest::utils::get_forground_map(sample,
          forests[i],
          foreground_maps[i],
          roi,
          step_size,
          blur);
    }
  }
}

bool part_and_parent_is_valid(const Annotation& ann, int part_id, int parent_id, body_pose::BodyPoseTypes pose_type);

bool create_confs_and_dirs(std::string& base_url, std::string& exp_name,
                         std::vector<std::string>& pair_names,
                          learning::forest::ForestParam& param,
                          std::vector<std::string>& config_files,
                          bool generateNameOnly);

bool adjust_maps_with_optical_flow(std::vector<learning::common::Image>& samples,
                                    std::vector<std::vector<cv::Mat_<float> > >& voting_maps,
                                     std::vector<cv::Mat_<float> >& adjusted_voting_maps);

void drawOptFlowMap(const cv::Mat& flow, cv::Mat& cflowmap, int step,
                    double, const cv::Scalar& color);

void flip_parts(Annotation& ann, body_pose::BodyPoseTypes pose_type);

void keep_ann_of_cluster_ids(std::vector<Annotation>& org_annotations, std::vector<Annotation>& annotations,
                                  std::vector<int>& cluster_ids, bool add_flipped_ann = false);

int inline get_upperbody_size_piw(const std::vector<cv::Point> parts);

int visualize_normalized_annotations(std::vector<Annotation>& annotations,
                                     body_pose::BodyPoseTypes pose_type);
int visualize_normalized_annotations(std::string path,
                                body_pose::BodyPoseTypes pose_type);

void getAnnotationsWithClusterId(std::vector<Annotation>& org_annotations, std::vector<Annotation>& annotations,
                                std::vector<int>& clusterIds,
                                body_pose::BodyPoseTypes pose_type,
                                 bool add_flipped_annotations);


#endif /* BODY_PART_UTILS_HPP_ */
