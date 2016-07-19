/*
 * svn_split.hpp
 *
 *  Created on: Feb 9, 2012
 *      Author: mdantone
 */

#ifndef SVN_SPLIT_HPP_
#define SVN_SPLIT_HPP_

#include <boost/serialization/shared_ptr.hpp>
#include "boost/smart_ptr.hpp"
#include <boost/random.hpp>
#include "cpp/utils/libsvm/liblinear.hpp"
#include "cpp/learning/forest/simple_split.hpp"

namespace learning
{
namespace forest
{

template<typename Feature>
class SVNSplit
{
public:
  SVNSplit(){
    info = boost::numeric::bounds<double>::lowest();
    gain = boost::numeric::bounds<double>::lowest();
    oob = boost::numeric::bounds<double>::highest();
    used_subsampling = false;
  };

  template<typename Sample>
  double get_feature_value(const Sample* sample, const Feature* feature) const {
    std::vector<float> desc;
    sample->extract(feature, desc);
    double r = predict(desc);
    return r;
  }

  template<typename Sample>
  bool eval( const Sample* sample ) const {
    return get_feature_value(sample, &feature) <= 0;
  }

  template<typename Sample>
  void split(const std::vector<Sample*>& data,
    std::vector<Sample*>& set_a, std::vector<Sample*>& set_b) const {
    for (unsigned int l = 0; l < data.size(); ++l) {
      if(eval(data[l])) {
        set_a.push_back(data[l]);
      }else{
        set_b.push_back(data[l]);
      }
    }
  }

  template<typename Sample>
  void evaluate(const std::vector<Sample*>& data,  const std::vector<float> class_weights,
       int split_mode, int depth, int min_samples = 10) {
    double pre_info = Sample::eval(data, split_mode, class_weights);

    std::vector<Sample*> set_a, set_b;
    split(data, set_a, set_b);
    if(set_a.size() < min_samples || set_b.size() < min_samples){
      info = boost::numeric::bounds<double>::lowest();
      gain = boost::numeric::bounds<double>::lowest();
    }else{
      info = Sample::evalSplit(set_a, set_b, class_weights, split_mode, depth);
      gain = info - pre_info;
    }
  }

  void get_binary_labels( std::vector<int>& binary_labels,
                          std::vector<int>& hist,
                          boost::mt19937* rng) {

    if( hist.size() == 2){
      binary_labels.push_back(0);
      binary_labels.push_back(1);
      return;
    }

    binary_labels.resize(hist.size(),0);
    std::vector<int> new_hist(2,0);

    //assigne random binary label
    boost::uniform_int<> dist_bin(0,1);
    boost::variate_generator<boost::mt19937&, boost::uniform_int<> > rand_bin( *rng, dist_bin);
    while(true){
      new_hist[0] = 0;
      new_hist[1] = 0;
      for(int i=0; i < hist.size(); i++){
        binary_labels[i] = rand_bin();
        if(binary_labels[i] == 0) {
          new_hist[0] += hist[i];
        }else{
          new_hist[1] += hist[i];
        }
      }
      if(new_hist[0] > 0 && new_hist[1] > 0 )
        break;
    }

    hist.resize(2,0);
    hist[0] = new_hist[0];
    hist[1] = new_hist[1];
  }


  template<typename Sample, typename F>
  void get_statistics(const std::vector<Sample*>& set,
      F label_function,
      std::vector<int>& hist,
      int* num_samples,
      int* num_labels,
      int max_samples = 1000000) {

    int size = MIN(set.size(), max_samples);
    for (unsigned int i = 0; i < size; ++i) {
      int l = label_function(set[i]);
      if( l >= 0){
        if(l >= hist.size()) {
          hist.resize(l+1,0);
        }
        hist[l]++;
      }
    }
    int n_samples = 0;
    int n_labels = 0;
    for (unsigned int i = 0; i < hist.size(); ++i) {
      n_samples += hist[i];
      if(hist[i] > 0) {
        n_labels += 1;
      }
    }
    *num_samples = n_samples;
    *num_labels = n_labels;

  }

  template<typename Sample, typename F>
  void train(const std::vector<Sample*>& set,
      F label_function,
      boost::mt19937* rng,
      ::utils::liblinear::solver_type::T solver,
      double C = 1.0, double eps = 0.10,
      bool use_weights = true,
      int max_samples = 1000000) {

    //allocate problem
    std::vector<float> desc;
    set[0]->extract(&feature, desc);
    int non_zero = desc.size();
    CHECK(non_zero > 0);

    int num_samples = 0;
    int num_labels = 0;
    std::vector<int> label_hist(2,0);
    get_statistics(set, label_function, label_hist,
        &num_samples, &num_labels, max_samples);

    if(num_labels > 1) {
      std::vector<int> binary_labels;
      get_binary_labels(binary_labels, label_hist, rng);

      ::utils::liblinear::ProblemHolder p;
      p.allocate(num_samples,non_zero*num_samples);

      int size = MIN(set.size(), max_samples);
      for (unsigned int i = 0; i < size; ++i) {
        int l = label_function(set[i]);
        if (l >= 0 ) {
          set[i]->extract(&feature, desc);
          cv::Mat mat = cv::Mat_<float>(1, non_zero, &desc[0]);
          p.push_problem<float>(mat, binary_labels[l]);
        }
      }

      boost::shared_ptr< ::utils::liblinear::LinearHolder> model;
      model =  boost::shared_ptr< ::utils::liblinear::LinearHolder>(
          new ::utils::liblinear::LinearHolder() );


      std::vector<double> class_weights;
      std::vector<int> class_weights_label;
      if(use_weights){
        class_weights.resize(2);
        class_weights[0] = 1 - label_hist[0] / static_cast<float>(num_samples);
        class_weights[1] = 1 - label_hist[1] / static_cast<float>(num_samples);
        class_weights_label.resize(2);
        class_weights_label[0] = 0;
        class_weights_label[1] = 1;
      }

      model->train( p, solver, C, eps, class_weights, class_weights_label );
      model->get_weights(weights);

    }
    if(weights.size() <= 0) {
      weights.resize(non_zero, 0.0);
    }
  }

  double predict(const std::vector<float>& desc) const {
    CHECK(desc.size() > 0);
    CHECK(weights.size() > 0);

    int n = MIN(desc.size(), weights.size());
    double r = 0.0;
    for(int i=0; i < n; i++) {
      r += desc[i]*weights[i];
    }
    return r;
  }

  void set_feature(Feature f) {
    feature = f;
  }

  std::vector<double> weights;
  Feature feature;
  double info;
  double gain;
  double oob;
  bool used_subsampling;

private:
  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {
     ar & weights;
     ar & feature;
     ar & info;
     ar & gain;
     ar & oob;
  }
};

} //namespace forest

} //namespace learning


#endif /* LIBLINEARSPLIT_HPP_ */
