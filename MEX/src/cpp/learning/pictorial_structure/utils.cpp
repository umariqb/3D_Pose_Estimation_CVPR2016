/*
 * utils.cpp
 *
 *  Created on: Apr 3, 2013
 *      Author: mdantone
 */
/*
 * utils.hpp
 *
 *  Created on: Jan 21, 2013
 *      Author: mdantone
 */

#ifndef PS_UTILS_HPP_
#define PS_UTILS_HPP_

#include <glog/logging.h>
#include "opencv2/core/core.hpp"

#include <vector>
#include "cpp/learning/pictorial_structure/part.hpp"
#include "cpp/learning/pictorial_structure/utils.hpp"
#include "cpp/learning/pictorial_structure/model.hpp"
#include "cpp/learning/pictorial_structure/learn_model_parameter.hpp"
#include "cpp/learning/pictorial_structure/math_util.hpp"
#include "cpp/third_party/kmeans/kmeans.hpp"

namespace learning
{
namespace ps
{
namespace utils
{
const double PI = 3.14159;


float pos_angle( float a ) {
  if( a < 0 ){
    float pos_a = a + ((abs(static_cast<int>(a))/360.0+1)*360.0 );
    return pos_a;
  }else{
    return a;
  }

}
float get_angle(cv::Point point ) {
  float angle =  atan2(point.y, point.x);
  if(angle == 0 ){
    return 0;
  }
  angle += PI/2;
  angle *= (180.0/PI);
  return pos_angle(angle);
}

cv::Point_<float> get_point(float angle, int norm ) {
  angle /= 180.0 /PI;
  angle -= PI/2.0;
  cv::Point_<float> p(norm*cos( angle ), norm*sin( angle ) );
  return p;
}


// returns offset normalized with respect to parent
cv::Point get_offset_normalized( cv::Point part, cv::Point parent, cv::Point grand ) {

  cv::Point offset = part-parent;
  cv::Point offset_parent = grand-parent;

  float angle_part =  get_angle(offset);
  float angle_parent =  get_angle(offset_parent);

  float angle = pos_angle(angle_part-angle_parent);
  int l = cv::norm(offset);
  cv::Point p = get_point(angle, l);
  return p;
}


void get_orient_hist( const std::vector< cv::Point_<float> >& offsets,
    const std::vector<cv::Point>& shifts,
    std::vector<float>& weights,
    std::vector<int>& labels, bool debug) {

  weights.resize(shifts.size(), 0);
  for(int i=0; i < offsets.size(); i++) {
    const cv::Point& offset = offsets[i];

    int min_index = 0;
    float min_dist = dist(offset, shifts[0]);
    for(int j=1; j < shifts.size(); j++) {
      float d = dist(offset, shifts[j]);
      if(d < min_dist) {
        min_dist = d;
        min_index = j;
      }
    }
    weights[min_index] ++;
    labels.push_back(min_index);
    if(debug ){
      cv::Mat img(200, 200, CV_8UC3, cv::Scalar(0,0,0));
      cv::Point center(img.cols/2, img.rows/2);
      cv::circle(img, center, 2, cv::Scalar(255, 0, 255), -1 );
      for(int i=0; i < shifts.size(); i++) {
        cv::circle(img, cv::Point(shifts[i].x+100,shifts[i].y+100), 3, cv::Scalar(255, 50, 0), -1 );
      }

      cv::circle(img, cv::Point(shifts[min_index].x+100,shifts[min_index].y+100), 3, cv::Scalar(255,0 , 255), -1 );

      cv::circle(img, offset+center, 3, cv::Scalar(255, 0, 255), -1 );
      cv::circle(img, center, 3, cv::Scalar(255, 0, 255), -1 );
      line(img, offset+center, center, cv::Scalar(255, 50, 0), 2);

      cv::imshow("model", img);
      cv::waitKey(0);
    }


  }
}


void transform_offsets( const std::vector<cv::Point_<float> >& offsets,
           std::vector<cv::Point_<float> >& offsets_transformed, bool plot = false) {
  cv::Point_<float> mean_offset;
  float mean_norm = 0;
  calculate_mean(offsets, &mean_offset, &mean_norm);

  offsets_transformed.resize(offsets.size());
  for(int i=0; i < offsets.size(); i++) {
    offsets_transformed[i] = get_point(get_angle(offsets[i]), -mean_norm );
    offsets_transformed[i].x += offsets[i].x;
    offsets_transformed[i].y += offsets[i].y;

//    offsets_transformed[i].x = offsets[i].x;
//    offsets_transformed[i].y = offsets[i].y;
//    offsets_transformed[i].x -= mean_offset.x;
//    offsets_transformed[i].y -= mean_offset.y;
  }

  if(plot) {
    cv::Mat img(500, 500, CV_32FC1, cv::Scalar(0));
    cv::Point_<float> center(img.cols/2, img.rows/2);
    for(int i=0; i < offsets_transformed.size(); i++) {
      img.at<float>(center+offsets_transformed[i]) += 0.25;
    }
//    cv::blur(img, img, cv::Size(3,3));
    normalize(img, img, 0, 1, CV_MINMAX);
    cv::imshow("x", img);
    cv::waitKey(0);
  }
}


void estimate_covariance_matrix( const std::vector<cv::Point_<float> >& offsets,
    cv::Mat& covar, cv::Mat& mean) {

  std::vector<cv::Point_<float> > offsets_transformed;
  transform_offsets(offsets, offsets_transformed, false);

  cv::Mat_<float> samples(offsets_transformed.size(), 2);
  for(int i=0; i < offsets_transformed.size(); i++) {
    samples(i,0) = offsets_transformed[i].x;
    samples(i,1) = offsets_transformed[i].y;
  }


  cv::calcCovarMatrix(samples, covar, mean,
      CV_COVAR_NORMAL|CV_COVAR_ROWS|CV_COVAR_SCALE, CV_32F);

//  LOG(INFO) << "covar: ";
//  std::cout << covar << std::endl;
//  LOG(INFO) << "mean " << mean;
//  cv::Mat w, u, vt;
//  cv::SVD::compute(covar, w, u , vt);
//  LOG(INFO) << "w: "<< w;
//  LOG(INFO) << "u: "<< u;
//  LOG(INFO) << "vt: "<< vt;

}

void visualize_clusters(const std::vector<cv::Point_<float> >& offsets,
    cv::Mat centers, cv::Mat best_labels, int part_id) {

  int size = 500;
  cv::Mat img(size,size,CV_8UC3, cv::Scalar(255,255,255));
  std::vector<cv::Scalar> colors;
  colors.push_back( cv::Scalar(6,189,54));
  colors.push_back( cv::Scalar(232,74,26));
  colors.push_back( cv::Scalar(50,50,232));
  colors.push_back( cv::Scalar(237,230,17));
  colors.push_back( cv::Scalar(255, 100, 100));
  colors.push_back( cv::Scalar(0, 100, 50));
  colors.push_back( cv::Scalar(0, 255, 100));
  colors.push_back( cv::Scalar(50, 50, 50));
  colors.push_back( cv::Scalar(50, 255, 0));

  cv::Point_<float> center(size/2,size/2);
  cv::circle(img, center, 2, cv::Scalar(0,0, 0),-1);

  for(int i=0; i < offsets.size(); i++) {
    int cluster_id =  best_labels.at<int>(0,i);
    cv::circle(img, offsets[i]+center, 1, colors[cluster_id],-1);
  }
//  LOG(INFO) << "mean: " << centers;
  int n_clusters = centers.rows;
  std::string f_name(boost::str(boost::format("/home/mdantone/public_html/share/leed/clusters/parts/cluster_fashion_rot_%1%_%2%.jpg" ) % n_clusters % part_id));
//  cv::imwrite(f_name, img);
//  LOG(INFO) << f_name;
  cv::imshow("x", img);
  cv::waitKey(0);

}


void visualize_offsets(const std::vector<cv::Point_<float> >& offsets) {

  cv::Mat img(400, 400, CV_32FC1, cv::Scalar(0,0,0));

  cv::Point_<float> center(200,200);
  for(int i=0; i < offsets.size(); i++) {
    img.at<float>(offsets[i]+center) += 0.1;
    std::cout<<offsets[i].x<<"  "<<offsets[i].y<<std::endl;
  }
  normalize(img, img, 0, 1, CV_MINMAX);

  cv::Mat img_color;
  img.convertTo(img_color, CV_8U, 255);
  cvtColor(img_color, img_color, CV_GRAY2RGB);

  cv::Point_<float> mean_offset;
  float mean_norm = 0;
  calculate_mean(offsets, &mean_offset, &mean_norm);
  std::cout<<mean_offset.x<<"  "<<mean_offset.y<<std::endl;
  cv::circle(img_color, mean_offset+center, 2, cv::Scalar(255, 0, 255), -1 );
  cv::circle(img_color, center, 2, cv::Scalar(0, 0, 255), -1 );

  cv::imshow("offsets", img_color);
  cv::waitKey(0);

}

void clean_annotations(const std::vector< std::vector<cv::Point> >& annotations_org,
    std::vector< std::vector<cv::Point> >& annotations) {
  for(int i=0; i < annotations_org.size(); i++) {
    bool all_parts_present = true;
    for(int j=0; j  < annotations_org[i].size(); j++) {
      const cv::Point p = annotations_org[i][j];
      if(p.x < 0 || p.y < 0 ) {
        all_parts_present = false;
      }
    }
    if(all_parts_present) {
      annotations.push_back(annotations_org[i]);
    }
  }
}

void create_histogram(const std::vector<int>& labels, std::vector<int>& hist){
  for(int i=0; i< labels.size(); i++){
    int l = labels[i];
    if(l >= hist.size()) {
      hist.resize(l+1, 0);
    }
    hist[labels[i]]++;
  }
}

//void knn_clustering(cv::Mat features, int n_clusters, cv::Mat best_labels,
//    cv::Mat centroids, int min_sampels ) {
//  cv::TermCriteria term_criteria;
//  term_criteria.epsilon = 1;
//  term_criteria.maxCount = 10;
//  term_criteria.type = cv::TermCriteria::MAX_ITER | cv::TermCriteria::EPS;
//  cv::BOWKMeansTrainer bow_trainer( n_clusters, term_criteria, 3, cv::KMEANS_PP_CENTERS );
//  cv::Mat centers;
//  cv::RNG& rng = cv::theRNG();
//  rng.state = 1;
//  cv::kmeans(features, n_clusters, best_labels, term_criteria, 3, cv::KMEANS_PP_CENTERS, centers);
//
//  // check if all clusters are bigger than min_sampels, otherwise delete one cluster and continue
//  while(true) {
//
//  }
//
//}

bool get_displacement_cost(
    const std::vector< std::vector<cv::Point> >& annotations_org,
    const std::vector<int>& parents,
    std::vector<Displacement>& displacements,
    std::vector<JointParameter> params,
    std::vector<double> weights) {

  // clean annotations; check if all parts are presents
  std::vector< std::vector<cv::Point> > annotations;
  clean_annotations( annotations_org, annotations);

  if(weights.size()){
    CHECK_EQ(weights.size(), annotations.size());
  }

  std::vector< std::vector<int> > cluster_assignments(parents.size());

  bool normalize_with_respect_to_partent = false;

  for(int i_part =0; i_part < parents.size(); i_part++) {
    std::vector< cv::Point_<float> > offsets_per_part;
//    std::cout<<"Part-id = "<<i_part<<std::endl;
    for(int i=0; i < annotations.size(); i++) {
      int parents_id = parents[i_part];
      int parents_parents_id = parents[parents_id];
//      std::cout<<"Parent-id = "<<parents_id<<"   "<<"Parents_parent-id = "<<parents_parents_id<<std::endl;
      parents_parents_id = parents_id;

      const cv::Point& part = annotations[i][i_part];
//      std::cout<<"Part = "<<part.x<<" "<<part.y<<" ";
      const cv::Point& parent = annotations[i][parents_id];
//      std::cout<<"Parent = "<<parent.x<<" "<<parent.y<<" ";
      const cv::Point& parents_parents = annotations[i][parents_parents_id];
//      std::cout<<"Parents_parent = "<<parents_parents.x<<" "<<parents_parents.y<<" ";

      cv::Point offset;
      if(normalize_with_respect_to_partent) {
        offset = get_offset_normalized(part, parent, parents_parents);
      }else{
        offset = part - parent;
      }

//      std::cout<<"Offset = "<<offset.x<<" "<<offset.y<<std::endl;
      //CHECK_LT(offset.x, 210);
      //CHECK_LT(offset.y, 210);

      offsets_per_part.push_back(offset);
    }
//    std::cout<<i_part<<std::endl<<std::endl;
//    utils::visualize_offsets(offsets_per_part);


    Displacement displacement;
    if(i_part > 0) {

      if(params[i_part].joint_type == ROT_GAUSS) {
        cv::Point_<float> mean_offset;
        float mean_l = 0;
        calculate_mean(offsets_per_part, &mean_offset, &mean_l);

        float mean_angle = get_angle( mean_offset);


        int num_rotations = params[i_part].num_rotations;
        std::vector<cv::Point > shifts;
        for (int i=0; i < num_rotations; i++){
          float angle = (360.0) / num_rotations * i;
          angle += mean_angle;
          cv::Point p = get_point(angle, mean_l);
          shifts.push_back(p);
        }

        std::vector<float> orientation_hist;
        get_orient_hist( offsets_per_part, shifts, orientation_hist, cluster_assignments[i_part], false);

        // only use used orientations
        for (int i=0; i < orientation_hist.size(); i++){
          if( (orientation_hist[i]) > 0 || (params[i_part].use_weights == false) ) {
            displacement.shifts.push_back(shifts[i]);
          }
        }

//        LOG(INFO) << i_part << " " <<  displacement.shifts.size() << " of " <<  orientation_hist.size() << " orientation used.";


        CHECK_GT(displacement.shifts.size(), 0);
        orientation_hist.clear();
        cluster_assignments[i_part].clear();
        get_orient_hist( offsets_per_part, displacement.shifts, orientation_hist, cluster_assignments[i_part], false);

        cv::Mat covar;
        cv::Mat mean;
        estimate_covariance_matrix(offsets_per_part, covar, mean);

        float f_x_a = 50;
        float f_y_b = 50;
        if(offsets_per_part.size() > 0 ) {
          f_x_a = MIN(2.0 / covar.at<float>(0,0), f_x_a );
          f_y_b = MIN(2.0 / covar.at<float>(1,1), f_y_b );
        }

        Quadratic fx(2.0 / f_x_a, 0);
        Quadratic fy(2.0 / f_y_b, 0);

        displacement.cost_functions_x.resize(displacement.shifts.size(), fx);
        displacement.cost_functions_y.resize(displacement.shifts.size(), fy);
//        LOG(INFO) << i_part << ") sifts: "<<  displacement.shifts.size() ;


        if(false) {
          cv::Mat centers = cv::Mat( num_rotations,2, CV_32FC1);
          cv::Mat best_labels = cv::Mat::zeros(1, offsets_per_part.size(),
              cv::DataType<int>::type);

          for (int i=0; i < offsets_per_part.size(); i++){
            best_labels.at<int>(0,i) =  cluster_assignments[i_part][i];
          }
          visualize_clusters(offsets_per_part, centers, best_labels, i_part );
        }

      }else if(params[i_part].joint_type == CLUSTER_GAUSS){

        int n_clusters = params[i_part].num_rotations;

        cv::Mat best_labels;
        cv::Mat centers;

        if(!params[i_part].use_ann_weights){
          cv::Mat features(cv::Size(2,offsets_per_part.size()),CV_32FC1);
          for(int i=0; i < offsets_per_part.size(); i++) {
            features.at<float>(i,0) = offsets_per_part[i].x;
            features.at<float>(i,1) = offsets_per_part[i].y;
          }
          cv::TermCriteria term_criteria;
          term_criteria.epsilon = 1;
          term_criteria.maxCount = 10;
          term_criteria.type = cv::TermCriteria::MAX_ITER | cv::TermCriteria::EPS;
          cv::BOWKMeansTrainer bow_trainer( n_clusters, term_criteria, 3, cv::KMEANS_PP_CENTERS );
          cv::RNG& rng = cv::theRNG();
          rng.state = 1;
          cv::kmeans(features, n_clusters, best_labels, term_criteria, 3, cv::KMEANS_PP_CENTERS, centers);
        }
        else{   // using weighted kmeans
          double features[2*offsets_per_part.size()];
          double cluster_center[2*n_clusters];
          std::memset(cluster_center, 0, sizeof(cluster_center));
          int cluster_pop[n_clusters];
          double cluster_eng[n_clusters];
          int cluster_ids[offsets_per_part.size()];
          for(int i=0; i<offsets_per_part.size();i++){
            features[2*i+0] = offsets_per_part[i].x;
            features[2*i+1] = offsets_per_part[i].y;
          }

          int it_num = 0;
          kmeans_w_03(2, static_cast<int>(offsets_per_part.size()), n_clusters, 20, it_num,
                       features, &weights.front(), cluster_ids, cluster_center, cluster_pop, cluster_eng);
          best_labels = cv::Mat(offsets_per_part.size(), 1, CV_32S, &cluster_ids);
          centers = cv::Mat(n_clusters, 2, CV_64F, &cluster_center);
          centers.convertTo(centers, CV_32F);
        }
//        calculate_centroids(features, n_clusters, best_labels, centers, params[i_part].min_sampels );
//        visualize_clusters(offsets_per_part, centers, best_labels, i_part );


        for(int i=0; i < offsets_per_part.size(); i++) {
          cluster_assignments[i_part].push_back(best_labels.at<int>(i,0));
        }

        for(int i=0; i < n_clusters; i++) {
          cv::Point centroid(centers.at<float>(i,0), centers.at<float>(i,1));
          std::vector<cv::Point_<float> > offsets;
          CHECK_EQ(offsets_per_part.size(), best_labels.rows);
          for(int j=0; j < offsets_per_part.size(); j++) {
            if(  best_labels.at<int>(j,0) == i) {
              offsets.push_back(offsets_per_part[j]);
            }
          }

          if(offsets.size() >  params[i_part].min_sampels ) {

            CHECK_GT(offsets.size(), 0);
            cv::Mat covar;
            cv::Mat mean;
            estimate_covariance_matrix(offsets, covar, mean);

            if(false) {
              LOG(INFO)<<i_part;
              cv::Mat labels(1,offsets.size(), best_labels.type(), cv::Scalar(0));
              visualize_clusters(offsets, mean, labels, i );
              LOG(INFO) <<  "mean: "<< mean << ", n: " << offsets.size();
            }

            float f_x_a = 50;
            float f_y_b = 50;
            if(offsets.size() > 0 ) {
              f_x_a = MIN(2.0 / covar.at<float>(0,0), f_x_a );
              f_y_b = MIN(2.0 / covar.at<float>(1,1), f_y_b );
            }

            Quadratic fx(2.0 / f_x_a, 0);
            Quadratic fy(2.0 / f_y_b, 0);

            if(params[i_part].use_weights) {
              float prob = offsets.size() / static_cast<float> (annotations.size());
              float w = -log(prob) * params[i_part].weight_alpha;
              //float w = 0.5f * log(determinant(covar));
              displacement.weights.push_back(w);
            }else{
              displacement.weights.push_back(0);
            }
            displacement.cost_functions_x.push_back(fx);
            displacement.cost_functions_y.push_back(fy);
            displacement.shifts.push_back(centroid);

          }
        }
      }
    }else{
      cluster_assignments[0].resize(annotations.size(),0);
      displacement.shifts.push_back(cv::Point(0,0));
      displacement.cost_functions_x.push_back(Quadratic(0.1,0));
      displacement.cost_functions_y.push_back(Quadratic(0.1,0));
      displacement.weights.push_back(0);
    }
    displacements.push_back( displacement );

  }

  // calculate weights
//  std::vector<std::vector<int> > hist_clusters;
//  int n_samples = annotations.size();
//  for(int i_part =0; i_part < parents.size(); i_part++) {
//    CHECK_EQ(cluster_assignments[i_part].size(), n_samples );
//
//    std::vector<int> hist(displacements[i_part].shifts.size(),0);
//    create_histogram(cluster_assignments[i_part], hist);
//
//    float sum_w = 0;
//    for(int i_cluster=0; i_cluster < hist.size(); i_cluster++) {
//      if(params[i_part].use_weights) {
//        CHECK_GT(hist[i_cluster], 0);
//
//        float prob = hist[i_cluster] / static_cast<float> (n_samples);
//        float w = -log(prob) * params[i_part].weight_alpha;
//        sum_w += w;
//        displacements[i_part].weights.push_back(w);
//      }else{
//        displacements[i_part].weights.push_back(0);
//      }
//    }
//
//    // zero sum weights
//    if(params[i_part].use_weights and params[i_part].zero_sum_weights) {
//
//      float norm_weight = sum_w / hist.size();
//      float check = 0;
//      for(int i_cluster=0; i_cluster < hist.size(); i_cluster++) {
//        displacements[i_part].weights[i_cluster] -= norm_weight;
//        check += displacements[i_part].weights[i_cluster];
//      }
//    }
//    hist_clusters.push_back(hist);
//  }


  CHECK_EQ(displacements.size(), parents.size() );
  for(int i_part =0; i_part < parents.size(); i_part++) {
    CHECK_EQ(displacements[i_part].shifts.size(), displacements[i_part].weights.size() );
    CHECK_EQ(displacements[i_part].cost_functions_x.size(), displacements[i_part].cost_functions_y.size() );
    CHECK_EQ(displacements[i_part].shifts.size(), displacements[i_part].cost_functions_x.size() );
    if( displacements[i_part].shifts.size() == 0 ) {
      return false;
    }
  }

  return true;
}

} // namespace util

} //namespace ps

} //namespace learning



#endif /* PS_UTILS_HPP_ */




