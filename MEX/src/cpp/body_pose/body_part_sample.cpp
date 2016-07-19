/*
 * body_part_sample.cpp
 *
 *  Created on: Jan 6, 2013
 *      Author: mdantone
 */

#include "body_part_sample.hpp"
#include "cpp/learning/forest/utils/eval_utils.hpp"
#include "cpp/learning/forest/part_sample.hpp"
#include "cpp/utils/string_utils.hpp"

using namespace cv;
using namespace std;
using namespace learning::forest;


double BodyPartSample::eval(const std::vector<BodyPartSample*>& set_a,
    int split_mode, const std::vector<float>& class_weights){
  if(split_mode == 0) {
   return entropie_pos_vs_neg(set_a, class_weights);
  }else if(split_mode == 1) {
    return entropie_label(set_a, class_weights);
  }else if(split_mode == 2){
    return entropie_label_with_neg(set_a, class_weights);
  }else if(split_mode == 3){
    return neg_sum_squared_difference(set_a);
  }else{
    CHECK(false);
    return 0;
  }
}

double BodyPartSample::entropie_label_with_neg(const std::vector<BodyPartSample*>& set,
  const std::vector<float>& class_weights) {
  int num_pos_classes =  class_weights.size() -1;
  if( num_pos_classes < 2){
    return entropie_pos_vs_neg(set, class_weights);
  }

  vector<int> hist;
  int pos_samples = calculate_label_hist(set, hist,  GetLabelFunction(), num_pos_classes );
  int num_samples = set.size();

  // entropy classes
  double entropy_labels = 0;
  for(unsigned int i=0; i < hist.size(); i++){
    double p = static_cast<float>(hist[i]) / pos_samples;
    if (p > 0) {
      entropy_labels += p * log(p) * class_weights[i+1];
    }
  }



  // entropy pos vs neg
  double entropy_pos_neg = 0;
  double p = pos_samples / static_cast<double>(num_samples );
  if (p > 0)
    entropy_pos_neg += (p * log(p));

  double alpha = 0;
  if(hist.size() > 1) {
    alpha = 1.0/static_cast<double>(num_pos_classes);
  }
  alpha = 1;
  double r = entropy_labels*alpha + entropy_pos_neg;
  return r;
}

double BodyPartSample::entropie_label(const std::vector<BodyPartSample*>& set,
  const std::vector<float>& class_weights) {

  vector<int> hist;
  int pos_samples = calculate_label_hist(set, hist, GetLabelFunction());

  double n_entropy = 0;
  for(unsigned int i=0; i < hist.size(); i++){
    double p = static_cast<float>(hist[i]) / pos_samples;
    if (p > 0)
      n_entropy += p * log(p);
  }

  return n_entropy;
}


void BodyPartSample::create_leaf(Leaf& leaf,
    const std::vector<BodyPartSample*>& set,
    const std::vector<float>& class_weights,
    int leaf_id) {

  bool print = (leaf.num_samples == 0);
  leaf.num_samples = set.size();
  leaf.class_hist.clear();
  leaf.global_attr_hist.clear();
  leaf.global_attr_offsets.clear();


  int num_pos_classes =  class_weights.size()-1;
  int pos = 0;
  if(num_pos_classes > 1) {
    pos = calculate_label_hist(set, leaf.class_hist, GetLabelFunction(), num_pos_classes );
  }else{
    pos = count_pos_samples(set);
  }

  float weight = 1.0;
  if ( class_weights.size() > 0 )
    weight = class_weights[0];

  double num_pos = static_cast<double>(pos);
  double num_neg = static_cast<double>(set.size() - pos);
  leaf.forground = num_pos / (num_neg*weight + num_pos );


  if(print) {
    LOG(INFO) << "num_pos : " << pos <<  ", ratio : " << leaf.forground << ", samples: " << leaf.num_samples;
    if(leaf.class_hist.size() > 1 ){
      LOG(INFO) << "class hist: " << ::utils::VectorToString(leaf.class_hist);
    }
  }

  cv::Point_<int> mean;
  double ssd;
  int n_pos_samples = PartSample::sum_of_square_diff(set, &mean, &ssd);
  leaf.offset = mean;
  leaf.variance = static_cast<float>(ssd);

  // calculating offsets w-r-t the values of global attributes
  calculate_label_hist(set, leaf.global_attr_hist, GetGlobalAttrLabelFunction());
  LOG(INFO)<<"ATTR LABEL HIST = "<<::utils::VectorToString(leaf.global_attr_hist);
  leaf.global_attr_offsets.resize(leaf.global_attr_hist.size());
  leaf.global_attr_variance.resize(leaf.global_attr_hist.size());
  for(unsigned int i=0;  i<leaf.global_attr_hist.size(); i++){
    std::vector<BodyPartSample*> tmpSet;
    for(unsigned int j = 0; j < set.size(); j++){
        if(set[j]->global_attr_label == i){
            tmpSet.push_back(set[j]);
        }
    }
    cv::Point_<int> mean;
    double ssd;
    PartSample::sum_of_square_diff(tmpSet, &mean, &ssd);
    leaf.global_attr_offsets[i] = mean;
    leaf.global_attr_variance[i] = static_cast<float>(ssd);
  }

  CHECK(n_pos_samples == pos );
  // if we have only a binary problem, than we don't need the class histogram
  if(num_pos_classes < 2 ){
    leaf.class_hist.clear();
  }
  CHECK(leaf.num_samples > 0 );
}



void BodyPartSample::get_class_weights(std::vector<float>& class_weights,
    const std::vector<BodyPartSample*>& set) {

  vector<int> class_hist;
  int n_pos_samples = calculate_label_hist(set, class_hist, GetLabelFunction());

  class_weights.resize(1);

  if(set.size() == n_pos_samples) {
    class_weights[0] = 1;
  }else{
    class_weights[0] = n_pos_samples / static_cast<float>(set.size() - n_pos_samples);
  }

  LOG(INFO) << "pos samples: " << n_pos_samples  << std::endl;
  LOG(INFO) << "neg samples: " << set.size() - n_pos_samples <<  std::endl;
  LOG(INFO) << "positive to negative ratio: " << class_weights[0] << std::endl;
  LOG(INFO) << "number of pos labels: " << class_hist.size() << std::endl;
  LOG(INFO) << "class histogramm (patches): " << ::utils::VectorToString(class_hist);

  if( class_hist.size() > 1 ) {
    for(unsigned int i=0; i < class_hist.size(); i++) {
      float class_freq = class_hist[i] / static_cast<float>(n_pos_samples);
      LOG(INFO) << i << ": " << class_hist[i] <<
          ", freq: " << class_hist[i] / static_cast<float>(n_pos_samples) <<
          ", inv class freq: " << 1 - class_hist[i] / static_cast<float>(n_pos_samples);
//      class_weights.push_back( class_hist[i] );
      class_weights.push_back( 1 - class_freq );
    }
  }
  LOG(INFO) << "class weights: " << ::utils::VectorToString(class_weights);
}

void  BodyPartSample::show() {
  cv::imshow("sample", get_feature_channel(0)(roi));
  cv::Mat img = get_feature_channel(0).clone();

  int x = roi.x + roi.width/2 + offset.x;
  int y = roi.y + roi.height/2  + offset.y;

  cv::circle(img, cv::Point_<int>(x, y), 3, cv::Scalar(255, 255, 255, 0), -1);

  cv::rectangle(img, roi, cv::Scalar(255, 255, 255, 0));
  cv::imshow("image", img);
  cv::waitKey(0);
}
