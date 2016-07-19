/*
 * param.hpp
 *
 *  Created on: Aug 26, 2013
 *      Author: mdantone
 */

#ifndef PARAM_HPP_
#define PARAM_HPP_

#include <boost/archive/binary_oarchive.hpp>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>
#include <boost/serialization/vector.hpp>
#include <boost/serialization/version.hpp>
#include <boost/serialization/split_member.hpp>

#include <boost/algorithm/string.hpp>
#include <boost/filesystem.hpp>
#include <boost/lexical_cast.hpp>

#include <boost/iostreams/device/file.hpp>
#include <boost/iostreams/stream.hpp>
#include <glog/logging.h>

#include <iostream>
#include <fstream>

namespace learning {
namespace forest {

class ForestParam {

public:

  // maximal depth of the tree
  int max_depth;

  // minimal samples of the tree
  int min_samples;

  // number of split candidates
  int num_split_candidates;

  // num trees
  int num_trees;

  //
  int num_samples_per_tree;
  int num_patches_per_sample;
  int norm_size;
  int num_feature_channels;
  int patch_width;
  int patch_height;

  std::string tree_path;
  std::string img_index_path;
  std::vector<int> features;
  std::vector<int> split_modes;

  template<class Archive>
  void save(Archive& ar, const unsigned version) const {
    ar & max_depth;
    ar & min_samples;
    ar & num_split_candidates;
    ar & num_trees;
    ar & num_samples_per_tree;
    ar & num_patches_per_sample;
    ar & norm_size;
    ar & num_feature_channels;
    ar & patch_width;
    ar & patch_height;
    ar & tree_path;
    ar & img_index_path;
    ar & features;
    ar & split_modes;
  }

  template<class Archive>
  void load(Archive& ar, const unsigned version) {
    ar & max_depth;
    ar & min_samples;
    ar & num_split_candidates;
    ar & num_trees;
    ar & num_samples_per_tree;
    ar & num_patches_per_sample;
    ar & norm_size;
    ar & num_feature_channels;
    if(version == 0) {
      ar & _patch_size_ratio;
      patch_width = norm_size * _patch_size_ratio;
      patch_height = norm_size * _patch_size_ratio;
    }else{
      ar & patch_width;
      ar & patch_height;
    }
    ar & tree_path;
    ar & img_index_path;
    ar & features;
    ar & split_modes;
  }


  template<class Archive>
  void serialize(  Archive &ar, const unsigned int file_version ){
      boost::serialization::split_member(ar, *this, file_version);
  }

private:
  float _patch_size_ratio;


};

bool inline loadConfigFile(std::string filename, ForestParam& param) {
  if (boost::filesystem::exists(filename.c_str())) {
    boost::iostreams::stream < boost::iostreams::file_source > file(
        filename.c_str());
    std::string line;
    if (file.is_open()) {

      // Path to images
      std::getline(file, line);
      std::getline(file, line);
      param.img_index_path = line;
     // LOG(INFO) << "Image path: " << param.img_index_path << std::endl;

      // Path to trees
      std::getline(file, line);
      std::getline(file, line);
      param.tree_path = line;
    //  LOG(INFO) << "paths to trees: " << param.tree_path << std::endl;

      // Number of trees
      std::getline(file, line);
      std::getline(file, line);
      param.num_trees = boost::lexical_cast<int>(line);

      // Number of tests
      std::getline(file, line);
      std::getline(file, line);
      param.num_split_candidates = boost::lexical_cast<int>(line);

      // Max depth
      // Max depth
      std::getline(file, line);
      std::getline(file, line);
      param.max_depth = boost::lexical_cast<int>(line);

      // Min samples per Node
      std::getline(file, line);
      std::getline(file, line);
      param.min_samples = boost::lexical_cast<int>(line);

      // Samples per Tree
      std::getline(file, line);
      std::getline(file, line);
      param.num_samples_per_tree = boost::lexical_cast<int>(line);

      // Patches Per Sample
      std::getline(file, line);
      std::getline(file, line);
      param.num_patches_per_sample = boost::lexical_cast<int>(line);

      std::getline(file, line);
      std::getline(file, line);
      param.norm_size = boost::lexical_cast<int>(line);

      std::getline(file, line);
      std::getline(file, line);
      float patch_size_ratio = boost::lexical_cast<float>(line);
      param.patch_width = param.norm_size * patch_size_ratio;
      param.patch_height = param.norm_size * patch_size_ratio;

      // number of Feature Channels
      std::getline(file, line);
      std::getline(file, line);
      std::vector < std::string > strs;
      boost::split(strs, line, boost::is_any_of(" "));
      for (unsigned int i = 0; i < strs.size(); i++)
        param.features.push_back(boost::lexical_cast<float>(strs[i]));

      if(std::getline(file, line)){
        std::getline(file, line);
        boost::split(strs, line, boost::is_any_of(" "));
        for (unsigned int i = 0; i < strs.size(); i++)
          param.split_modes.push_back(boost::lexical_cast<float>(strs[i]));
      }

      return true;
    }
  }
  LOG(INFO) << "FILE NOT FOUND, default inizialization " << std::endl;
  LOG(INFO) << filename << std::endl;

  //default values for ForestParam
  param.max_depth = 15;
  param.min_samples = 20;
  param.num_split_candidates = 250;
  param.num_trees = 10;
  param.num_patches_per_sample = 200;
  param.num_samples_per_tree = 500;
  param.norm_size = 100;
  param.patch_width = param.norm_size*0.25;
  param.patch_height = param.norm_size*0.25;

  return false;
}

} /* namespace forest */
} /* namespace learning */
#endif /* PARAM_HPP_ */
