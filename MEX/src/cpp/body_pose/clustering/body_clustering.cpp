/*
 * body_clustering.cpp
 *
 *  Created on: Mar 13, 2013
 *      Author: mdantone
 */

#include <fstream>
#include <opencv2/opencv.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/filesystem/path.hpp>
#include <boost/format.hpp>
#include <boost/serialization/vector.hpp>
#include <boost/serialization/utility.hpp>
#include <boost/iostreams/device/file.hpp>
#include <boost/iostreams/stream.hpp>
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>
#include "cpp/utils/serialization/opencv_serialization.hpp"
#include "cpp/utils/serialization/serialization.hpp"
#include "cpp/third_party/json_spirit/json_spirit.h"
#include "body_clustering.hpp"

using namespace std;
using namespace cv;

namespace body_pose
{
namespace clustering
{


void visualize_part_clusters(const vector<Annotation>& annotations_src,
    ClusterMethod method,
    std::vector<int> part_indices,
    cv::Mat& centers,
    body_pose::BodyPoseTypes pose_type,
    bool save_visualization) {

  if (method == PART_POSE) {
    vector<Annotation> annotations;

    assigne_to_clusters(annotations_src, part_indices, centers,
        method, annotations, pose_type);

    int size = 500;
    cv::Mat img(size,size,CV_8UC3, cv::Scalar(255,255,255));
    vector<Scalar> colors;
    colors.push_back( Scalar(255, 0, 0));
    colors.push_back( Scalar(255, 255, 0));
    colors.push_back( Scalar(255, 0, 255));
    colors.push_back( Scalar(100, 100, 0));
    colors.push_back( Scalar(255, 100, 100));

    int part_id = part_indices[0];
    int parent_id = part_indices[1];

    LOG(INFO) << "part_id " << part_id;
    for(int i=0; i < annotations.size(); i++) {
      const Point& part = annotations[i].parts[part_id];
      const Point& parent = annotations[i].parts[parent_id];
      Point offset_parent = part - parent;

      circle(img, Point_<int>(offset_parent.x+size/2, offset_parent.y+size/2),
          1, colors[annotations[i].cluster_id],-1);
    }

    imshow("x", img);
    if(save_visualization) {
      imwrite("/home/mdantone/public_html/share/lookbook/clusters/global_pose/", img);
    }
    waitKey(0);
  } else{

    std::vector<pair<Annotation,float> > meadian;
    get_meadian( annotations_src, part_indices, centers, method, meadian, pose_type);

    int size = 1000;
    cv::Mat img(size,size,CV_8UC3, cv::Scalar(255,255,255));
    for(int i=0; i < meadian.size(); i++) {

      if(meadian[i].second < 0 or meadian[i].second > 10000 )
        continue;
      LOG(INFO) << meadian[i].second ;
      LOG(INFO) << meadian[i].first.url ;

      int s = size/5;
      int x = s*(i%5);
      int y = (s*1.5)*(i/5);
      Mat img_roi = img( Rect( x, y, s, s*1.5));
      plot(img_roi, meadian[i].first.parts,pose_type, "", 1 );

      Point head = meadian[i].first.parts[0];
      for(int j=0; j < static_cast<int>(pose_type)*2; j+=2) {
        x = centers.at<float>(i, j*2)  + head.x;
        y = centers.at<float>(i, j*2+1) + head.y;
        circle(img_roi, Point_<int>(x, y), 3, Scalar(150, 150, 150, 0), -1 );
      }
    }

    imshow("x", img);
    if(save_visualization) {
      int n_clusters = centers.rows;
      string f_name(boost::str(boost::format("/home/mdantone/public_html/share/leed/clusters/global_pose/cluster_fashion_%1%.jpg" ) % n_clusters));
      imwrite(f_name, img);
    }
    waitKey(0);
  }
}

void clean_annotations(const vector<Annotation>& annotations, ClusterMethod method,
    const std::vector<int>& part_indices, vector<Annotation>& clean_annotations,
        BodyPoseTypes pose_type) {

  FeatureExtractor* ext = feature_extractor_factory(method, part_indices, pose_type);
  //copy all annotations
  for(int i=0; i < annotations.size(); i++) {
    const Annotation& ann = annotations[i];
    bool all_parts_present = true;
    for(int j=0; j < ann.parts.size(); j++) {
      if( ann.parts[j].x < 0 || ann.parts[j].y < 0 ) {
        all_parts_present = false;
      }
    }

    if(all_parts_present && ext->check(ann )) {
      clean_annotations.push_back(ann);
    }
  }
  delete ext;

}


//void relative_part_offset( const Annotation& ann,
//    int part_id, int parent_id, Mat& feature ) {
//  CHECK(part_id >= 0);
//  CHECK(parent_id >= 0);
//
//  const Point& part = ann.parts[part_id];
//  const Point& parent = ann.parts[parent_id];
//  Point offset_parent = part - parent;
//
//  CHECK(part.x >= 0);
//  CHECK(part.y >= 0);
//  CHECK(parent.x >= 0);
//  CHECK(parent.y >= 0);
//
//  if( abs(offset_parent.x) > 200  || abs(offset_parent.y) > 200 ){
//    LOG(INFO) << ann.url;
//    LOG(INFO) << offset_parent.x << " " << offset_parent.y;
//  }
//  feature.at<float>(0,0) = offset_parent.x;
//  feature.at<float>(0,1) = offset_parent.y;
//}


void cluster_annotations (const std::vector<Annotation>& annotations_src,
                          ClusterMethod method,
                          int n_clusters,
                          cv::Mat& centers,
                          body_pose::BodyPoseTypes pose_type,
                          std::vector<int> part_indices) {

  CHECK_GT(n_clusters, 1);
  LOG(INFO) << "num clusters " << n_clusters;
  LOG(INFO) << annotations_src.size() << " annotations.";


  FeatureExtractor* ext = feature_extractor_factory(method, part_indices, pose_type);
  //copy all annotations
  std::vector<Annotation> annotations;
  clean_annotations(annotations_src, method, part_indices, annotations, pose_type);

  LOG(INFO) << annotations.size() << " cleaned annotations.";
  cluster_annotations(annotations, *ext, n_clusters, centers);
  delete ext;

}

void cluster_annotations (const vector<Annotation>& annotations,
                  FeatureExtractor& feat_extractor,
                  int n_clusters,
                  Mat& centers) {

  // create features
  LOG(INFO) << "start feature extraction";

  cv::Mat features = cv::Mat(cv::Size(feat_extractor.feature_size(),annotations.size()),CV_32FC1, Scalar(-1));
  for(int i=0; i < annotations.size(); i++) {
    cv::Mat row = features.row(i);
    feat_extractor.extract_feature(annotations[i], row);
  }


  LOG(INFO) << "Feature extracted";
  cv::TermCriteria term_criteria;
  term_criteria.epsilon = 1;
  term_criteria.maxCount = 20;
  term_criteria.type = cv::TermCriteria::MAX_ITER | cv::TermCriteria::EPS;
  cv::Mat labels;
  cv::kmeans(features, n_clusters, labels, term_criteria, 20, cv::KMEANS_PP_CENTERS, centers);
  std::vector<int> label_hist(n_clusters,0);
  for(int i=0; i < annotations.size(); i++) {
    int p = labels.at<int>(0,i);
    label_hist[p]++;
//
//    if(n_clusters == 7 and p == 4) {
//      Mat img = Mat(500,500, CV_8UC3, Scalar(0));
//      LOG(INFO) << annotations[i].url;
//      LOG(INFO) << utils::VectorToString(annotations[i].parts);
//
//      plot(img, annotations[i].parts);
//    }
  }
  LOG(INFO) << "n_clusters " << n_clusters;
  LOG(INFO) << "centers " << centers;
  LOG(INFO) << "label hist " << utils::VectorToString(label_hist);

}


void create_feature_Matrix(const std::vector<Annotation>& annotations,
    std::vector<int> part_indices,
    ClusterMethod method, cv::Mat& features,
    body_pose::BodyPoseTypes pose_type){
  FeatureExtractor* ext = feature_extractor_factory(method, part_indices, pose_type);

  features = Mat( annotations.size(), ext->feature_size(), CV_32FC1);
  features.setTo(0.0);
  for(int i=0; i < annotations.size(); i++) {
    cv::Mat row = features.row(i);
    ext->extract_feature(annotations[i], row);
  }
  delete ext;
}

void get_meadian(const std::vector<Annotation>& annotations,
    std::vector<int> part_indices,
    const cv::Mat& clusters,
    ClusterMethod method,
    std::vector<pair<Annotation,float> >& meadian,
    body_pose::BodyPoseTypes pose_type) {

  Mat features;
  create_feature_Matrix(annotations, part_indices, method, features, pose_type);

  CHECK_EQ(features.cols, clusters.cols);
  flann::SearchParams p;
  p.setAlgorithm(cvflann::FLANN_INDEX_LINEAR);

  flann::Index index(clusters, p);
  Mat_<int> indices;
  Mat dists;
  index.knnSearch(features, indices, dists, 1, p);

  int n_clusters = clusters.rows;
  for(int i=0; i < n_clusters; i++) {
    Annotation ann;
    float max_dist = boost::numeric::bounds<float>::highest();
    meadian.push_back( make_pair(ann, max_dist));
  }

  vector<int> hist(clusters.rows,0);
  for(int i=0; i < annotations.size(); i++) {
    int cluster_id = indices(i,0);
    float dist = dists.at<float>(i,0);
    hist[cluster_id] ++;
    if( meadian[cluster_id].second > dist){
      meadian[cluster_id].second = dist;
      meadian[cluster_id].first = annotations[i];
    }
  }
  LOG(INFO) << "hist " << utils::VectorToString(hist);
}



void assigne_to_clusters(std::vector<Annotation>& annotations,
    body_pose::clustering::ClusterMethod method,
    std::string cluster_path,  int n_clusters,
    body_pose::BodyPoseTypes pose_type) {

  std::vector<Annotation> annotations_clustered;

  assigne_to_clusters(annotations, method, cluster_path, n_clusters, annotations_clustered, pose_type);
  annotations.clear();
  annotations = annotations_clustered;
}

void assigne_to_clusters(const vector<Annotation>& annotations,
    body_pose::clustering::ClusterMethod method,
    string cluster_path,  int n_clusters,
    vector<Annotation>& clustered_ann,
    body_pose::BodyPoseTypes pose_type) {

  if(n_clusters > 1) {
    vector<Mat> clusters;
    CHECK(body_pose::clustering::load_clusters(cluster_path, n_clusters, method, clusters, pose_type) );

    std::vector<int> part_indices;
    body_pose::clustering::assigne_to_clusters(annotations,
        part_indices, clusters[0], method, clustered_ann, pose_type);

    CHECK_EQ(clustered_ann.size(), annotations.size());

  }else{
    clustered_ann = annotations;
    for (int i = 0; i < clustered_ann.size(); ++i) {
      clustered_ann[i].cluster_id = 0;
    }
  }
}


void assigne_to_clusters(const std::vector<Annotation>& annotations,
    std::vector<int> part_indices,
    const cv::Mat& clusters,
    ClusterMethod method, vector<Annotation>& ann,
    body_pose::BodyPoseTypes pose_type) {

  clean_annotations(annotations, method, part_indices, ann, pose_type);
  CHECK(ann.size() > 0 );

  Mat features;
  create_feature_Matrix(ann, part_indices, method, features, pose_type);

  CHECK_EQ(features.cols, clusters.cols);
  flann::SearchParams p;
  p.setAlgorithm(cvflann::FLANN_INDEX_LINEAR);

  flann::Index index(clusters, p);
  Mat_<int> indices;
  Mat dists;

  index.knnSearch(features, indices, dists, 1, p);

  vector<int> hist(clusters.rows,0);
  for(int i=0; i < ann.size(); i++) {
    ann[i].cluster_id = indices(i,0);
    hist[ann[i].cluster_id] ++;
  }
  LOG(INFO) << "hist " << utils::VectorToString(hist);

}


// adujusts the action labels in a sequential manner
// e.g. {3, 4, 7, 8} will be replaced by {0,1,2,3}
void assign_to_clusters_wrt_action_cats(const std::vector<Annotation>& annotations,
                std::vector<int> part_indices,
                ClusterMethod method,
                std::vector<Annotation>& clustered_ann,
                body_pose::BodyPoseTypes pose_type){


  clean_annotations(annotations, method, part_indices, clustered_ann, pose_type);
  CHECK(clustered_ann.size() > 0);

  int cat_index = 0;

  std::vector<int> action_cat_idx;
  std::vector<int> old_cat_ids, new_cat_ids;

  LOG(INFO)<<"Using action categories for mixture model.";
  LOG(INFO)<<"Ajusting category label";

  for(unsigned int i = 0; i < clustered_ann.size(); i++){
    if(clustered_ann[i].cluster_id >= action_cat_idx.size()){
      action_cat_idx.resize(clustered_ann[i].cluster_id+1,-1);
      action_cat_idx[clustered_ann[i].cluster_id] = cat_index;
      old_cat_ids.push_back(clustered_ann[i].cluster_id);
      clustered_ann[i].cluster_id = cat_index;
      new_cat_ids.push_back(cat_index);
      cat_index++;
    }
    else{
      clustered_ann[i].cluster_id = action_cat_idx[clustered_ann[i].cluster_id];
    }
  }

  LOG(INFO)<<"Old cat labels = "<< utils::VectorToString(old_cat_ids) <<
          "New cat labels = "<< utils::VectorToString(new_cat_ids);

}

bool load_clusters(const std::string file_name,
    int n_clusters, ClusterMethod cluster_method,
    std::vector<cv::Mat>& clusters,
    body_pose::BodyPoseTypes pose_type) {

  vector<int> part_indices;
  FeatureExtractor* ext = feature_extractor_factory(cluster_method, part_indices, pose_type);
  string cluster_method_str = ext->get_name();
  delete ext;

  string f_name(boost::str(boost::format("%1%/clusters_%2%_%3%.txt")
  %file_name % n_clusters % cluster_method_str));
  std::ifstream ifs(f_name.c_str());
  if (!ifs) {
    LOG(INFO) << "file not found:" << f_name;
  } else {
    try {
      boost::archive::text_iarchive ia(ifs);
      ia >> clusters;
      LOG(INFO) << "cluster loaded " << f_name;

      return true;
    } catch (boost::archive::archive_exception& ex) {
      LOG(INFO) << "Reload Tree: Archive Exception during deserializing: "
                << ex.what() << std::endl;
      LOG(INFO) << "not able to load  " << f_name << std::endl;
    }
  }
  return false;
}


bool save_clusters(const std::string file_name,
    int n_clusters, ClusterMethod cluster_method,
    const std::vector<cv::Mat>& clusters,
    body_pose::BodyPoseTypes pose_type){

  vector<int> part_indices;
  FeatureExtractor* ext = feature_extractor_factory(cluster_method, part_indices, pose_type);
  string cluster_method_str = ext->get_name();
  delete ext;
  string f_name(boost::str(boost::format("%1%/clusters_%2%_%3%.txt")
  %file_name % n_clusters % cluster_method_str));

  try {
     std::ofstream ofs(f_name.c_str());
     CHECK(ofs);
     boost::archive::text_oarchive oa(ofs);
     oa << clusters;
     ofs.flush();
     ofs.close();
     LOG(INFO) << "saved " << f_name << std::endl;
     return true;
   } catch (boost::archive::archive_exception& ex) {
     LOG(INFO) << "Archive Exception during serializing:" << std::endl;
     LOG(INFO) << ex.what() << std::endl;
     LOG(INFO) << "it was file: " << f_name << std::endl;
   }
   return true;
}

string get_annotation_file_name(const std::string base_name,
    const std::string index_file, int n_clusters, ClusterMethod cluster_method,
    body_pose::BodyPoseTypes pose_type) {

  vector<int> tmp;
  FeatureExtractor* ext = feature_extractor_factory(cluster_method,tmp, pose_type);
  string cluster_method_str = ext->get_name();
  delete ext;

  boost::filesystem::path path(index_file);

  string f_name(boost::str(boost::format("%1%/annotations_%2%_%3%_%4%.ann")
  %base_name % n_clusters % cluster_method_str %  path.stem().string()));
  LOG(INFO) << f_name;
  return f_name;
}

bool save_clustrered_annotations(const std::string base_name,
    const std::string index_file, int n_clusters, ClusterMethod cluster_method,
    const vector<Annotation>& ann,
    body_pose::BodyPoseTypes pose_type) {

  string f_name =  get_annotation_file_name(base_name, index_file,
      n_clusters, cluster_method, pose_type);

  LOG(INFO) << ann.size() << " annotations saved";
  return utils::serialization::write_binary_archive(f_name, ann);
}

bool load_clustrered_annotations(const std::string base_name,
    const std::string index_file, int n_clusters, ClusterMethod cluster_method,
    vector<Annotation>& ann,
    body_pose::BodyPoseTypes pose_type) {
  string f_name =  get_annotation_file_name(base_name, index_file,
      n_clusters, cluster_method, pose_type);
  return utils::serialization::read_binary_archive(f_name, ann);

}

} /* namespace clustering */
} /* namespace body_pose */
