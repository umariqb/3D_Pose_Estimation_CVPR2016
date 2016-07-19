/*
 * binary_svm_split.hpp
 *
 *  Created on: Oct 12, 2013
 *      Author: mdantone
 */
#include <boost/serialization/shared_ptr.hpp>
#include "boost/smart_ptr.hpp"
#include "cpp/learning/svm/liblinear_svm.hpp"
#include "cpp/learning/svm/liblinear_svm_problem.hpp"

#ifndef BINARY_SVM_SPLIT_HPP_
#define BINARY_SVM_SPLIT_HPP_

namespace learning
{
namespace forest
{

class BinarySVMSplit
{
public:
  BinarySVMSplit(){
    info = boost::numeric::bounds<double>::lowest();
    gain = boost::numeric::bounds<double>::lowest();
    oob = boost::numeric::bounds<double>::highest();
    threshold = 0;
    used_subsampling = true;
  };

  template<typename Sample>
  float get_feature_value(const Sample* sample) const {
    const cv::Mat_<float>& desc = sample->get_descriptor();
    return predict(desc);
  }

  template<typename Sample>
  bool eval( const Sample* sample ) const {
    return get_feature_value(sample) <= threshold;
  }

  template<typename Sample>
  void split(const std::vector<Sample*>& data,
    std::vector<Sample*>& set_a, std::vector<Sample*>& set_b) const {

    std::vector< std::pair<float, unsigned int> >index(data.size());
    for (unsigned int l = 0; l < data.size(); ++l) {
      index[l].first = get_feature_value(data[l]);
      index[l].second = l;
    }
    std::sort(index.begin(), index.end());
    for (unsigned int l = 0; l < index.size(); ++l) {
      int index_sample = index[l].second;
      if( index[l].first  <= threshold ) {
        set_a.push_back(data[index_sample]);
      }else{
        set_b.push_back(data[index_sample]);

      }
    }
    // reverse set a
    std::reverse(set_a.begin(), set_a.end());
    CHECK_GE( get_feature_value(set_a[0]),
              get_feature_value(set_a[set_a.size()-1]));
    CHECK_LE( get_feature_value(set_b[0]),
              get_feature_value(set_b[set_b.size()-1]));
  }

  template<typename Sample>
  void train(const std::vector<Sample*>& set,
      std::vector<int>& pos_sample_ids,
      std::vector<int>& neg_sample_ids,
      std::vector<int> class_weights_labels = std::vector<int>(),
      std::vector<double> class_weights = std::vector<double>() ) {

    awesomeness::learning::svm::LibLinearSvmParameters svm_param;

    boost::scoped_ptr<awesomeness::learning::svm::LibLinearSvmProblem> svm_problem;
    boost::scoped_ptr<awesomeness::learning::svm::LibLinearSvm> svm;

    int n_samples = pos_sample_ids.size() + neg_sample_ids.size();
    cv::Mat_<float> desc = set[0]->get_descriptor();

    svm_problem.reset(
        (awesomeness::learning::svm::LibLinearSvmProblem*)awesomeness::learning::svm::SvmProblem::create(
            svm_param, 2, n_samples, n_samples * desc.cols));


    for(int i=0; i < pos_sample_ids.size(); i++) {
      int pos_index = pos_sample_ids[i];
      svm_problem->push_sample(set[pos_index]->get_descriptor(), 1);
    }

    // add negative examples
    for(int i=0; i < neg_sample_ids.size(); i++) {
      int neg_index = neg_sample_ids[i];
      svm_problem->push_sample(set[neg_index]->get_descriptor(), 0);
    }

    if(class_weights.size() == 0 ) {
      svm.reset( (awesomeness::learning::svm::LibLinearSvm*)svm_problem->train());
    }else{
      svm.reset( (awesomeness::learning::svm::LibLinearSvm*)svm_problem->train(class_weights_labels, class_weights));
    }
    std::vector<double> svm_weights;
    svm->get_weights(svm_weights);

    weights = cv::Mat::zeros(1, svm_weights.size(),
        cv::DataType<float>::type);
    for(int i=0; i < svm_weights.size(); i++) {
      weights(i) = static_cast<float>(svm_weights[i]);
    }
  }

  float predict(const cv::Mat_<float>& desc) const {
    int n = MIN(desc.cols, weights.cols);
    double r = 0.0;
    for(int i=0; i < n; i++) {
      r += desc(i)*weights(i);
    }
    CHECK_EQ(desc.cols, weights.cols );
    return r;
  }

  double info;
  double gain;
  double oob;
  cv::Mat_<float> weights;
  float threshold;
  bool used_subsampling;

private:
  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {
     ar & info;
     ar & gain;
     ar & oob;
     ar & weights;
     ar & threshold;
  }
};

}/* forest */
}/* learning */
#endif /* BINARY_SVM_SPLIT_HPP_ */
