/*
 * sample.hpp
 *
 *  Created on: Jan 4, 2013
 *      Author: mdantone
 */

#ifndef SAMPLE_HPP_
#define SAMPLE_HPP_

#include <vector>
#include <math.h>
#include <iostream>
#include <boost/type_traits.hpp>
#include <boost/random.hpp>
#include <boost/serialization/utility.hpp>
#include "cpp/learning/forest/utils/eval_utils.hpp"


namespace learning
{
namespace forest
{

class RegressionLeaf {
  public:
  RegressionLeaf(): forground(0.0), num_samples(0),
      offset(cv::Point_<int>(0,0)), variance(0){
    };

    float forground;
    int num_samples;
    cv::Point_<int> offset;
    float variance;

    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version) {
      ar & forground;
      ar & num_samples;
      ar & offset;
      ar & variance;
    }
};



class ClassAndRegressionLeaf {
  public:
    ClassAndRegressionLeaf(): forground(0.0), num_samples(0),
      offset(cv::Point_<int>(0,0)), variance(0),
       class_hist(), global_attr_hist(), global_attr_offsets(),
       global_attr_variance(){

    };

    float forground;
    int num_samples;
    cv::Point_<int> offset;
    float variance;
    std::vector<int> class_hist;
    std::vector<int> global_attr_hist;
    std::vector<cv::Point_<int> > global_attr_offsets;
    std::vector<float> global_attr_variance;

    bool merge(const std::vector<const ClassAndRegressionLeaf*>& leafs ) {
      CHECK_GT(leafs.size(), 0);
      int num_pos_samples = 0;
      num_samples = 0;
      variance = 0;
      forground = 0;
      offset = cv::Point_<int>(0,0);
      class_hist.resize(leafs[0]->class_hist.size(), 0);

      for(unsigned int i=0; i < leafs.size(); i++) {
        num_samples += leafs[i]->num_samples;
        variance += leafs[i]->num_samples;
        offset += leafs[i]->offset;

        CHECK_EQ(class_hist.size(), leafs[i]->class_hist.size());
        for(unsigned int j=0; j < class_hist.size(); j++) {
          class_hist[j] += leafs[i]->class_hist[j];
        }
        num_pos_samples += leafs[i]->num_samples*leafs[i]->forground;
      }

      variance /= leafs.size();
      offset.x /= leafs.size();
      offset.y /= leafs.size();
      forground = num_pos_samples / static_cast<float>(num_samples);
      return true;
    }

  private:


    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version) {
      ar & forground;
      ar & num_samples;
      ar & class_hist;
      ar & offset;
      ar & variance;
      ar & global_attr_hist;
      ar & global_attr_offsets;
      ar & global_attr_variance;
    }
};

class ClassificationLeaf {
public:
  ClassificationLeaf(): forground(0.0), num_samples(0){
  };

  float forground;
  int num_samples;
  std::vector<int> class_hist;

  bool merge(const std::vector<const ClassificationLeaf*>& leafs ) {
    CHECK_GT(leafs.size(), 0);
    int num_pos_samples = 0;
    num_samples = 0;
    forground = 0;
    class_hist.resize(leafs[0]->class_hist.size(), 0);
    for(unsigned int i=0; i < leafs.size(); i++) {
      num_samples += leafs[i]->num_samples;
      CHECK_EQ(class_hist.size(), leafs[i]->class_hist.size());
      for(unsigned int j=0; j < class_hist.size(); j++) {
        class_hist[j] += leafs[i]->class_hist[j];
      }
      num_pos_samples += leafs[i]->num_samples*leafs[i]->forground;
    }

    forground = num_pos_samples / static_cast<float>(num_samples);
    return true;
  }


private:

  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {
    ar & forground;
    ar & num_samples;
    ar & class_hist;
  }
};


class Sample {
public:
  Sample(bool is_pos_=true): pos(is_pos_) { };

  template <typename T>
  static int count_pos_samples(const std::vector<T>& set) {
    int pos = 0;
    typename std::vector<T>::const_iterator itSample;
    for (itSample = set.begin(); itSample < set.end(); ++itSample)
      if ((*itSample)->is_pos() )
        pos += 1;
    return pos;
  }

  template <typename T>
  static double entropie_pos_vs_neg(const std::vector<T>& set,
      const std::vector<float>& class_weights){

    double n_entropy = 0;
    int pos = count_pos_samples(set);

    float weight = 1;
    if ( class_weights.size() > 0 )
      weight = class_weights[0];

    double num_pos = static_cast<double>(pos);
    double num_neg = static_cast<double>(set.size() - pos);
    double p = num_pos / (num_neg*weight + num_pos );

//    LOG(INFO) << "class_weights: " << weight;
//    LOG(INFO) << "num_pos " << num_pos;
//    LOG(INFO) << "num_neg " << num_neg;
//    LOG(INFO) << "p " << p;
//    LOG(INFO) << "p " << num_pos / set.size();
    p = num_pos / set.size();
    if (p > 0)
      n_entropy += (p * log(p));
    return n_entropy;
  }

  template <typename T>
  static void get_class_weights(std::vector<float>& class_weights,
      const std::vector<T>& set) {

    // class weight is positive to negative ratio in this code
    class_weights.resize(1);
    int size = count_pos_samples(set);


    if(set.size() == size) {
      class_weights[0] = 1;
    }else{
      class_weights[0] = size / static_cast<float>(set.size() - size);
    }

    LOG(INFO) << "pos samples: " << size  << std::endl;
    LOG(INFO) << "neg samples: " << set.size() - size <<  std::endl;
    LOG(INFO) << "positive to negative ratio: " << class_weights[0] << std::endl;
  }

  template <typename T>
  static double evalSplit(const std::vector<T>& setA,
      const std::vector<T>& setB,
      const std::vector<float>& class_weights,
      int split_mode, int depth) {

    if( setA.size() == 0 or setB.size() == 0) {
      return boost::numeric::bounds<double>::lowest();
    }

    double var_a = boost::remove_pointer<T>::type::eval(setA, split_mode, class_weights);
    double var_b = boost::remove_pointer<T>::type::eval(setB, split_mode, class_weights);
    int size_a = setA.size();
    int size_b = setB.size();
    return (var_a * size_a + var_b * size_b) / static_cast<double>(size_b + size_a);
  }

  template <typename T>
  static double eval(const std::vector<T>& set_a,
      int splitMode,
      const std::vector<float>& class_weights) {
    return entropie_pos_vs_neg(set_a, class_weights);
  }

  template <typename T>
  static void create_leaf(ClassificationLeaf& leaf, const std::vector<T>& set,
      const std::vector<float>& class_weights, int leaf_id = 0) {
    leaf.num_samples = set.size();
    int pos = count_pos_samples(set);

    float weight = 1;
    if ( class_weights.size() > 0 )
      weight = class_weights[0];

    double num_pos = static_cast<double>(pos);
    double num_neg = static_cast<double>(set.size() - pos);
    leaf.forground = num_pos / (num_neg*weight + num_pos );

    LOG(INFO) << "num_pos: " << num_pos << ", ratio : " << leaf.forground << ", samples: " << leaf.num_samples;
    assert(leaf.num_samples > 0 );
  }

  // randomly provides a split mode
  template <typename T>
  static int get_split_mode(const std::vector<T>& data, int depth,
      const std::vector<int>& split_modes, boost::mt19937* rng ){
    if(split_modes.size() == 1) {
      return split_modes[0];
    }else if(split_modes.size() > 1 ){

      // get pos neg ratio
      float pos_ratio = count_pos_samples(data) / static_cast<float>(data.size());
      boost::uniform_int<> dist_split_mode(0, split_modes.size() - 1);
      boost::variate_generator<boost::mt19937&, boost::uniform_int<> > rand_split_mode(*rng, dist_split_mode);
      int split_mode_index = rand_split_mode();
      if( pos_ratio < 0.05) {
        split_mode_index =  0;
      }else if(pos_ratio > 0.95) {
        if(split_mode_index == 0) {
          split_mode_index = 1;
        }
      }

      return split_modes[split_mode_index];
    }else{
      return 0;
    }
  }



  bool is_pos() const {
    return pos;
  }
protected:
  bool pos;
};


} //namespace forest

} //namespace learning

#endif /* SAMPLE_HPP_ */
