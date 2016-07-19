/*
 * body_part_sample.hpp
 *
 *  Created on: Jan 6, 2013
 *      Author: mdantone
 */

#ifndef BODY_PART_SAMPLE_HPP_
#define BODY_PART_SAMPLE_HPP_

#include "cpp/learning/forest/svn_split.hpp"
#include "cpp/learning/forest/simple_split.hpp"
#include "cpp/vision/features/simple_feature.hpp"
#include "cpp/learning/common/image_sample.hpp"
#include "cpp/learning/forest/part_sample.hpp"


class BodyPartSample :public learning::forest::PartSample, public learning::common::ImageSample {
public:

//  typedef learning::forest::ThresholdSplit<learning::forest::SimplePatchFeature> Split;
  typedef learning::forest::ThresholdSplit<vision::features::PixelComparisonFeature> Split;
  typedef learning::forest::ClassAndRegressionLeaf Leaf;

  BodyPartSample(){};

  BodyPartSample(const learning::common::Image* patch,
                cv::Rect roi,
                bool is_pos,
                cv::Point_<int> offset_,
                int label_ = -1,
                int global_attr_label_ = -1):

    PartSample(offset_), learning::common::ImageSample(patch, roi), label(label_), global_attr_label(global_attr_label_) {

  }

  BodyPartSample(const learning::common::Image* patch,
                cv::Rect roi,
                bool is_pos,
                cv::Point_<int> offset_,
                int label_ = -1 ):
    PartSample(offset_), learning::common::ImageSample(patch, roi), label(label_) {
  }


  BodyPartSample(const learning::common::Image* patch,
                cv::Rect roi,
                bool is_pos,
                int label_ = -1,
                int global_attr_label_ = -1):
    PartSample(is_pos), learning::common::ImageSample(patch, roi), label(label_), global_attr_label(global_attr_label_) {
  }

  BodyPartSample(const learning::common::Image* patch,
                cv::Rect roi,
                bool is_pos,
                int label_ = -1):
    PartSample(is_pos), learning::common::ImageSample(patch, roi), label(label_) {
  }


  BodyPartSample(const learning::common::Image* patch, cv::Rect roi):
    PartSample(true), learning::common::ImageSample(patch, roi),  label(-1) {
  }

  template <typename F>
  static int calculate_label_hist(const std::vector<BodyPartSample*>& set,
                                  std::vector<int>& hist,
                                  F norm_function,
                                  int num_classes = -1 );

  static double eval(const std::vector<BodyPartSample*>& set,
                      int splitMode,
                      const std::vector<float>& class_weights);

  static double entropie_label(const std::vector<BodyPartSample*>& set,
                               const std::vector<float>& class_weights);

  static double entropie_label_with_neg(const std::vector<BodyPartSample*>& set,
                                        const std::vector<float>& class_weights);

  static void generateSplit(const std::vector<BodyPartSample*>& data,
                            int patch_width,
                            int patch_height,
                            int min_child_size,
                            int split_mode,
                            int depth,
                            const std::vector<float> class_weights,
                            int split_id,
                            Split* split) {
    generate_split(data, patch_width, patch_height, min_child_size, split_mode, depth, class_weights, split_id, split);
  }

  template <typename F>
  static void generate_split(const std::vector<BodyPartSample*>& data,
                              int patch_width,
                              int patch_height,
                              int min_child_size,
                              int split_mode,
                              int depth,
                              const std::vector<float> class_weights,
                              int split_id,
                              learning::forest::SVNSplit<F>* split);

  template <typename F>
  static void generate_split(const std::vector<BodyPartSample*>& data,
                            int patch_width,
                            int patch_height,
                            int min_child_size,
                            int split_mode,
                            int depth,
                            const std::vector<float> class_weights,
                            int split_id,
                            learning::forest::ThresholdSplit<F>* split);

  static void create_leaf(Leaf& leaf,
                          const std::vector<BodyPartSample*>& set,
                          const std::vector<float>& class_weights,
                          int leaf_id = 0);

  static void get_class_weights(std::vector<float>& class_weights,
      const std::vector<BodyPartSample*>& set);

  template <typename F>
  void extract(const F* feature,
    std::vector<float>& desc)  const {
    feature->extract( get_feature_channels(), get_roi(), desc);

  }

  int inline get_label() const {
    return label;
  }

  int inline get_global_attr_label() const {
    return global_attr_label;
  }

  void show();

  virtual ~BodyPartSample() {};

private:
  int label;
  int global_attr_label;
};

struct GetLabelFunction {
  inline int operator()(const BodyPartSample* s) const {
    return s->get_label();
  }
};

struct GetGlobalAttrLabelFunction{
  inline int operator()(const BodyPartSample* s) const {
    return s->get_global_attr_label();
  }
};

struct IsPosSampleFunction {
  inline int operator()(const learning::forest::Sample* s) const {
    if( s->is_pos()){
      return 1;
    }else{
      return 0;
    }
  }
};

struct GetLabelFunctionWithNeg{
  inline int operator()(const BodyPartSample* s) const {
    return s->get_label()+1;
  }
};


template <typename F>
void BodyPartSample::generate_split(const std::vector<BodyPartSample*>& data,
                                    int patch_width,
                                    int patch_height,
                                    int min_child_size,
                                    int split_mode,
                                    int depth,
                                    const std::vector<float> class_weights,
                                    int split_id,
                                    learning::forest::SVNSplit<F>* split){

    int seed = abs(split_id + 1) * abs(depth+1)* data.size();
    boost::mt19937 rng(seed);
    // generate the split
    int num_feat_channels = data[0]->get_images().size();
    F f;
    f.generate(patch_width, patch_height, &rng, num_feat_channels);
    split->set_feature(f);

    utils::liblinear::solver_type::T solver = utils::liblinear::solver_type::L2R_LR;

    if(split_mode == 0) {
      split->train(data, IsPosSampleFunction(), &rng, solver);
    }else if(split_mode == 1){
      split->train(data, GetLabelFunction(), &rng, solver);
    }else if(split_mode == 2){
      split->train(data, GetLabelFunctionWithNeg(), &rng, solver);
    }else{
      LOG(INFO) << "wrong split-mode: " << std::endl;
      assert(false);
    }
    split->evaluate(data, class_weights, split_mode, depth, min_child_size);

  }

template <typename F>
void BodyPartSample::generate_split(const std::vector<BodyPartSample*>& data,
                                    int patch_width,
                                    int patch_height,
                                    int min_child_size,
                                    int split_mode,
                                    int depth,
                                    const std::vector<float> class_weights,
                                    int split_id,
                                    learning::forest::ThresholdSplit<F>* split) {

  boost::mt19937 rng(abs(split_id + 1) * (depth+1)* data.size());
  // generate the split
  int num_feat_channels = data[0]->get_images().size();

  int num_thresholds = 40;
  int margin = 0;
  split->initialize(&rng, patch_width, patch_height,
      num_feat_channels, num_thresholds,
      margin, depth);

  // train the
  split->train(data,split_mode, depth, class_weights, min_child_size, &rng);

}


template <typename F>
int BodyPartSample::calculate_label_hist(const std::vector<BodyPartSample*>& set,
    std::vector<int>& hist,  F norm_function, int num_classes ) {
  if( num_classes <= 0) {
    for (unsigned int i = 0; i < set.size(); ++i) {
      int l = norm_function(set[i]);
      if( l >= 0){
        if(l >= hist.size()) {
          hist.resize(l+1,0);
        }
        hist[l]++;
      }
    }
  }else{
    hist.resize(num_classes, 0);
    for (unsigned int i = 0; i < set.size(); ++i) {
      int l = norm_function(set[i]);
      if( l >= 0){
        hist[ l ]++;
      }
    }
  }
  int num_pos_samples = 0;
  for (unsigned int i = 0; i < hist.size(); ++i) {
    num_pos_samples += hist[i];
  }
  return num_pos_samples;
}

#endif /* BODY_PART_SAMPLE_HPP_ */
