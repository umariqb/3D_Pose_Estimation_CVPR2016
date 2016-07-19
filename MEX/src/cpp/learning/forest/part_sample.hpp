/*
 * part_sample.hpp
 *
 *  Created on: Jan 4, 2013
 *      Author: mdantone
 */

#ifndef PARTSAMPLE_H_
#define PARTSAMPLE_H_

#include "sample.hpp"
#include "opencv2/core/core.hpp"

namespace learning
{
namespace forest
{

class PartSample : public Sample {
public:
  PartSample(bool is_pos = true) :
    Sample(is_pos), offset(cv::Point_<int>(0,0)) {};

  PartSample(cv::Point_<int> part_offset_) :
    Sample(true), offset(part_offset_) {
  };


  template <typename T>
  static int sum_of_square_diff(const std::vector<T>& set,
      cv::Point_<int>* mean, double* variance) {
    int n_pos_samples = 0;
    double ssd = 0;
    cv::Point_<int> m(0,0);
    typename std::vector<T>::const_iterator itSample;
    for (itSample = set.begin(); itSample < set.end(); ++itSample) {
      const T& s = (*itSample);
      if ((*itSample)->is_pos() ) {
        n_pos_samples ++;
        m.x += s->offset.x;
        m.y += s->offset.y;
      }
    }
    if(n_pos_samples > 0 ) {
      m.x /= n_pos_samples;
      m.y /= n_pos_samples;
      for (itSample = set.begin(); itSample < set.end(); ++itSample) {
        const T& s = (*itSample);
        if (s->is_pos()) {
          int v = s->offset.x - m.x;
          int u = s->offset.y - m.y;
          int d = (v*v + u*u);
          ssd += d*d;
        }
      }
    }

    *mean = m;
    *variance = ssd;
    return n_pos_samples;
  }

  template <typename T>
  static double eval(const std::vector<T>& set, int splitMode,
      const std::vector<float>& class_weights) {
    if( splitMode == 0) {
      return entropie_pos_vs_neg(set, class_weights);
    }else if(splitMode == 1){
      return neg_sum_squared_difference(set);
    }else{
      CHECK(false) << "unknown split mode.";
      return 0;
    }
  }

  template <typename T>
  static double neg_sum_squared_difference(const std::vector<T>& set) {
    cv::Point_<int> mean(0,0);
    double var;
    sum_of_square_diff(set, &mean, &var);
    return -var;
  }

  virtual ~PartSample() {};

  cv::Point_<int> offset;
private:
};


class MultiPartLeaf {
  public:
  MultiPartLeaf(): forground(0.0), num_samples(0),
      offset(cv::Point_<int>(0,0)), variance(0){
    };
    float forground;
    int num_samples;

    // mean an variance to the center of the bbox
    cv::Point_<int> offset;
    float variance;

    // mean an variance to the different parts
    std::vector<cv::Point_<int> > part_offsets;
    std::vector<float> part_variances;

    std::vector<int> part_indices;

  private:

    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version) {
      ar & forground;
      ar & num_samples;
      ar & part_offsets;
      ar & part_variances;
      ar & offset;
      ar & variance;
      ar & part_indices;
    }
};


class MultiPartSample : public Sample {
public:
  MultiPartSample(bool is_pos = true): Sample(is_pos) {};
  MultiPartSample(std::vector<cv::Point_<int> > part_offsets_) :
    Sample(true), part_offsets(part_offsets_) {}

  int get_num_parts() const  {
    return part_offsets.size();
  }

  template <typename T>
  static int get_num_parts(const std::vector<T>& set) {
    typename std::vector<T>::const_iterator itSample;
    for (itSample = set.begin(); itSample < set.end(); ++itSample) {
      if ((*itSample)->is_pos())
        return (*itSample)->get_num_parts();
    }
    return 0;
  }

  template <typename T>
  static int get_means(const std::vector<T>& set,
      std::vector<cv::Point_<int> >& means){
    typename std::vector<T>::const_iterator itSample;
    int num_parts = get_num_parts(set);
    means.resize(num_parts, cv::Point_<int>(0,0));

    int num_pos = 0;
    for (int j = 0; j < num_parts; j++) {
      num_pos = 0;
      // calculate the mean
      cv::Point_<int> mean(0, 0);
      for (itSample = set.begin(); itSample < set.end(); ++itSample) {
        const MultiPartSample* s = (*itSample);
        if (s->is_pos() ) {
          mean.x += s->part_offsets[j].x;
          mean.y += s->part_offsets[j].y;
          num_pos++;
        }
      }
      // check if set is bigger then 0, otherwise return min value.
      if (num_pos  > 0 ){
        mean.x /= num_pos;
        mean.y /= num_pos;
        means[j] = mean;
      }else{
        break;
      }
    }
    return num_pos;
  }

  template <typename T>
  static double sum_squared_difference(const std::vector<T>& set,
      const int part_id, const cv::Point_<int>& mean) {
    // calculate the SSD
    typename std::vector<T>::const_iterator itSample;
    double ssd = 0.0;
    for (itSample = set.begin(); itSample < set.end(); ++itSample) {
      const T s = (*itSample);
      if (s->is_pos()) {
        int v = s->part_offsets[part_id].x - mean.x;
        int u = s->part_offsets[part_id].y - mean.y;
        int d = (v*v + u*u);
        ssd += d*d;
      }
    }
    return ssd;
  }


  template <typename T>
  static double sum_squared_difference(const std::vector<T>& set) {
    double sum_ssd = 0;
    std::vector<cv::Point_<int> > means;
    int num_pos = get_means(set, means);
    int num_parts = means.size();
    if(num_pos > 0) {
      for (int j = 0; j < num_parts; j++) {
        double ssd = sum_squared_difference(set, j, means[j]);
        sum_ssd += ssd;
      }
    }
    return -sum_ssd;
  }

  template <typename T>
  static double eval(const std::vector<T>& set, int splitMode,
      const std::vector<float>& class_weights) {
    if( splitMode == 0) {
      return entropie_pos_vs_neg(set, class_weights);
    }else if(splitMode == 1){
      return sum_squared_difference(set);
    }else{
      CHECK(false) << "unknown split mode.";
      return 0;
    }
  }

  virtual ~MultiPartSample(){};

  std::vector<cv::Point_<int> > part_offsets;
};

} //namespace forest

} //namespace learning
#endif /* PARTSAMPLE_H_ */
