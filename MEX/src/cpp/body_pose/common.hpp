/*
 * common.hpp
 *
 *  Created on: Aug 26, 2013
 *      Author: mdantone
 */

#ifndef COMMON_HPP_
#define COMMON_HPP_

#include <opencv2/opencv.hpp>
#include "cpp/utils/serialization/opencv_serialization.hpp"
#include <fstream>
#include <boost/lexical_cast.hpp>
#include <boost/iostreams/device/file.hpp>
#include <boost/iostreams/stream.hpp>
#include <boost/filesystem.hpp>
#include <boost/filesystem/convenience.hpp>
#include <boost/algorithm/string.hpp>
#include "cpp/body_pose/body_pose_types.hpp"
#include <boost/assign/std/vector.hpp>

using namespace boost::assign;

static const int NUM_ENTRIES = 26 + 4 + 1 + 1 + 1; //parts_coords +  bbox + cluster_id + num_parts + img_url

struct Annotation {
    Annotation() : flipped(false),
                   cluster_id(0),
                   center(),
                   nNeighbours(0),
                   neig_urls(),
                   weight(1),
                   best_scale(1),
                   neig_bboxs()
                   {};

    // number of parts
    std::vector<cv::Point> parts;

    // url to original image
    std::string url;

    // bounding box
    cv::Rect bbox;

    bool flipped;

    // cluster_id
    int cluster_id;

    cv::Point_<int> center;

    // number of neighbours from both sides
    int nNeighbours;

    // url to neighbours
    std::vector<std::string> neig_urls;

    // weight of the annotation
    double weight;

    // best scale for the annotation.
    double best_scale;

    // bounding boxes for the neigbours
    std::vector<cv::Rect> neig_bboxs; //left neighbours

    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version) {
      ar & parts;
      ar & url;
      ar & bbox;
      ar & flipped;
      ar & cluster_id;
    }
};

struct SequenceInfo{
  SequenceInfo():path(), frame_count(0) {};
  SequenceInfo(std::string _path, int _frame_count):path(_path), frame_count(_frame_count){};

  std::string path;
  int frame_count;
};

struct Join{
  Join(int a, int b, cv::Scalar color_ ) :part_a(a), part_b(b), color(color_){};
  int part_a;
  int part_b;
  cv::Scalar color;
};

void inline _plot(cv::Mat& img, std::vector<cv::Point> ann, std::string path = "", int wait = 0 ){
    cv::Mat plot;

    if( path != "") {
      plot = img;
    }else{
      plot = img;
    }

    std::vector<Join> joints;

    joints.push_back( Join(0,2,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(1,0,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(2,4,cv::Scalar(0,255, 255)) );
    joints.push_back( Join(1,3,cv::Scalar(0,255, 255)) );

    joints.push_back( Join(1,5,cv::Scalar(255, 255, 0)) );
    joints.push_back( Join(5,6,cv::Scalar(255, 255, 0)) );

    joints.push_back( Join(2,7,cv::Scalar(255, 0, 255)) );
    joints.push_back( Join(7,8,cv::Scalar(255, 0, 255)) );

    joints.push_back( Join(4,11,cv::Scalar(255, 0, 0)) );
    joints.push_back( Join(11,12,cv::Scalar(255, 0, 0)) );

    joints.push_back( Join(3,9,cv::Scalar(0, 0, 255)) );
    joints.push_back( Join(9,10,cv::Scalar(0, 0, 255)) );


    for(int i=0; i < ann.size()-1; i++) {
      cv::Point a = ann[joints[i].part_a];
      cv::Point b = ann[joints[i].part_b];
      if(a.x >0 && b.x > 0 && a.y >0 && b.y > 0 && a.x < plot.cols && b.x < plot.cols ) {
        cv::line(plot, a, b, joints[i].color, 3);
      }
    }
    for (int i = 0; i < static_cast<int> (ann.size()); i++) {
      int x = ann[i].x;
      int y = ann[i].y;
      if (x > 0 and x < plot.cols and y > 0 and y < plot.rows) {
        if(i < 13){
          cv::circle(plot, cv::Point_<int>(x, y), 5, cv::Scalar(0, 0, 0, 0), -1 );
        }
        else if(i < 26){
          cv::circle(plot, cv::Point_<int>(x, y), 3, cv::Scalar(255, 0, 0, 0), -1 );
        }
        else{
          cv::circle(plot, cv::Point_<int>(x, y), 3, cv::Scalar(0, 0, 255, 0), -1 );
        }
      }
  //    rectangle(plot, ann.bbox, Scalar(0, 0, 255), 3);
    }

    if(path == "") {
      cv::imshow("Face", plot);
      cv::waitKey(wait);
    }else{
      cv::imwrite(path,plot);
    }
}

void inline _plot_7(cv::Mat& img, std::vector<cv::Point> ann, std::string path = "", int wait = 0 ){
    cv::Mat plot;

    if( path != "") {
      plot = img;
    }else{
      plot = img;
    }

    std::vector<Join> joints;

    joints.push_back( Join(1,0,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(0,2,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(1,3,cv::Scalar(0,255, 255)) );
    joints.push_back( Join(3,4,cv::Scalar(128,255, 128)) );

    joints.push_back( Join(2,5,cv::Scalar(255, 255, 0)) );
    joints.push_back( Join(5,6,cv::Scalar(255, 0, 255)) );

    for(int i=0; i < ann.size()-1; i++) {
      cv::Point a = ann[joints[i].part_a];
      cv::Point b = ann[joints[i].part_b];
      if(a.x >0 && b.x > 0 && a.y >0 && b.y > 0 && a.x < plot.cols && b.x < plot.cols ) {
        cv::line(plot, a, b, joints[i].color, 1);
      }
    }

    for (int i = 0; i < static_cast<int> (ann.size()); i++) {
      int x = ann[i].x;
      int y = ann[i].y;
      cv::circle(plot, cv::Point_<int>(x, y), 0.5, cv::Scalar(0, 0, 0, 0), -1 );
 //    rectangle(plot, ann.bbox, Scalar(0, 0, 255), 3);
    }

    if(path == "") {
      cv::imshow("Face", plot);
      cv::waitKey(wait);
    }else{
      cv::imwrite(path,plot);
    }
}

void inline _plot_9(cv::Mat& img, std::vector<cv::Point> ann, std::string path = "", int wait = 0 ){
    cv::Mat plot;

    if( path != "") {
      plot = img;
    }else{
      plot = img;
    }

    std::vector<Join> joints;

    joints.push_back( Join(1,0,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(0,2,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(1,3,cv::Scalar(0,255, 255)) );
    joints.push_back( Join(3,4,cv::Scalar(128,255, 128)) );
    joints.push_back( Join(4,5,cv::Scalar(128,255, 128)) );

    joints.push_back( Join(2,6,cv::Scalar(255, 255, 0)) );
    joints.push_back( Join(6,7,cv::Scalar(255, 0, 255)) );
    joints.push_back( Join(7,8,cv::Scalar(255, 0, 255)) );

    for(int i=0; i < ann.size()-1; i++) {
      cv::Point a = ann[joints[i].part_a];
      cv::Point b = ann[joints[i].part_b];
      if(a.x >0 && b.x > 0 && a.y >0 && b.y > 0 && a.x < plot.cols && b.x < plot.cols ) {
        cv::line(plot, a, b, joints[i].color, 1);
      }
    }

    for (int i = 0; i < static_cast<int> (ann.size()); i++) {
      int x = ann[i].x;
      int y = ann[i].y;
      cv::circle(plot, cv::Point_<int>(x, y), 0.5, cv::Scalar(0, 0, 0, 0), -1 );
 //    rectangle(plot, ann.bbox, Scalar(0, 0, 255), 3);
    }

    if(path == "") {
      cv::imshow("Face", plot);
      cv::waitKey(wait);
    }else{
      cv::imwrite(path,plot);
    }
}

void inline _plot_14(cv::Mat& img, std::vector<cv::Point> ann, std::string path = "", int wait = 0 ){
    cv::Mat plot;

    if( path != "") {
      plot = img;
    }else{
      //plot = img.clone();
      plot = img;
    }

    std::vector<Join> joints;

    joints.push_back( Join(1,0,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(1,3,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(2,1,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(3,5,cv::Scalar(0,255, 255)) );
    joints.push_back( Join(2,4,cv::Scalar(0,255, 255)) );

    joints.push_back( Join(2,6,cv::Scalar(255, 255, 0)) );
    joints.push_back( Join(6,7,cv::Scalar(255, 255, 0)) );

    joints.push_back( Join(3,8,cv::Scalar(255, 0, 255)) );
    joints.push_back( Join(8,9,cv::Scalar(255, 0, 255)) );

    joints.push_back( Join(5,12,cv::Scalar(255, 0, 0)) );
    joints.push_back( Join(12,13,cv::Scalar(255, 0, 0)) );

    joints.push_back( Join(4,10,cv::Scalar(0, 0, 255)) );
    joints.push_back( Join(10,11,cv::Scalar(0, 0, 255)) );


    for(int i=0; i < ann.size()-1; i++) {
      cv::Point a = ann[joints[i].part_a];
      cv::Point b = ann[joints[i].part_b];
      if(a.x >0 && b.x > 0 && a.y >0 && b.y > 0 && a.x < plot.cols && b.x < plot.cols ) {
        cv::line(plot, a, b, joints[i].color, 3);
      }
    }
    for (int i = 0; i < static_cast<int> (ann.size()); i++) {
      int x = ann[i].x;
      int y = ann[i].y;
      if (x > 0 and x < plot.cols and y > 0 and y < plot.rows) {
        if(i < 14){
          cv::circle(plot, cv::Point_<int>(x, y), 5, cv::Scalar(0, 0, 0, 0), -1 );
        }
        else if(i < 28){
          cv::circle(plot, cv::Point_<int>(x, y), 3, cv::Scalar(255, 0, 0, 0), -1 );
        }
        else{
          cv::circle(plot, cv::Point_<int>(x, y), 3, cv::Scalar(0, 0, 255, 0), -1 );
        }
      }
  //    rectangle(plot, ann.bbox, Scalar(0, 0, 255), 3);
    }

    if(path == "") {
      cv::imshow("Face", plot);
      cv::waitKey(wait);
    }else{
      cv::imwrite(path,plot);
    }
}

void inline _plot_17(cv::Mat& img, std::vector<cv::Point> ann, std::string path = "", int wait = 0 ){
    cv::Mat plot;

    if( path != "") {
      plot = img;
    }else{
      //plot = img.clone();
      plot = img;
    }

    std::vector<Join> joints;

    joints.push_back( Join(0,1,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(2,1,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(2,3,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(2,4,cv::Scalar(0, 255, 0)) );

    joints.push_back( Join(2,5,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(5,6,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(6,7,cv::Scalar(0, 255, 0)) );
    joints.push_back( Join(6,8,cv::Scalar(0, 255, 0)) );

    joints.push_back( Join(3,9,cv::Scalar(255, 255, 0)) );
    joints.push_back( Join(9,10,cv::Scalar(255, 255, 0)) );
    joints.push_back( Join(4,11,cv::Scalar(255, 0, 255)) );
    joints.push_back( Join(11,12,cv::Scalar(255, 0, 255)) );

    joints.push_back( Join(8,15,cv::Scalar(0, 0, 255)) );
    joints.push_back( Join(15,16,cv::Scalar(0, 0, 255)) );

    joints.push_back( Join(7,13,cv::Scalar(255, 0, 0)) );
    joints.push_back( Join(13,14,cv::Scalar(255, 0, 0)) );


    for(int i=0; i < joints.size(); i++) {
      cv::Point a = ann[joints[i].part_a];
      cv::Point b = ann[joints[i].part_b];
      if(a.x >0 && b.x > 0 && a.y >0 && b.y > 0 && a.x < plot.cols && b.x < plot.cols ) {
        cv::line(plot, a, b, joints[i].color, 3);
      }
    }
    for (int i = 0; i < static_cast<int> (ann.size()); i++) {
      int x = ann[i].x;
      int y = ann[i].y;
      if (x > 0 and x < plot.cols and y > 0 and y < plot.rows) {
        if(i < 17){
          cv::circle(plot, cv::Point_<int>(x, y), 5, cv::Scalar(0, 0, 0, 0), -1 );
        }
        else if(i < 34){
          cv::circle(plot, cv::Point_<int>(x, y), 3, cv::Scalar(255, 0, 0, 0), -1 );
        }
        else{
          cv::circle(plot, cv::Point_<int>(x, y), 3, cv::Scalar(0, 0, 255, 0), -1 );
        }
      }
  //    rectangle(plot, ann.bbox, Scalar(0, 0, 255), 3);
    }

    if(path == "") {
      cv::imshow("Face", plot);
      cv::waitKey(wait);
    }else{
      cv::imshow("Check", plot);
      //cv::imwrite(path,plot);
    }
}

// displays the annotations
void inline plot(cv::Mat& img, std::vector<cv::Point> ann,
                 body_pose::BodyPoseTypes pose_type, std::string path = "", int wait = 0 ){

      if(pose_type == body_pose::FULL_BODY_J13 ||
            pose_type ==  body_pose::FULL_BODY_J13_TEMPORAL){
                  _plot(img, ann, path, wait);
      }
      else if(pose_type == body_pose::UPPER_BODY_J7){
        _plot_7(img, ann, path, wait);
      }
      else if(pose_type == body_pose::FULL_BODY_J14){
        _plot_14(img, ann, path, wait);
      }
      else if(pose_type == body_pose::FULL_BODY_J17){
        _plot_17(img, ann, path, wait);
      }
      else if(pose_type == body_pose::UPPER_BODY_J9){
        _plot_9(img, ann, path, wait);
      }

}

void inline _get_joint_constalation_J17(std::vector<int>& parents){
    parents.push_back(0);
    parents.push_back(0);
    parents.push_back(1);
    parents.push_back(2);
    parents.push_back(2);
    parents.push_back(2);
    parents.push_back(5);
    parents.push_back(6);
    parents.push_back(6);
    parents.push_back(3);
    parents.push_back(9);
    parents.push_back(4);
    parents.push_back(11);
    parents.push_back(7);
    parents.push_back(13);
    parents.push_back(8);
    parents.push_back(15);
}


void inline _get_joint_constalation_J14(std::vector<int>& parents){
    parents.push_back(0);
    parents.push_back(0);
    parents.push_back(1);
    parents.push_back(1);
    parents.push_back(2);
    parents.push_back(3);
    parents.push_back(2);
    parents.push_back(6);
    parents.push_back(3);
    parents.push_back(8);
    parents.push_back(4);
    parents.push_back(10);
    parents.push_back(5);
    parents.push_back(12);
}

void inline _get_joint_constalation_J13(std::vector<int>& parents){
    parents.push_back(0);
    parents.push_back(0);
    parents.push_back(0);
    parents.push_back(1);
    parents.push_back(2);
    parents.push_back(1);
    parents.push_back(5);
    parents.push_back(2);
    parents.push_back(7);
    parents.push_back(3);
    parents.push_back(9);
    parents.push_back(4);
    parents.push_back(11);
}

void inline _get_joint_constalation_J9(std::vector<int>& parents){

    // Normall Case
//    parents.push_back(0);
//    parents.push_back(0);
//    parents.push_back(0);
//    parents.push_back(1);
//    parents.push_back(2);
//    parents.push_back(1);
//    parents.push_back(5);
//    parents.push_back(2);
//    parents.push_back(7);


    // FixMe: Add a separate flag for TUM Kitchen Datasets
    // For MPII Cooking Dataset
    parents.push_back(0);
    parents.push_back(0);
    parents.push_back(0);
    parents.push_back(1);
    parents.push_back(3);
    parents.push_back(4);
    parents.push_back(2);
    parents.push_back(6);
    parents.push_back(7);

}

void inline _get_joint_constalation_J7(std::vector<int>& parents){
    parents.push_back(0);
    parents.push_back(0);
    parents.push_back(0);
    parents.push_back(1);
    parents.push_back(3);
    parents.push_back(2);
    parents.push_back(5);
}

void inline _get_joint_constalation_temporal(std::vector<int>& parents,
                          int nNeighbours) {

    static const int basic_parents[] = {0, 0, 0, 1, 2, 1, 5, 2, 7, 3, 9, 4, 11};

    int img_count = nNeighbours*2+1;
    for(int idx = 0; idx < img_count*13; idx++){

      int parent_id = 0;
      if(idx < 13){
        parent_id = basic_parents[idx];
      }
      else{
        parent_id = (idx%13);
      }

      parents.push_back(parent_id);

    }
}


void inline get_joint_constalation(std::vector<int>& parents,
                            body_pose::BodyPoseTypes pose_type,
                            int nNeigbours = 0) {

    switch(pose_type){
      case body_pose::FULL_BODY_J14:{
        _get_joint_constalation_J14(parents);
        break;
      }
      case body_pose::FULL_BODY_J13:{
        _get_joint_constalation_J13(parents);
        break;
      }
      case body_pose::FULL_BODY_J17:{
        _get_joint_constalation_J17(parents);
        break;
      }
      case body_pose::FULL_BODY_J13_TEMPORAL:{
        _get_joint_constalation_temporal(parents, nNeigbours);
      }
      case body_pose::UPPER_BODY_J7:{
        _get_joint_constalation_J7(parents);
        break;
      }
      case body_pose::UPPER_BODY_J9:{
        _get_joint_constalation_J9(parents);
        break;
      }
    }
}

void inline clean_annotations(const std::vector< Annotation>& annotations_org,
    std::vector< Annotation >& annotations) {
  for(int i=0; i < annotations_org.size(); i++) {
    bool all_parts_present = true;
    for(int j=0; j  < annotations_org[i].parts.size(); j++) {
      const cv::Point p = annotations_org[i].parts[j];
      if(p.x <= 0 || p.y <= 0 ) {
        all_parts_present = false;
      }
    }
    if(all_parts_present) {
      annotations.push_back(annotations_org[i]);
    }
  }
}

bool inline load_sequence_info(std::vector<SequenceInfo>& seq_infos, std::string url){
  if (boost::filesystem::exists(url.c_str())) {
    std::string filename(url.c_str());
    boost::iostreams::stream < boost::iostreams::file_source > file(
        filename.c_str());
    std::string line;
    while (std::getline(file, line)) {
      std::vector < std::string > strs;
      boost::split(strs, line, boost::is_any_of(" "));

      SequenceInfo info;
      info.path = strs[0];
      info.frame_count = boost::lexical_cast<int>(strs[1]);
      seq_infos.push_back(info);
    }
    return true;
  }
  return false;
}

/** The function takes the path to image index file and loads all image urls 
 *  in a vector.
**/
bool inline load_images(std::vector<std::string>& images, std::string url) {
  if (boost::filesystem::exists(url.c_str())) {
    std::string filename(url.c_str());
    boost::iostreams::stream < boost::iostreams::file_source > file(
        filename.c_str());
    std::string line;
    while (std::getline(file, line)) {
      std::vector < std::string > strs;
      boost::split(strs, line, boost::is_any_of(" "));

      std::string path;
      
      path = strs[0];
      images.push_back(path);
    }
    return true;
  }
  std::cout << "file not found: " << url << std::endl;
  return false;
}


/** The function takes the path to image index file and loads the whole information
 into a vector of Annotation structure.
 The information contain url of the image, bounding box of the person and
 coordinates of the body joints.
**/
bool inline load_annotations(std::vector<Annotation>& annotations, std::string url, int cluster_id = -1) {
  if (boost::filesystem::exists(url.c_str())) {
    std::string filename(url.c_str());
    boost::iostreams::stream < boost::iostreams::file_source > file(
        filename.c_str());
    std::string line;
    while (std::getline(file, line)) {
      std::vector < std::string > strs;
      boost::split(strs, line, boost::is_any_of(" "));

      Annotation ann;
      
      ann.url = strs[0];

     // if (!boost::filesystem::exists(ann.url)){
     //   continue;
     // }

    
      ann.bbox.x = boost::lexical_cast<int>(strs[1]);
      ann.bbox.y = boost::lexical_cast<int>(strs[2]);
      ann.bbox.width = boost::lexical_cast<int>(strs[3]);
      ann.bbox.height = boost::lexical_cast<int>(strs[4]);

      ann.cluster_id = boost::lexical_cast<int>(strs[5]);

      if(cluster_id > 0){
        if(cluster_id != ann.cluster_id){
          continue;
        }
      }
      int num_points = boost::lexical_cast<int>(strs[6]);
      ann.parts.resize(num_points);
      for (int i = 0; i < num_points; i++) {
        ann.parts[i].x = boost::lexical_cast<int>(strs[7 + 2 * i]);
        ann.parts[i].y = boost::lexical_cast<int>(strs[8 + 2 * i]);
      }

      // check if more info is given in the annotation file
      // e.g. best scale of the image, any type of weight, etc.
      int rem = strs.size() - num_points*2 - 7;
      if(rem%2 == 0 && rem != 0){
        int index = num_points*2 + 7;
        for(int i=index; i<strs.size(); i=i+2){
          std::string flag = strs[i];
          if(!flag.compare("-bs"))
              ann.best_scale = boost::lexical_cast<double>(strs[i+1]);
          else if(!flag.compare("-w"))
              ann.weight = boost::lexical_cast<double>(strs[i+1]);
//          else
//              std::cout<<"WARNING: Unknown extra values exist in annotation file.";
          }
        }
      annotations.push_back(ann);
      
    }
    return true;
  }
  std::cout << "file not found: " << url << std::endl;
  return false;
}

bool inline load_annotations_temporal(std::vector<Annotation>& annotations, std::string url, int img_count = -1) {
  if (boost::filesystem::exists(url.c_str())) {
    std::string filename(url.c_str());
    boost::iostreams::stream < boost::iostreams::file_source > file(
        filename.c_str());
    std::string line;
    while (std::getline(file, line)) {
      std::vector < std::string > strs;
      boost::split(strs, line, boost::is_any_of(" "));

      if(strs.size() == NUM_ENTRIES){ //if file does not contain temporal annotations
          load_annotations(annotations, url);
          return true;
      }

      if(img_count < 1){
        img_count = strs.size()/NUM_ENTRIES;
      }

      Annotation ann;
      ann.url = strs[0];
      if (!boost::filesystem::exists(ann.url)){
        continue;
      }

      ann.bbox.x = boost::lexical_cast<int>(strs[1]);
      ann.bbox.y = boost::lexical_cast<int>(strs[2]);
      ann.bbox.width = boost::lexical_cast<int>(strs[3]);
      ann.bbox.height = boost::lexical_cast<int>(strs[4]);

      ann.cluster_id = boost::lexical_cast<int>(strs[5]);

      ann.nNeighbours = floor(img_count/2);

      for(int idx = 1; idx < img_count; idx++){

        std::string neig_url = strs[(idx*NUM_ENTRIES) + 0];

        cv::Rect neig_bbox;
        neig_bbox.x = boost::lexical_cast<int>(strs[(idx*NUM_ENTRIES) + 1]);
        neig_bbox.y = boost::lexical_cast<int>(strs[(idx*NUM_ENTRIES) + 2]);
        neig_bbox.width = boost::lexical_cast<int>(strs[(idx*NUM_ENTRIES) + 3]);
        neig_bbox.height = boost::lexical_cast<int>(strs[(idx*NUM_ENTRIES) + 4]);

        ann.neig_urls.push_back(neig_url);
        ann.neig_bboxs.push_back(neig_bbox);
      }

      int num_points = boost::lexical_cast<int>(strs[6]);

      ann.parts.resize(num_points*img_count);

      for(int idx = 0; idx < img_count; idx++){
        for (int i = 0; i < num_points; i++) {
            ann.parts[idx*num_points+i].x = boost::lexical_cast<int>(strs[(idx*NUM_ENTRIES) + 7 + 2 * i]);
            ann.parts[idx*num_points+i].y = boost::lexical_cast<int>(strs[(idx*NUM_ENTRIES) + 8 + 2 * i]);
//            std::cout<<i<<": ";
//            std::cout<<ann.parts[i].x<<" "<<ann.parts[i].y<<std::endl;
        }
      }
      annotations.push_back(ann);
    }
    return true;
  }
  std::cout << "file not found: " << url << std::endl;
  return false;
}

int inline get_upperbody_size( const std::vector<cv::Point> parts, body_pose::BodyPoseTypes pose_type ){

  cv::Point hip_center, shoulder_center;

  if(pose_type == body_pose::FULL_BODY_J13 || pose_type == body_pose::UPPER_BODY_J9){

    if( parts[4].x < 0 ||
        parts[3].x < 0 ||
        parts[2].x < 0 ||
        parts[1].x < 0) {
      return -1;
    }
    hip_center.x = (parts[4].x+ parts[3].x) /2;
    hip_center.y = (parts[4].y+ parts[3].y) /2;
    shoulder_center.x = (parts[2].x+ parts[1].x) /2;
    shoulder_center.y = (parts[2].y+ parts[1].y) /2;
  }
  else if(pose_type == body_pose::FULL_BODY_J14){
    if( parts[5].x < 0 ||
        parts[4].x < 0 ||
        parts[3].x < 0 ||
        parts[2].x < 0) {
      return -1;
    }
    hip_center.x = (parts[5].x+ parts[4].x) /2;
    hip_center.y = (parts[5].y+ parts[4].y) /2;
    shoulder_center.x = (parts[3].x+ parts[2].x) /2;
    shoulder_center.y = (parts[3].y+ parts[2].y) /2;
  }
  else if(pose_type == body_pose::FULL_BODY_J17){
      if( parts[8].x < 0 ||
        parts[7].x < 0 ||
        parts[4].x < 0 ||
        parts[3].x < 0) {
      return -1;
    }
    hip_center.x = (parts[7].x+ parts[8].x) /2;
    hip_center.y = (parts[7].y+ parts[8].y) /2;
    shoulder_center.x = (parts[4].x+ parts[3].x) /2;
    shoulder_center.y = (parts[4].y+ parts[3].y) /2;
  }

  return std::sqrt( (hip_center.x-shoulder_center.x)*(hip_center.x-shoulder_center.x) +
      (hip_center.y-shoulder_center.y)*(hip_center.y-shoulder_center.y) );
}

void inline get_limb_sizes(Annotation ann, std::vector<int>& selected_parts, std::vector<int>& parents,
               std::vector<int>& limb_sizes)
{
  for(unsigned int idx = 0; idx < selected_parts.size(); idx++){
    int part_id = selected_parts[idx];
    int parent = parents[part_id];
    cv::Point parent_loc = ann.parts[parent];
    cv::Point part_loc = ann.parts[part_id];

    int size = 0;
    if(part_loc.x < 0 || part_loc.y < 0 ||
       parent_loc.x < 0 || parent_loc.y < 0){
       size = -1;
    }else {
       size = ceil(std::sqrt( (parent_loc.x-part_loc.x)*(parent_loc.x-part_loc.x) +
            (parent_loc.y-part_loc.y)*(parent_loc.y-part_loc.y) ));
    }
    limb_sizes.push_back(size);
  }
}


float inline get_body_scale_factor(const Annotation ann){

  body_pose::BodyPoseTypes pose_type = body_pose::FULL_BODY_J13;

  std::vector<int> selected_parts;
  selected_parts += 1,2,3,4,5,6,7,8,9,10,11,12;

  std::vector<int> norm_sizes;
  norm_sizes  += 23,23,50,50,21,21,21,21,34, 34, 32, 32;

  std::vector<int> parents;
  get_joint_constalation(parents, pose_type);

  std::vector<int> limb_sizes;
  std::vector<float> scales(norm_sizes.size());

  get_limb_sizes(ann, selected_parts, parents, limb_sizes);

  for(unsigned int i=0; i<limb_sizes.size(); i++){
    scales[i] = static_cast<float>(norm_sizes[i])/limb_sizes[i];
  }

  std::sort(scales.begin(), scales.end());

  float scale = scales[scales.size()/2];

  return scale;
}


int inline get_upperbody_size( const Annotation ann, body_pose::BodyPoseTypes pose_type ){
  return get_upperbody_size(ann.parts, pose_type);
}

int inline get_upperbody_size_temporal( const std::vector<cv::Point> parts, int nNeighbours){

  int img_count = nNeighbours*2+1;

  for(int idx = 0; idx < img_count; idx++){
    if( parts[idx*13+4].x < 0 ||
        parts[idx*13+3].x < 0 ||
        parts[idx*13+2].x < 0 ||
        parts[idx*13+1].x < 0) {
          return -1;
      }
  }

  int body_size = 0;

  for(int idx = 0; idx < img_count; idx++){
    cv::Point hip_center;
    hip_center.x = (parts[idx*13+4].x+ parts[idx*13+3].x) /2;
    hip_center.y = (parts[idx*13+4].y+ parts[idx*13+3].y) /2;
    cv::Point shoulder_center;
    shoulder_center.x = (parts[idx*13+2].x+ parts[idx*13+1].x) /2;
    shoulder_center.y = (parts[idx*13+2].y+ parts[idx*13+1].y) /2;

    body_size += std::sqrt( (hip_center.x-shoulder_center.x)*(hip_center.x-shoulder_center.x) +
      (hip_center.y-shoulder_center.y)*(hip_center.y-shoulder_center.y) );
  }

  body_size /= img_count; // average body size of all frames

  return body_size;
}

int inline get_upperbody_size_temporal( const Annotation ann ){

  return get_upperbody_size_temporal(ann.parts, ann.nNeighbours);
}


#endif /* COMMON_HPP_ */
