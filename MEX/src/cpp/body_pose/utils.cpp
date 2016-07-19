/*
 * utils.hpp
 *
 *  Created on: Jan 19, 2012
 *      Author: Matthias Dantone
 */

#include "cpp/body_pose/utils.hpp"
#include <fstream>
#include <math.h>
#include <opencv2/opencv.hpp>
#include <opencv2/flann/flann.hpp>

#include <boost/archive/binary_oarchive.hpp>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/serialization/vector.hpp>
#include <boost/serialization/utility.hpp>
#include <boost/filesystem/convenience.hpp>
#include <boost/filesystem.hpp>
#include <boost/iostreams/device/file.hpp>
#include <boost/iostreams/stream.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/filesystem/path.hpp>
#include <boost/progress.hpp>
#include <boost/assign/std/vector.hpp>
#include <boost/format.hpp>
#include <boost/thread/thread.hpp>

#include "cpp/learning/common/eval_utils.hpp"
#include "cpp/learning/common/image_sample.hpp"
#include "cpp/learning/forest/utils/eval_utils.hpp"
#include "cpp/utils/image_file_utils.hpp"
#include "cpp/utils/serialization/opencv_serialization.hpp"
#include "cpp/utils/system_utils.hpp"
#include "cpp/utils/string_utils.hpp"
#include "cpp/third_party/json_spirit/json_spirit.h"
#include "cpp/vision/geometry_utils.hpp"
#include "cpp/vision/mean_shift.hpp"

using namespace boost::assign;
using namespace std;
using namespace cv;

using learning::forest::ForestParam;
using learning::forest::Forest;
using learning::common::Image;
using vision::mean_shift::Vote;
using vision::features::feature_channels::FeatureChannelFactory;
using learning::forest::utils::get_forground_map;
using learning::forest::utils::get_conditional_voting_map;
using learning::forest::utils::get_voting_map;
using learning::forest::utils::get_attr_wise_conditional_voting_map;
using utils::image_file::load_images;


void get_mask(int part_id, const Mat& img, const Annotation ann,
    Mat_<uchar>& mask, body_pose::BodyPoseTypes pose_type, bool debug ) {

  float size = get_upperbody_size(ann, pose_type);

  Annotation ann_tmp = ann;

  if(part_id >= 0) {
    ann_tmp.parts.clear();
    ann_tmp.parts.resize(ann.parts.size(), Point(-1,-1));
    ann_tmp.parts[part_id] = ann.parts[part_id];
  }

  get_mask(img, ann_tmp, mask, pose_type, size, false);
  if( debug ) {
    for( int i = 0; i < ann_tmp.parts.size(); i++) {
      LOG(INFO) << i << ": " << ann_tmp.parts[i].x << " " << ann_tmp.parts[i].y << endl;
    }
    LOG(INFO) << "partID: " << part_id << endl;
    LOG(INFO) << "#parts: " << ann_tmp.parts.size() << endl;
    cv::imshow("Mask", mask);
    cv::waitKey(0);
  }
}

void get_mask(const Mat& img, const vector<Point>& parts, Mat_<uchar>& mask, body_pose::BodyPoseTypes pose_type, int size, bool debug) {
  mask = cv::Mat::zeros(img.size(), cv::DataType<uchar>::type);
  Scalar color(255, 255, 255);

  if(size < 0){
    size = get_upperbody_size(parts, pose_type);
  }
  // check if only one part is active
  int num_active_parts = 0;
  for(int i = 0; i < parts.size(); i++ ) {
    if(parts[i].x > 0 ){
      num_active_parts ++;
    }
  }

  for(int i = 0; i < parts.size(); i++ ) {
    if(parts[i].x > 0 ){
      int s = 0;
      if( num_active_parts == 1){
        s = size/2.75;
      }else if( i == 12 or i == 10 or i == 0 ) {
        s = size/2.75;
      }else if(i == 8 or i == 6 ){
        s = size/3.5;
      }else {
        s = size/5;
      }
      circle(mask, parts[i], s, color,-1);
    }
  }

  //draw connections
  vector<pair<int,int> > joints;
  joints.push_back( make_pair(1,5) );
  joints.push_back( make_pair(5,6) );

  joints.push_back( make_pair(2,7) );
  joints.push_back( make_pair(7,8) );

  joints.push_back( make_pair(4,11) );
  joints.push_back( make_pair(11,12) );

  joints.push_back( make_pair(3,9) );
  joints.push_back( make_pair(9,10) );

  joints.push_back( make_pair(1,2) );
  joints.push_back( make_pair(4,3) );
  joints.push_back( make_pair(2,4) );
  joints.push_back( make_pair(1,3) );


  for(int i=0; i < joints.size(); i++) {
    Point a = parts[joints[i].first];
    Point b = parts[joints[i].second];
    if(a.x >0 and b.x > 0 ) {
        line(mask, a, b, color, size/3);

    }
  }

  if(parts[0].x > 0 &&
     parts[1].x > 0 &&
     parts[2].x > 0 &&
     parts[3].x > 0 &&
     parts[4].x > 0) {
    Point points[1][5];
    points[0][0] = parts[0];
    points[0][1] = parts[1];
    points[0][2] = parts[3];
    points[0][3] = parts[4];
    points[0][4] = parts[2];
    const Point* ppt[1] = { points[0] };
    int npt[] = { 5 };
    fillPoly(mask, ppt, npt , 1, color);
  }

  if(debug) {
    imshow("Mask", mask);
    waitKey(0);
  }
}

void get_mask(const Mat& img, const Annotation& ann, Mat_<uchar>& mask, body_pose::BodyPoseTypes pose_type, int size, bool debug) {
  get_mask(img, ann.parts, mask, pose_type, size, debug);
}


// rescale image
void rescale_img(const Mat& src, Mat& dest, float scale,
    Annotation& ann) {

  if( abs(scale - 1) > 0.05 ){
    resize(src, dest, Size(src.cols * scale, src.rows * scale), 0, 0);
    rescale_ann(ann, scale);
  }
}

//rescale annotation
void rescale_ann(Annotation& ann, float scale){
    for (unsigned int j = 0; j < ann.parts.size(); j++) {
      if(ann.parts[j].x >= 0 || ann.parts[j].y >= 0){
        ann.parts[j].x *= scale;
        ann.parts[j].y *= scale;
      }
    }
    ann.bbox.x *= scale;
    ann.bbox.y *= scale;
    ann.bbox.width *= scale;
    ann.bbox.height *= scale;
}

void extract_roi( const Mat& img, Annotation& ann,
    Mat& img_roi , int offset_x, int offset_y, Rect* extracted_region){

  // extract face
  Rect bigbox = Rect(ann.bbox.x - offset_x, ann.bbox.y - offset_y,
      ann.bbox.width + offset_x * 2, ann.bbox.height + offset_y * 2);
  Rect facebbox = vision::geometry_utils::intersect(bigbox, Rect(0, 0, img.cols, img.rows));

  img_roi = img(facebbox);

  //update GT
  for (unsigned int j = 0; j < ann.parts.size(); j++) {
    ann.parts[j].x -= (facebbox.x);
    ann.parts[j].y -= (facebbox.y);
  }

  if(extracted_region) {
    *extracted_region = facebbox;
  }
  ann.bbox = facebbox;
  ann.bbox.x = 0;
  ann.bbox.y = 0;

}

void extract_roi( const Mat& img, Annotation& ann,
    Mat& img_roi, Rect* extracted_region, float ratio){


  int x1 = ann.bbox.x;
  int y1 = ann.bbox.y;
  int x2 = x1 + ann.bbox.width;
  int y2 = y1 + ann.bbox.height;


  int offset = static_cast<int>(ratio*((x2-x1)+(y2-y1)));

  // extract face
  Rect bigbox = Rect(ann.bbox.x - offset, ann.bbox.y - offset,
      ann.bbox.width + offset * 2, ann.bbox.height + offset * 2);
  Rect facebbox = vision::geometry_utils::intersect(bigbox, Rect(0, 0, img.cols, img.rows));

  img_roi = img(facebbox);
  //update GT
  for (unsigned int j = 0; j < ann.parts.size(); j++) {
    ann.parts[j].x -= (facebbox.x);
    ann.parts[j].y -= (facebbox.y);
  }

  if(extracted_region) {
    *extracted_region = facebbox;
  }

  ann.bbox = facebbox;
  ann.bbox.x = 0;
  ann.bbox.y = 0;

}

void extract_roi(std::vector<cv::Mat>& images,
                  std::vector<cv::Mat>& roi_images,
                   std::vector<cv::Rect>& bboxes,
                   cv::Rect& best_bbox, float ratio) {


    CHECK(images.size());

    roi_images.resize(images.size());

    CHECK_EQ(images.size(), bboxes.size());

    // crop according to the bounding boxes
    int x1 = bboxes[0].x;
    int y1 = bboxes[0].y;
    int x2 = x1 + bboxes[0].width;
    int y2 = y1 + bboxes[0].height;

    for(unsigned int idx = 0; idx < bboxes.size(); idx++){
      x1 = std::min(x1, bboxes[idx].x);
      y1 = std::min(y1, bboxes[idx].y);
      x2 = std::max(x2, bboxes[idx].width+bboxes[idx].x);
      y2 = std::max(y2, bboxes[idx].height+bboxes[idx].y);
    }

    best_bbox = cv::Rect(x1, y1, x2-x1, y2-y1);

    int offset = static_cast<int>(ratio*((x2-x1)+(y2-y1)));

    best_bbox.x -= offset; best_bbox.y -= offset;
    best_bbox.width += 2*offset; best_bbox.height += 2*offset;
    best_bbox = vision::geometry_utils::intersect(best_bbox,
                      Rect(0, 0, images[0].cols, images[0].rows));


    for(unsigned int idx = 0; idx < images.size(); idx++){
      roi_images[idx] = images[idx](best_bbox);
    }
}

void rotate_image(const Mat& src, const Annotation& ann,
    Point center, double angle,
    Mat& dst, Annotation& rotated_ann){

  Mat rot_mat = getRotationMatrix2D( center, angle, 1);
  dst = Mat::zeros( src.rows, src.cols, src.type() );
  warpAffine( src, dst, rot_mat, dst.size() );

  rotated_ann = ann;
  rotated_ann.parts.clear();
  for(int i=0; i < ann.parts.size(); i++){
    const Point& p = ann.parts[i];
    if( p.x > 0) {
      Point p_rot;
      p_rot.x = p.x* rot_mat.at<double>(0, 0)
            + p.y* rot_mat.at<double>(0, 1)
            + rot_mat.at<double>(0, 2);
      p_rot.y = p.x* rot_mat.at<double>(1, 0)
             + p.y* rot_mat.at<double>(1, 1)
             + rot_mat.at<double>(1, 2);

      rotated_ann.parts.push_back(p_rot);
    }else{
      rotated_ann.parts.push_back(Point(-1,-1));
    }
  }
}

void non_max_suspression(const Mat& vote_map, int num_maximas,
    int non_max_suspression, vector<Point>& maximas) {
  Mat map = vote_map.clone();

  for(int i=0; i < num_maximas; i++) {
    Point max;
    minMaxLoc(map, 0, 0, 0, &max);
    Rect rect(max.x - non_max_suspression/2, max.y-non_max_suspression/2,
        non_max_suspression,non_max_suspression);
    rect = vision::geometry_utils::intersect(Rect(0,0,map.cols, map.rows),rect);
    map(rect).setTo(Scalar(0));
    maximas.push_back(max);
  }
}


void create_image_sample_mt(const vector<Mat>& images,
    vector<int>& features,
    vector<Image>& samples, bool use_integral, int num_threads, int global_attr_label){
  if(images.size() == 0 ) {
    LOG(INFO) << "no images.";
    return;
  }

  samples.resize(images.size());


  if(num_threads < 1){
    num_threads = utils::system::get_available_logical_cpus();
  }

  //LOG(INFO)<<"Number of threads = "<<num_threads;
  FeatureChannelFactory fcf;

  if(num_threads > 1){
    boost::thread_pool::executor e(num_threads);
    for(unsigned int i = 0; i < samples.size(); i++) {
      e.submit(boost::bind( &Image::init, &samples[i], images[i],
          features, &fcf, use_integral, i));
    }
    e.join_all();
  }else{
    for(unsigned int i = 0; i < images.size(); i++) {
      samples[i].init(images[i], features, &fcf, false, i);
    }
  }

  if(global_attr_label >= 0){
    for(unsigned int i = 0; i < samples.size(); i++) {
      samples[i].set_global_attr_label(global_attr_label);
    }
  }
}

void create_virtual_samples(std::vector<Annotation>& annotations,
    std::vector<cv::Mat>& images,
    int num_virtal_sample_per_sample,
    boost::mt19937* rng,
    int anker_part_id) {

  vector<Mat> virtual_imgs;
  vector<Annotation> virtual_anns;
  virtual_anns.reserve(num_virtal_sample_per_sample*images.size());
  virtual_imgs.reserve(num_virtal_sample_per_sample*images.size());
  for(int i=0; i < images.size(); i++) {
    const Mat& img = images[i];
    const Annotation& ann = annotations[i];
    Point anker;
    if( anker_part_id < 0 || anker_part_id >= ann.parts.size()) {
      anker.x = img.cols/2;
      anker.y = img.rows/2;
    }else{
      anker = ann.parts[anker_part_id];
    }


    boost::normal_distribution<> nd(0.0, 5);
    boost::variate_generator<boost::mt19937&, boost::normal_distribution<> > rand_gauss(*rng, nd);
    boost::uniform_int<> dist_scale(0, 100);
    boost::variate_generator<boost::mt19937&, boost::uniform_int<> > rand_scale(*rng, dist_scale);
    bool rotate = true;
    for(int j=0; j < num_virtal_sample_per_sample; j++) {
      Mat v_img;
      Annotation v_ann;
      if( rotate ) {
        double angle = rand_gauss();
        rotate_image(img, ann, anker, angle, v_img, v_ann);
      }else{

        float scale = rand_scale()/750.0 +1.0;
        v_ann = ann;
        rescale_img(img, v_img, scale, v_ann);
      }

      virtual_imgs.push_back(v_img);
      virtual_anns.push_back(v_ann);
//      plot(v_img, v_ann.parts, "");
    }

  }
  images.insert(images.end(), virtual_imgs.begin(), virtual_imgs.end());
  annotations.insert(annotations.end(), virtual_anns.begin(), virtual_anns.end());

}



// kmean clustering
void cluster_annotations(vector<Annotation>& anns, int n_clusters, vector<int> parents,  int part_id ) {

  int num_parts = parents.size();

  LOG(INFO) << anns.size() << " annotations for clustering.";

  cv::Mat features;
  if( part_id < 0 ) {
    LOG(INFO) << "cluster entire person";
    features = Mat(cv::Size(4*num_parts,anns.size()),CV_32FC1);
    for(int i=0; i < anns.size(); i++) {
      const Point& head = anns[i].parts[0];

      for(int j=0; j < num_parts; j++) {
        const Point& part = anns[i].parts[j];
        const Point& parent = anns[i].parts[parents[j]];

        Point offset_parent = part - parent;
        Point offset_head = part - head;

        features.at<float>(i,j*4)   = offset_parent.x; // diff x to parent
        features.at<float>(i,j*4+1) = offset_parent.y; // diff y to parent
        features.at<float>(i,j*4+2) = offset_head.x; // diff x to head
        features.at<float>(i,j*4+3) = offset_head.y; // diff y to head
      }
    }
  }else{
    LOG(INFO) << "cluster relative to part " << part_id;

    features = Mat(cv::Size(2,anns.size()),CV_32FC1);
    for(int i=0; i < anns.size(); i++) {
      const Point& part = anns[i].parts[part_id];
      const Point& parent = anns[i].parts[parents[part_id]];
      Point offset_parent = part - parent;

      CHECK(part.x >= 0);
      CHECK(part.y >= 0);
      CHECK(parent.x >= 0);
      CHECK(parent.y >= 0);

      features.at<float>(i,0) = offset_parent.x; // diff x to parent
      features.at<float>(i,1) = offset_parent.y; // diff y to parent

    }
  }
  cv::TermCriteria term_criteria;
  term_criteria.epsilon = 1;
  term_criteria.maxCount = 10;
  term_criteria.type = cv::TermCriteria::MAX_ITER | cv::TermCriteria::EPS;
  cv::Mat labels;
  cv::Mat centers;
  cv::kmeans(features, n_clusters, labels, term_criteria, 10, cv::KMEANS_PP_CENTERS, centers);
  vector<int> label_hist(n_clusters,0);
  for(int i=0; i < anns.size(); i++) {
    int p = labels.at<int>(0,i);
    anns[i].cluster_id = p;
    label_hist[p]++;
  }
  LOG(INFO) << "n_clusters " << n_clusters;
  LOG(INFO) << "centers " << centers;
  LOG(INFO) << "label hist " << utils::VectorToString(label_hist);

}

void get_forground_map_mt(const Image* sample, const Forest<BodyPartSample>* forest,
        cv::Mat* foreground_map, const cv::Rect roi, int step_size, bool blur) {
	learning::forest::utils::get_forground_map(*sample, *forest,
																						 *foreground_map, roi,
																						 step_size, blur);
}

void get_multiple_forground_map(const Image& sample,
    const std::vector<Forest<BodyPartSample> >& forests,
    vector<cv::Mat_<float> >& foreground_maps,
    const cv::Rect roi,
    int step_size,
    bool blur, int num_threads) {

  if(num_threads < 1){
    num_threads = utils::system::get_available_logical_cpus();
  }
  if(num_threads > 1 ) {
    boost::thread_pool::executor e(num_threads);
    foreground_maps.resize(forests.size());
    for(unsigned int i = 0; i < forests.size(); i++) {
      e.submit(boost::bind(&get_forground_map_mt, &sample, &forests[i],
          &foreground_maps[i], roi, step_size, blur));
    }
    e.join_all();
  }else{
    for(unsigned int i = 0; i < forests.size(); i++) {
      learning::forest::utils::get_forground_map(sample, forests[i],
					foreground_maps[i], roi, step_size, blur);
    }
  }
}


void get_votingmap_mt(const Image* sample, const Forest<BodyPartSample>* f, cv::Mat* mat, cv::Rect bbox, int stepsize, bool blur) {
  get_voting_map( *sample, *f, *mat, bbox, stepsize);
}
void get_map_mt(const Image* sample, const Forest<BodyPartSample>* f, cv::Mat* mat, cv::Rect bbox, int stepsize, bool blur) {
	get_forground_map( *sample, *f, *mat, bbox, stepsize);
}
void get_conditional_votingmap_mt(const Image* sample,
        const Forest<BodyPartSample>* f, cv::Mat* mat,
          cv::Rect bbox, int stepsize, std::vector<double> cond_reg_weights, bool blur) {
  get_conditional_voting_map( *sample, *f, *mat, bbox, stepsize,blur, false, cv::Rect(0,0,0,0), cond_reg_weights);
}

void eval_forests(const std::vector<Forest<BodyPartSample> >& forests,
      const Image& sample,
      std::vector<cv::Mat_<float> >& voting_maps,
      int stepsize,
      bool regression,
      int num_threads,
      bool cond_regression,
      std::vector<std::vector<double> > cond_reg_weights,
      bool blur) {
  voting_maps.clear();
  Rect bbox(0,0,sample.width(),sample.height());
  voting_maps.resize(forests.size());

  std::vector<std::vector<double> > learnt_weigths(13);

  if(num_threads < 1){
    num_threads = utils::system::get_available_logical_cpus();
  }
  if( num_threads > 1 ) {
    boost::thread_pool::executor e(num_threads);
    for(int i=0; i < forests.size(); i++){
      if(regression) {
        if(cond_regression){
         e.submit(boost::bind(&get_conditional_votingmap_mt, &sample, &forests[i], &voting_maps[i], bbox, stepsize, cond_reg_weights[i], blur));
        }else{
          e.submit(boost::bind(&get_votingmap_mt, &sample, &forests[i], &voting_maps[i], bbox, stepsize,blur));
        }
      }else{
        e.submit(boost::bind(&get_map_mt, &sample, &forests[i], &voting_maps[i], bbox, stepsize, blur));
      }
    }
    e.join_all();
  }else{

    for(int i=0; i < forests.size(); i++){
      if(regression) {
        if(cond_regression){
          get_conditional_voting_map(sample, forests[i], voting_maps[i], bbox, stepsize,blur, false, cv::Rect(0,0,0,0), cond_reg_weights[i]);
        }
        else
        {
          get_voting_map(sample, forests[i], voting_maps[i], bbox, stepsize, blur);
        }

      }else{
         get_forground_map(sample, forests[i], voting_maps[i], bbox, stepsize, blur);
      }
    }
  }
}


void get_attr_wise_conditional_voting_map_mt(const Image* sample,
        const Forest<BodyPartSample>* f, std::vector<cv::Mat_<float> >* voting_maps,
          cv::Rect bbox, int stepsize, bool blur) {
  get_attr_wise_conditional_voting_map( *sample, *f, *voting_maps, bbox, stepsize,blur, false, cv::Rect(0,0,0,0));
}


// evaluate the forest for each part and return voting maps for
// each value of the global attributes.
void eval_attr_wise_forests(const std::vector<Forest<BodyPartSample> >& forests,
      const Image& sample,
      std::vector<std::vector<cv::Mat_<float> > >& voting_maps,
      int stepsize,
      bool regression,
      int num_threads,
      int num_global_attr,
      bool blur) {

  voting_maps.clear();
  Rect bbox(0,0,sample.width(),sample.height());

  voting_maps.resize(forests.size());
  for(unsigned int i=0; i<voting_maps.size(); i++){
    voting_maps[i].resize(num_global_attr);
  }

  if(num_threads < 1){
    num_threads = utils::system::get_available_logical_cpus();
  }
  if( num_threads > 1 ) {
    boost::thread_pool::executor e(num_threads);
    for(int i=0; i < forests.size(); i++){
      if(regression) {
        e.submit(boost::bind(&get_attr_wise_conditional_voting_map_mt, &sample, &forests[i], &voting_maps[i], bbox, stepsize, blur));
      }else{
        //TODO: Just in case if conditional classification is needed
        //e.submit(boost::bind(&get_map_mt, &sample, &forests[i], &voting_maps[i], bbox, stepsize));
      }
    }
    e.join_all();
  }else{

    for(int i=0; i < forests.size(); i++){
      if(regression) {
          get_attr_wise_conditional_voting_map(sample, forests[i], voting_maps[i], bbox, stepsize,blur, false, cv::Rect(0,0,0,0), std::vector<double>());
      }else{
        //TODO: Just in case if conditional classification is needed
        //get_forground_map(sample, forests[i], voting_maps[i], bbox, stepsize);
      }
    }
  }
}


bool part_and_parent_is_valid(const Annotation& ann, int part_id, int parent_id, body_pose::BodyPoseTypes pose_type){

  CHECK_GT(ann.parts.size(), part_id);
  CHECK_GT(ann.parts.size(), parent_id);

  if( ann.parts[part_id].x <= 0 || ann.parts[part_id].y <= 0)
    return false;

  if( ann.parts[parent_id].x <= 0 || ann.parts[parent_id].y <= 0)
    return false;

  if( get_upperbody_size(ann, pose_type) <= 0  )
    return false;

  return true;
}

bool load_data(string index_file,
    vector<Mat>& images,
    vector<Annotation>& annotations,
    body_pose::BodyPoseTypes pose_type,
    int num_images,
    int part_id,
    int n_clusters,
    std::vector<int> clusterIds,
    bool use_flipped_annotations) {

  // loading annotations

  if(clusterIds.size() > 0){
    vector<Annotation> org_annotations;
    load_annotations(org_annotations, index_file);
    getAnnotationsWithClusterId(org_annotations, annotations, clusterIds, pose_type, use_flipped_annotations );
  }
  else{
    load_annotations(annotations, index_file);
    if(use_flipped_annotations){
      int nAnn = annotations.size();
      for(int i=0; i<nAnn; i++){
	//annotations[i].flipped = true;
	//flip_parts(annotations[i], body_pose::FULL_BODY_J13);
        Annotation ann = annotations[i];
        ann.flipped = true;
        flip_parts(ann, pose_type);
        annotations.push_back(ann);
      }
    }
  }

  LOG(INFO) << annotations.size() << " annotations found.";

  vector<int> parents;
  get_joint_constalation(parents, pose_type);

  for(int i=0; i < annotations.size(); i++) {
    const Annotation& ann = annotations[i];
    if(part_id < 0) {
      continue;
    }

    if( !part_and_parent_is_valid( ann, part_id, parents[part_id], pose_type) ){
      annotations.erase(annotations.begin()+i);
      i--;
    }
  }
  LOG(INFO) << annotations.size() << " cleaned annotations.";
  random_shuffle( annotations.begin(), annotations.end());


  // loading images into memory
  num_images = MIN(num_images, annotations.size());
  annotations.resize(num_images);
  boost::progress_display show_progress(num_images);
  for(int i=0; i < num_images; i ++) {
    cv::Mat img = cv::imread(annotations[i].url, 1);
    if(img.data == NULL){
      LOG(INFO) << "could not load " << annotations[i].url << std::endl;
    }
    else{
      if(annotations[i].flipped){
        cv::flip(img, img, 1);
      }
      images.push_back(img);
//      plot(img, annotations[i].parts, body_pose::FULL_BODY_J13);
    }
  }
  LOG(INFO) << images.size() <<" images found!" ;
  CHECK_EQ(annotations.size(), images.size());
  return true;
}

bool create_confs_and_dirs(std::string& base_url, std::string& exp_name,
                         std::vector<std::string>& pair_names,
                          learning::forest::ForestParam& param,
                            std::vector<std::string>& config_files, bool generateNameOnly = false)
{

    if(!generateNameOnly){
      boost::filesystem::path exp_dir(base_url+"/"+exp_name);
      CHECK(boost::filesystem::create_directory(exp_dir));
    }

    for(int idx=0; idx<pair_names.size(); idx++){
      string dPath = base_url+"/"+exp_name+"/"+pair_names[idx]+"/";
      std::string f_name = base_url+"/"+exp_name+"/"+pair_names[idx]+"/config.txt";

      if(!generateNameOnly){
        boost::filesystem::path dir_path(dPath);
        CHECK(boost::filesystem::create_directory(dir_path));

        std::ofstream ofs((f_name).c_str());
        CHECK(ofs);

        ofs<<"____Path to images index file"<<std::endl;
        ofs<<param.img_index_path<<std::endl;
        ofs<<"____Path to folders containing the trees"<<std::endl;
        ofs<<dPath<<std::endl;
        ofs<<"____Number of trees"<<std::endl;
        ofs<<param.num_trees<<std::endl;
        ofs<<"____Number of testscd"<<std::endl;
        ofs<<param.num_split_candidates<<std::endl;
        ofs<<"____Max depth"<<std::endl;
        ofs<<param.max_depth<<std::endl;
        ofs<<"____Min samples per Node"<<std::endl;
        ofs<<param.min_samples<<std::endl;
        ofs<<"____Samples per Tree"<<std::endl;
        ofs<<param.num_samples_per_tree<<std::endl;
        ofs<<"____Patches Per Sample"<<std::endl;
        ofs<<param.num_patches_per_sample<<std::endl;
        ofs<<"____Face Size"<<std::endl;
        ofs<<param.norm_size<<std::endl;
        ofs<<"____Patch Size Ratio"<<std::endl;
        ofs<<boost::lexical_cast<float>(param.patch_width/boost::lexical_cast<float>(param.norm_size))<<std::endl;
        ofs<<"____Feature"<<std::endl;
        for(int i = 0; i < param.features.size(); i++){
          ofs<<param.features[i];
          if( (i+1) < param.features.size())
            ofs<<" ";
        }
        ofs<<std::endl;
        ofs<<"____split mode"<<std::endl;
        for(int i = 0; i < param.split_modes.size(); i++){
          ofs<<param.split_modes[i];
          if( (i+1) < param.split_modes.size())
            ofs<<" ";
        }
        ofs<<std::endl;
        ofs.close();
      }
      config_files.push_back(f_name);
    }
    return true;
}


bool adjust_maps_with_optical_flow(vector<Image>& samples,
                                    vector<vector<cv::Mat_<float> > >& voting_maps,
                                     vector<cv::Mat_<float> >& adjusted_voting_maps){
  int nImgs = samples.size();

  int centerIdx = 0; // first image in the vector is our current image that we want to process

  Mat cImg = samples[centerIdx].get_feature_channel(0);
  adjusted_voting_maps = voting_maps[centerIdx];

  for(unsigned int idx = 0; idx < samples.size(); idx++){
    if(idx == centerIdx){
      continue;
    }

    Mat flow, cflow;
    Mat img = samples[idx].get_feature_channel(0);
    calcOpticalFlowFarneback(cImg, img, flow, 0.5, 3, 15, 3, 5, 1.2, 0);
//    cvtColor(cImg, cflow, COLOR_GRAY2BGR);
//    drawOptFlowMap(flow, cflow, 10, 1, Scalar(0, 255, 0));
//    imshow("flow", cflow);
//    waitKey(0);


    // adjust voting maps
    std::vector<cv::Mat_<float> > voting_maps_idx = voting_maps[idx];

    for(unsigned int vIdx = 0; vIdx < adjusted_voting_maps.size(); vIdx++){
      for(int y = 0; y < flow.rows; y++){
        for(int x = 0; x < flow.cols; x++){
          Point2f fxy = flow.at<Point2f>(y, x);
          float val =  voting_maps_idx[vIdx].at<float>(y, x);
          adjusted_voting_maps[vIdx].at<float>(cvRound(y-fxy.y),cvRound(x-fxy.x)) += val;
        }
      }
    }
  }

}
void drawOptFlowMap(const Mat& flow, Mat& cflowmap, int step,
                    double, const Scalar& color)
{
    for(int y = 0; y < cflowmap.rows; y += step)
        for(int x = 0; x < cflowmap.cols; x += step)
        {
            const Point2f& fxy = flow.at<Point2f>(y, x);
            line(cflowmap, Point(x,y), Point(cvRound(x+fxy.x), cvRound(y+fxy.y)),
                 color);
            circle(cflowmap, Point(x,y), 2, color, -1);
        }
}


void _flip_parts_J9(Annotation& ann){
      cv::Point_<int> part;
      part = ann.parts[1];
      ann.parts[1] = ann.parts[2];
      ann.parts[2] = part;

      part = ann.parts[3];
      ann.parts[3] = ann.parts[4];
      ann.parts[4] = part;

      part = ann.parts[5];
      ann.parts[5] = ann.parts[7];
      ann.parts[7] = part;

      part = ann.parts[6];
      ann.parts[6] = ann.parts[8];
      ann.parts[8] = part;
}

void _flip_parts_J14(Annotation& ann){
      cv::Point_<int> part;
      part = ann.parts[2];
      ann.parts[2] = ann.parts[3];
      ann.parts[3] = part;

      part = ann.parts[4];
      ann.parts[4] = ann.parts[5];
      ann.parts[5] = part;

      part = ann.parts[6];
      ann.parts[6] = ann.parts[8];
      ann.parts[8] = part;

      part = ann.parts[7];
      ann.parts[7] = ann.parts[9];
      ann.parts[9] = part;

      part = ann.parts[10];
      ann.parts[10] = ann.parts[12];
      ann.parts[12] = part;

      part = ann.parts[11];
      ann.parts[11] = ann.parts[13];
      ann.parts[13] = part;
}

void flip_parts(Annotation& ann, body_pose::BodyPoseTypes pose_type){
    cv::Mat img = imread(ann.url);
    CHECK(img.data);

    for(int i = 0; i < ann.parts.size(); i++){
      ann.parts[i].x = img.cols - ann.parts[i].x - 1;
    }

    if(pose_type == body_pose::UPPER_BODY_J9){
      _flip_parts_J9(ann);
    }
    else if(pose_type == body_pose::FULL_BODY_J13){
      _flip_parts_J9(ann);
      cv::Point_<int> part;
      part = ann.parts[9];
      ann.parts[9] = ann.parts[11];
      ann.parts[11] = part;

      part = ann.parts[10];
      ann.parts[10] = ann.parts[12];
      ann.parts[12] = part;
    }
    else if(pose_type == body_pose::FULL_BODY_J14){
      _flip_parts_J14(ann);
    }

}

void keep_ann_of_cluster_ids(std::vector<Annotation>& org_annotations, std::vector<Annotation>& annotations,
                                  std::vector<int>& cluster_ids, bool add_flipped_ann)
  {
    for(unsigned int i=0; i<org_annotations.size(); i++){
      Annotation ann = org_annotations[i];
      int label = org_annotations[i].cluster_id;
      bool isPresent = (std::find(cluster_ids.begin(), cluster_ids.end(), label) != cluster_ids.end());

      if(isPresent){
        annotations.push_back(ann);

        if(add_flipped_ann){
          flip_parts(ann, body_pose::FULL_BODY_J13);
          annotations.push_back(ann);
        }
      }
    }
  }


int inline get_upperbody_size_piw(const std::vector<cv::Point> parts){

  if( parts[1].x < 0 || parts[2].x < 0){
    if(parts[2].x < 0){
      return std::sqrt( (parts[1].x-parts[3].x)*(parts[1].x-parts[3].x) +
        (parts[1].y-parts[3].y)*(parts[1].y-parts[3].y) );
    }
    else{
      return std::sqrt( (parts[2].x-parts[4].x)*(parts[2].x-parts[4].x) +
        (parts[2].y-parts[4].y)*(parts[2].y-parts[4].y) );
    }
  }
  else{
    cv::Point hip_center;
    hip_center.x = (parts[4].x+ parts[3].x) /2;
    hip_center.y = (parts[4].y+ parts[3].y) /2;
    cv::Point shoulder_center;
    shoulder_center.x = (parts[2].x+ parts[1].x) /2;
    shoulder_center.y = (parts[2].y+ parts[1].y) /2;
    return std::sqrt( (hip_center.x-shoulder_center.x)*(hip_center.x-shoulder_center.x) +
      (hip_center.y-shoulder_center.y)*(hip_center.y-shoulder_center.y) );
  }
}

int visualize_normalized_annotations(std::vector<Annotation>& annotations,
                                body_pose::BodyPoseTypes pose_type)
{
  int size = 500;
  cv::Mat img(size,size,CV_8UC3, cv::Scalar(255,255,255));

  for(unsigned int i=0; i<annotations.size(); i++){
    Annotation ann = annotations[i];
    cv::Point head_loc = ann.parts[0];
    LOG(INFO)<<i<<": "<<ann.url;

    // normalizing w-r-t head/nose location
    cv::Point diff = cv::Point(size/2,size/2) - head_loc;
    for(unsigned int j=0; j<ann.parts.size(); j++){
      ann.parts[j] += diff;
    }
    plot(img, ann.parts, pose_type);
  }
  imshow("poses", img);
  cv::waitKey(0);
}

int visualize_normalized_annotations(std::string path,
                                body_pose::BodyPoseTypes pose_type)
{
  std::vector<Annotation> annotations;
  load_annotations(annotations, path);
  visualize_normalized_annotations(annotations, pose_type);
}

void getAnnotationsWithClusterId(std::vector<Annotation>& org_annotations, std::vector<Annotation>& annotations,
                                std::vector<int>& clusterIds,
                                body_pose::BodyPoseTypes pose_type,
                                 bool add_flipped_annotations)
{
  for(unsigned int i=0; i<org_annotations.size(); i++){
    Annotation ann = org_annotations[i];
    int cluster_id = org_annotations[i].cluster_id;
    bool isPresent = (std::find(clusterIds.begin(), clusterIds.end(), cluster_id) != clusterIds.end());

    if(isPresent){
      //LOG(INFO)<<cluster_id;
      annotations.push_back(ann);
      if(add_flipped_annotations){
        ann.flipped = true;
        flip_parts(ann, pose_type);
        annotations.push_back(ann);
      }
    }
  }
}

