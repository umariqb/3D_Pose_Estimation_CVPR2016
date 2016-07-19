/*
 * bose_clustering.hpp
 *
 *  Created on: Mar 13, 2013
 *      Author: mdantone
 */

#ifndef BODY_CLUSTERING
#define BODY_CLUSTERING

#include <opencv2/opencv.hpp>
#include "cpp/body_pose/common.hpp"
#include "cpp/utils/string_utils.hpp"
#include "clustering_features.hpp"

namespace body_pose
{
namespace clustering
{

void cluster_annotations (const std::vector<Annotation>& annotations_src,
                  ClusterMethod method,
                  int n_clusters,
                  cv::Mat& centers,
                  body_pose::BodyPoseTypes pose_type,
                  std::vector<int> part_indices = std::vector<int>());

void cluster_annotations (const std::vector<Annotation>& annotations,
                  FeatureExtractor& feat_extractor,
                  int n_clusters,
                  cv::Mat& centers);


void assigne_to_clusters(std::vector<Annotation>& annotations,
    body_pose::clustering::ClusterMethod method,
    std::string cluster_path,  int n_clusters,
    body_pose::BodyPoseTypes pose_type);

void assigne_to_clusters(const std::vector<Annotation>& annotations,
    body_pose::clustering::ClusterMethod method,
    std::string cluster_path,  int n_clusters,
    std::vector<Annotation>& clustered_ann,
    body_pose::BodyPoseTypes pose_type);

void assigne_to_clusters(const std::vector<Annotation>& annotations,
                  std::vector<int> part_indices,
                  const cv::Mat& clusters,
                  ClusterMethod method,
                  std::vector<Annotation>& ann,
                  body_pose::BodyPoseTypes pose_type);

void assign_to_clusters_wrt_action_cats(const std::vector<Annotation>& annotations,
                std::vector<int> part_indices,
                ClusterMethod method,
                std::vector<Annotation>& clustered_ann,
                body_pose::BodyPoseTypes pose_types);

void visualize_part_clusters(const std::vector<Annotation>& annotations_src,
                  ClusterMethod method,
                  std::vector<int> part_indices,
                  cv::Mat& centers,
                  body_pose::BodyPoseTypes pose_type,
                  bool save_visualization = false);

void clean_annotations(const std::vector<Annotation>& annotations, ClusterMethod method,
                  const std::vector<int>& part_indices,
                  std::vector<Annotation>& clean_annotations,
                  body_pose::BodyPoseTypes pose_type);

void get_meadian(const std::vector<Annotation>& annotations,
    std::vector<int> part_indices,
    const cv::Mat& clusters,
    ClusterMethod method,
    std::vector<std::pair<Annotation,float> >& means,
    body_pose::BodyPoseTypes pose_type);

bool load_clusters(const std::string file_name, int n_clusters,
    ClusterMethod cluster_method, std::vector<cv::Mat>& clusters,
    body_pose::BodyPoseTypes pose_type);

bool save_clusters(const std::string file_name, int n_clusters,
    ClusterMethod cluster_method, const std::vector<cv::Mat>& clusters,
    body_pose::BodyPoseTypes pose_type);

bool save_clustrered_annotations(const std::string file_name,
                    const std::string index_file,
                    int n_clusters,
                    ClusterMethod cluster_method,
                    const std::vector<Annotation>& ann,
                    body_pose::BodyPoseTypes pose_type);

bool load_clustrered_annotations(const std::string base_name,
    const std::string index_file, int n_clusters, ClusterMethod cluster_method,
    std::vector<Annotation>& ann);

} /* namespace clustering */
} /* namespace body_pose */
#endif /* BODY_CLUSTERING */
