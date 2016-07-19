/*
 * simple_split.hpp
 *
 *  Created on: Sep 22, 2012
 *      Author: mdantone
 */

#ifndef SIMPLESPLIT_HPP_
#define SIMPLESPLIT_HPP_

#include <vector>
#include <iostream>
#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"

#include <boost/serialization/utility.hpp>
#include <boost/numeric/conversion/bounds.hpp>
#include <boost/limits.hpp>
#include <boost/random.hpp>
#include <glog/logging.h>
#include "cpp/utils/serialization/opencv_serialization.hpp"

namespace learning
{
namespace forest
{

typedef std::pair<int, unsigned int> IntIndex;
struct less_than {
  bool operator()(const IntIndex& a, const IntIndex& b) const {
    return a.first < b.first;
  }
  bool operator()(const IntIndex& a, const int& b) const {
    return a.first < b;
  }
};

template<typename Sample>
inline void splitVec(const std::vector<Sample*>& data,
    const std::vector<IntIndex>& valSet,
    std::vector<Sample*>& setA,
    std::vector<Sample*>& setB,
    int threshold, int margin = 0) {

  // search largest value such that val<t
  std::vector<IntIndex>::const_iterator it_first, it_second;

  it_first = lower_bound(valSet.begin(), valSet.end(), threshold - margin, less_than());
  if (margin == 0)
    it_second = it_first;
  else
    it_second = lower_bound(valSet.begin(), valSet.end(), threshold + margin, less_than());

  // Split training data into two sets A,B accroding to threshold t
  setA.resize(it_second - valSet.begin());
  setB.resize(valSet.end() - it_first);

  std::vector<IntIndex>::const_iterator it = valSet.begin();
  typename std::vector<Sample*>::iterator itSample;
  for (itSample = setA.begin(); itSample < setA.end(); ++itSample, ++it)
    (*itSample) = data[it->second];

  it = it_first;
  for (itSample = setB.begin(); itSample < setB.end(); ++itSample, ++it)
    (*itSample) = data[it->second];

};

template<typename Sample>
inline void splitVec(const std::vector<Sample*>& data,
    const std::vector<IntIndex>& valSet,
    std::vector<std::vector<Sample*> >& sets,
    int threshold, int margin) {

  // search largest value such that val<t
  std::vector<IntIndex>::const_iterator it_first, it_second;

  it_first = lower_bound(valSet.begin(), valSet.end(), threshold - margin, less_than());
  if (margin == 0)
    it_second = it_first;
  else
    it_second = lower_bound(valSet.begin(), valSet.end(), threshold + margin, less_than());

  if (it_first == it_second) { // no intersection between the two thresholds
    std::vector<IntIndex>::const_iterator it = it_first;
    sets.resize(2);
    // Split training data into two sets A,B according to threshold t
    sets[0].resize(it - valSet.begin());
    sets[1].resize(valSet.size() - sets[0].size());

    it = valSet.begin();
    typename std::vector<Sample*>::iterator itSample;
    for (itSample = sets[0].begin(); itSample < sets[0].end(); ++itSample, ++it)
      (*itSample) = data[it->second];

    it = valSet.begin() + sets[0].size();
    for (itSample = sets[1].begin(); itSample < sets[1].end(); ++itSample, ++it)
      (*itSample) = data[it->second];

    CHECK( (sets[0].size() + sets[1].size()) == valSet.size());

  } else {

    sets.resize(3);
    // Split training data into two sets A,B accroding to threshold t
    sets[0].resize(it_first - valSet.begin());
    sets[1].resize(it_second - it_first);
    sets[2].resize(valSet.end() - it_second);

    std::vector<IntIndex>::const_iterator it = valSet.begin();
    typename std::vector<Sample*>::iterator itSample;
    for (itSample = sets[0].begin(); itSample < sets[0].end(); ++itSample, ++it)
      (*itSample) = data[it->second];

    it = valSet.begin() + sets[0].size();
    for (itSample = sets[1].begin(); itSample < sets[1].end(); ++itSample, ++it)
      (*itSample) = data[it->second];

    it = valSet.begin() + sets[0].size() + sets[1].size();

    for (itSample = sets[2].begin(); itSample < sets[2].end(); ++itSample, ++it)
      (*itSample) = data[it->second];

    CHECK( (sets[0].size() + sets[1].size() + sets[2].size()) == valSet.size());
  }
};





template<typename Feature>
class ThresholdSplit {
public:
  ThresholdSplit(){
    margin = 0;
    oob = 0;
    num_thresholds = 25;
    gain = boost::numeric::bounds<double>::lowest();
    info = boost::numeric::bounds<double>::lowest();
    used_subsampling = false;
  }

  template<typename Sample>
  int get_feature_value(const Sample* sample, const Feature* feature) const {
    return feature->extract(sample->get_images(),
                               sample->get_roi(),
                               sample->is_integral_image());
  }

  template<typename Sample>
  bool eval( const Sample* sample ) const {
    return get_feature_value(sample, &feature) <= threshold;
  }

  void initialize( boost::mt19937* rng, int patch_width_, int patch_height_,
      int num_feat_channels_, int num_thresholds_, int margin_, int depth_) {
    patch_width = patch_width_;
    patch_height = patch_height_;
    num_thresholds = num_thresholds_;
    margin = margin_;
    depth = depth_;

    feature.generate(patch_width, patch_height, rng, num_feat_channels_);
  }

  template<typename Sample>
  void split(const std::vector<Sample*>& data,
    std::vector<Sample*>& set_a, std::vector<Sample*>& set_b) const {
    std::vector<IntIndex> valSet(data.size());
    for (unsigned int l = 0; l < data.size(); ++l) {
      valSet[l].first = get_feature_value(data[l], &feature);
      valSet[l].second = l;
    }
    std::sort(valSet.begin(), valSet.end());
    splitVec(data, valSet, set_a, set_b, threshold, margin);
  }

  template<typename Sample>
  void get_subsampling_ids(size_t n_samples,
      const std::vector<Sample*>& data,
      std::vector<int>& indicies) {
    std::vector<int> pos_indicies, neg_indicies;
    for (unsigned int i = 0; i < data.size(); ++i) {
      if(data[i]->is_pos()) {
        pos_indicies.push_back(i);
      }else{
        neg_indicies.push_back(i);
      }
    }

    srand(0);
    std::random_shuffle( pos_indicies.begin(), pos_indicies.end());
    std::random_shuffle( neg_indicies.begin(), neg_indicies.end());

    int n_pos = std::min(pos_indicies.size(), n_samples);
    int n_neg = std::min(neg_indicies.size(), n_samples);

    pos_indicies.resize( n_pos );
    neg_indicies.resize( n_neg );


    indicies.insert(indicies.end(), pos_indicies.begin(), pos_indicies.end());
    indicies.insert(indicies.end(), neg_indicies.begin(), neg_indicies.end());

  }

  template<typename Sample>
  void get_subsampling_pos_ids(size_t n_samples,
      const std::vector<Sample*>& data,
      std::vector<int>& indicies) {
    for (unsigned int i = 0; i < data.size(); ++i) {
      if(data[i]->is_pos()) {
        indicies.push_back(i);
      }
    }
    srand(0);
    std::random_shuffle( indicies.begin(), indicies.end());
    int n_pos = std::min(indicies.size(), n_samples);
    indicies.resize( n_pos );
  }


  template<typename Sample>
  void train(const std::vector<Sample*>& data, int split_mode_,
      int depth, const std::vector<float>& class_weights,
      int min_child_size, boost::mt19937* rng, int subsampling=0 ) {

    if(subsampling > data.size() ) {
      subsampling = 0;
    }

    split_mode = split_mode_;
    std::vector<IntIndex> valSet;

    // do subsampling
    if( subsampling > 0 ) {
      used_subsampling = true;
      int n_pos = subsampling;
      int n_neg = subsampling;
      int i_pos = 0;
      int i_neg = 0;
      if(split_mode != 0) {
        n_neg = 0;
      }

      valSet.reserve(n_pos + n_neg);
      int i=0;
      while( i < data.size() && ( i_pos < n_pos || i_neg < n_neg ) ) {

        if(data[i]->is_pos() && i_pos < n_pos) {
          valSet.push_back( std::make_pair(get_feature_value(data[i], &feature), i) );
          ++i_pos;
        }else if( !data[i]->is_pos() && i_neg < n_neg ){
          valSet.push_back( std::make_pair(get_feature_value(data[i], &feature), i) );
          ++i_neg;
        }
        ++i;
      }
    } else {

      //extract the features
      int size = MIN(200000, static_cast<int>(data.size()));
      valSet.resize(size);
      for (int l = 0; l < valSet.size(); ++l) {
        valSet[l].first = get_feature_value(data[l], &feature);
        valSet[l].second = l;
      }
    }

    std::sort(valSet.begin(), valSet.end());
    findThreshold(data, valSet, rng, min_child_size, class_weights, split_mode);
  }



  template<typename Sample>
  void findThreshold(const std::vector<Sample*>& data,
        const std::vector<IntIndex>& valSet,
        boost::mt19937* rng_,
        int min_size,
        const std::vector<float>& class_weights,
        int split_mode) {
    info = boost::numeric::bounds<double>::lowest();

    int min_val = valSet.front().first;
    int max_val = valSet.back().first;
    int valueRange = max_val - min_val;
    if (valueRange < 1)
      return;

    // Find best threshold
    boost::uniform_int<> dist_tr(0, valueRange);
    boost::variate_generator<boost::mt19937&, boost::uniform_int<> >
          rand_tr(*rng_, dist_tr);

    std::vector<int> thresholds;
    if(num_thresholds > valueRange){
      for(int i=0; i < valueRange; i++) {
        thresholds.push_back( min_val +i );
      }
    }else{
      while( thresholds.size() < num_thresholds ) {
        int tr = rand_tr() + min_val;
        bool duplicate = false;
        for(int j=0; j < thresholds.size(); j++) {
          if( tr == thresholds[j] ) {
            duplicate = true;
            break;
          }
        }
        if(!duplicate)
          thresholds.push_back( tr );
      }
    }

    sort(thresholds.begin(), thresholds.end());
    for (unsigned int j = 0; j < thresholds.size(); ++j) {
      int tr = thresholds[j];
      std::vector<std::vector<Sample*> > sets;
      splitVec(data, valSet, sets, tr, margin);
      if (sets[0].size() < min_size or sets[1].size() < min_size) {
        continue;
      }

      double infoNew = Sample::evalSplit(sets[0], sets[1],
          class_weights, split_mode,depth);

      if (infoNew > info) {
        threshold = tr;
        info = infoNew;
      }
    }
  }

  void print() {
    feature.print();
    std::cout << " " << threshold << std::endl;
  }

  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {
    ar & feature;
    ar & info;
    ar & gain;
    ar & threshold;

  }

  Feature* get_feature() {
    return &feature;
  }

  Feature feature;

  double info;
  double gain;
  double oob;
  int patch_width;
  int patch_height;
  int threshold;
  int margin;
  int depth;
  int num_thresholds;
  float split_mode;

  bool used_subsampling;

};

} //namespace forest

} //namespace learning
#endif /* SIMPLESPLIT_HPP_ */
