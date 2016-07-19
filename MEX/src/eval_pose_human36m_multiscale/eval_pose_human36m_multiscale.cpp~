/*
 *
 *  Created on: Oct 7, 2012
 *      Author: mdantone
 *
 *      Modified: Umar Iqbal
 *                Andreas Doering
 */



#include <istream>
#include <cassert>
#include <opencv2/opencv.hpp>
#include <boost/progress.hpp>
#include <boost/assign/std/vector.hpp>
#include <boost/format.hpp>
#include <boost/random.hpp>

#include "cpp/utils/timing.hpp"
#include "cpp/learning/forest/forest.hpp"
#include "cpp/learning/pictorial_structure/learn_model_parameter.hpp"
#include "cpp/learning/pictorial_structure/inferenz.hpp"

#include "cpp/learning/pictorial_structure/utils.hpp"

#include "cpp/body_pose/body_part_sample.hpp"
#include "cpp/body_pose/utils.hpp"
#include "cpp/utils/thread_pool.hpp"
#include "cpp/body_pose/clustering/body_clustering.hpp"
#include "cpp/vision/features/feature_channels/feature_channel_factory.hpp"
#include "cpp/body_pose/body_pose_types.hpp"
#include "cpp/vision/image_utils.hpp"

using namespace boost::assign;
using namespace std;
using namespace cv;
using namespace learning::forest::utils;
using namespace learning::forest;
using namespace learning::ps;

using vision::features::feature_channels::FeatureChannelFactory;

typedef BodyPartSample S;

static const int NUM_THREADS = 12;

int main(int argc, char** argv) {

  string experiment_name;
  string config_file;
  string image_index_path = "image_index_test_rescaled.txt";
  string train_file = "image_index_train_rescaled.txt";
  string save_path = "/tmp/PE_SaveResults/";
  string save_file_name = "estimatedPose_human36m_multiscale_6s.txt";
  
  int n_clusters = 1;
  int nTrees = 30;

  bool do_classification = false;
  bool save = true;

  experiment_name = "regress_01";
  config_file = "../regressors";
  

  LOG(INFO) << argc;
  if(argc > 1)
    experiment_name = argv[1];
  
  if(argc > 2)
    nTrees = boost::lexical_cast<int>(argv[2]);

  if(argc > 3)
      config_file = argv[3];
  
  if(argc > 4)
      image_index_path = argv[4];
  
  if(argc > 5)
      train_file = argv[5];
  
  if(argc > 6)
      save_path = argv[6];
  if(argc > 7)
      save_file_name = argv[7];
  
  string folder = "Human36M/";
  config_file += "/"+folder;
  config_file += "/"+experiment_name;

  ForestParam param;
  vector<Forest<S> >  forests;

  body_pose::BodyPoseTypes pose_type = body_pose::FULL_BODY_J14;
  std::vector<std::string> pair_names;
  pair_names += "head", "neck", "shoulder_l", "shoulder_r", "hip_l", "hip_r", "elbow_l", "hand_l", "elbow_r", "hand_r", "knee_l", "feet_l", "knee_r", "feet_r";

  bool loadBinaryTrees = false;
  load_forests(config_file, forests, loadBinaryTrees, nTrees, 20, pair_names);
  param = forests[0].getParam();
  param.img_index_path = image_index_path;
 
  // loading GT
  LOG(INFO)<<"Loading annotation...";
  vector<string> annotations;
  load_images(annotations, param.img_index_path);

  LOG(INFO) << annotations.size() << " found.";

  JointParameter joint_param;
  joint_param.joint_type = learning::ps::CLUSTER_GAUSS;
  joint_param.num_rotations = 15;
  joint_param.use_weights = true ;
  joint_param.weight_alpha = 0.1;
  joint_param.min_sampels = 20;
  joint_param.zero_sum_weights = true;
  vector<JointParameter> joints_param(static_cast<int>(pose_type), joint_param);

  vector<Model> models;
  body_pose::clustering::ClusterMethod method = body_pose::clustering::GLOBAL_POSE;
  string cluster_path = "";
  
  learning::ps::get_body_model_mixtures(train_file,
      method, n_clusters, cluster_path, models, vector<int>(), joints_param, param.norm_size, pose_type);
  LOG(INFO) <<models.size() << ": model(s) created";

  learning::common::utils::PeakDetectionParams pyramid_param;
  pyramid_param.scale_count = 6;
  pyramid_param.scale_factor = 0.85; 
  double initial_scale = 1;
  int max_side = 1000;

  FeatureChannelFactory fcf = FeatureChannelFactory();

  boost::filesystem::path test_file(param.img_index_path);

  ofstream outFile, outFileSM;
  string f = save_path;
  
  string file_name(boost::str(boost::format("%1%%2%") %f %save_file_name));

  if(save) {
    LOG(INFO) <<  "file_name: " << file_name << endl;
    outFile.open(file_name.c_str(), ios::app);
  }

  vector<int> part_ids;
  boost::progress_display show_progress(annotations.size());

  for (int i = 0; i < annotations.size(); ++i, ++show_progress) {

    // load image
    Mat image = imread(annotations[i],1);
    vector<Mat> pyramid;
    initial_scale = vision::image_utils::build_image_pyramid(image,
    pyramid_param.scale_count,
        pyramid_param.scale_factor, pyramid,
        max_side);

    vector<Image> image_samples;

    create_image_sample_mt(pyramid, param.features, image_samples);

    vector<cv::Point> minimas_rescaled, minimas_norm;

    double best_scale = 0;;
    float min_score = 0;

    double global_min = std::numeric_limits<double>::max();
    double global_max = std::numeric_limits<double>::min();

    vector<vector<cv::Mat_<float> > > voting_maps(pyramid_param.scale_count);
    for(int i_scale =0; i_scale < pyramid_param.scale_count; i_scale++) {
      eval_forests(forests, image_samples[i_scale], voting_maps[i_scale], 2, true);
      for(int j=0; j < voting_maps[i_scale].size(); j++) {
          double min_val, max_val;
          cv::minMaxLoc(voting_maps[i_scale][j], &min_val, &max_val, NULL, NULL);
          global_min = std::min(global_min, min_val);
          global_max = std::max(global_max, max_val);
      }
    }

    for(int i_scale =0; i_scale < pyramid_param.scale_count; i_scale++) {
      for(int j=0; j < voting_maps[i_scale].size(); j++) {
        voting_maps[i_scale][j] = (voting_maps[i_scale][j] - global_min) / (global_max - global_min);
      }
    }

    for(int i_scale =0; i_scale < pyramid_param.scale_count; i_scale++) {

      vector<Point> minimas;
      minimas.resize((int)pose_type, Point(-1,-1));

      float score = learning::ps::inferenz_multiple(models, voting_maps[i_scale], minimas, false, image, 0, NUM_THREADS);

      if(score < min_score) {

        min_score = score;

        double scale = initial_scale*pow(pyramid_param.scale_factor, i_scale);
        best_scale = scale;

        minimas_rescaled = minimas;
        minimas_norm = minimas;

        for(int j=0; j < minimas_rescaled.size(); j++) {
          minimas_rescaled[j].x /= scale;
          minimas_rescaled[j].y /= scale;
        }
      }
    }

    if(save){
      outFile << annotations[i] <<" 0 0 0 0 0"<<" "<< (int)pose_type << " ";
      assert( minimas_rescaled.size() == (int)pose_type );
      for( int j=0; j < minimas_rescaled.size(); j++){
        Point rescaled = minimas_rescaled[j];
        outFile << rescaled.x  << " " << rescaled.y << " ";
      }
      outFile <<"-bs "<<best_scale<< "\n";
      outFile.flush();
     
    } else {
      plot(image, minimas_rescaled, pose_type);
      LOG(INFO) << "minimas_rescaled: " << ::utils::VectorToString(minimas_rescaled);
    }
  }

  LOG(INFO) << "DONE";

  return 0;
}
