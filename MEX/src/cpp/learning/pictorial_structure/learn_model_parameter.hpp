/*
 * learn_model_parameter.hpp
 *
 *  Created on: Mar 18, 2013
 *      Author: mdantone
 */

#ifndef LEARN_MODEL_PARAMETER_HPP_
#define LEARN_MODEL_PARAMETER_HPP_

#include <glog/logging.h>
#include "cpp/body_pose/common.hpp"

#include "cpp/body_pose/clustering/body_clustering.hpp"
#include <boost/format.hpp>
#include "cpp/learning/pictorial_structure/part.hpp"
#include "cpp/learning/pictorial_structure/model.hpp"
#include "cpp/learning/pictorial_structure/inferenz.hpp"
#include "cpp/body_pose/body_pose_types.hpp"

namespace learning
{
namespace ps
{

  enum Joint_Type { ROT_GAUSS, CLUSTER_GAUSS };

  struct JointParameter {
    JointParameter() :
      joint_type(ROT_GAUSS),
      num_rotations(24),
      use_weights(true),
      zero_sum_weights(false),
      weight_alpha(1.0),
      min_sampels(25),
      use_ann_weights(false){};

    Joint_Type joint_type;
    int num_rotations;
    bool use_weights;
    bool zero_sum_weights;
    float weight_alpha;
    int min_sampels;
    bool use_ann_weights;

    std::string to_string() const {
      std::string s = "c";
      if(joint_type == ROT_GAUSS)
        s = "r";
      s += boost::str( boost::format("%1%") %num_rotations );


      std::string weight = "";
      if(use_weights) {
        weight  = boost::str(boost::format("_w%1%") % (weight_alpha) );
      }

//      if(zero_sum_weights) {
//        weight += "_zero_sum";
//      }
      return s+weight;
    }
  };

  typedef std::vector<JointParameter> JointParameters;

  void create_body_model(Model* model, body_pose::BodyPoseTypes pose_type);

  void clean(const std::vector<Annotation> annotations_src,
      std::vector<Annotation>& annotations,
      int max_size = 110,
      int norm_size = -1,
      body_pose::BodyPoseTypes pose_type = body_pose::FULL_BODY_J13);

  void clean_temporal(const std::vector<Annotation> annotations_src,
      std::vector<Annotation>& annotations,
      int max_size = 110,
      int norm_size = -1);

  // creating the body model
  // learns the parameter and returns the model
  void get_body_model(std::string index_path,
                      Model& model,
                      JointParameters params = JointParameters(),
                      int norm_size = -1,
                      body_pose::BodyPoseTypes pose_type = body_pose::FULL_BODY_J13);

  bool get_body_model(const std::vector<Annotation>& annotations,
                      Model& model,
                      JointParameters params = JointParameters(),
                      int norm_size = -1,
                      body_pose::BodyPoseTypes pose_type = body_pose::FULL_BODY_J13);

  // creating multiple body model
  // clusters the annotations based on the variable 'cluster'
  // learns the parameter and returns the models
  void get_body_model_mixtures(const std::vector<Annotation>& annotations,
                      std::vector<Model>& models,
                      JointParameters params = JointParameters(),
                      int norm_size = -1,
                      body_pose::BodyPoseTypes pose_type = body_pose::FULL_BODY_J13);

  void get_body_model_mixtures(std::string index_path,
                      body_pose::clustering::ClusterMethod method,
                      int n_clusters, std::string cluster_path,
                      std::vector<Model>& models,
                      std::vector<int> cluster_ids,
                      JointParameters params = JointParameters(),
                      int norm_size = -1,
                      body_pose::BodyPoseTypes pose_type = body_pose::FULL_BODY_J13) ;

  void get_actions_based_body_model(std::string index_path,
                     Model& model,
                     std::vector<JointParameter> params,
                     int norm_size,
                     body_pose::BodyPoseTypes pose_type,
                     std::vector<double> actions_probs,
                     std::vector<int> actionLabelIdx);

} // ps
} // lerning


#endif /* LEARN_MODEL_PARAMETER_HPP_ */
