/*
 * CRTree.h
 *
 *  Created on: May 3, 2011
 *      Author: mdantone
 */

#ifndef CRTREE_H_
#define CRTREE_H_

#include <string>
#include <iostream>
#include <fstream>
#include <glog/logging.h>
#include <boost/bind.hpp>
#include <boost/random.hpp>
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>

#include "cpp/utils/thread_pool.hpp"
#include "cpp/utils/timing.hpp"
#include "cpp/utils/system_utils.hpp"
#include "cpp/learning/forest/tree_node.hpp"
#include "cpp/learning/forest/simple_split.hpp"

namespace learning
{
namespace forest
{

// Orders split by info gain.
// highes info first.
template<typename Split>
struct SplitComparision {
  bool operator()(const Split& a, const Split& b) const {
    return a.info > b.info;
  }
};

template<typename Sample>
class Tree {
public:
  typedef typename Sample::Split Split;
  typedef typename Sample::Leaf Leaf;

  // constructor
  Tree(): root(0), rng(0) {
    timer.restart();
    last_save_point = 0;
    num_threads = -1;
    logging_level = 1;
  }

  Tree(const std::vector<Sample*>& data, ForestParam fp_, boost::mt19937* rng_,
      std::string savePath_, Timing jobTimer = Timing(), int num_threads_ = -1, int logging_level_ = 1,
                                                  int num_global_attr_labels_ = 0) :
                                                  fp(fp_),
                                                  rng(rng_),
                                                  save_path(savePath_),
                                                  timer(jobTimer),
                                                  num_threads(num_threads_),
                                                  logging_level(logging_level_),
                                                  num_global_attr_labels(num_global_attr_labels_)
                                                   {

    timer.restart();
    last_save_point = 0;
    root = new TreeNode<Sample>(0);
    num_nodes = pow(2.0, int(fp.max_depth + 1)) - 1;
    i_node = 0;
    i_leaf = 0;

    Sample::get_class_weights(class_weights, data);

    LOG(INFO) << "Start Training" << std::endl;

    if(num_threads < 1 ) {
      num_threads = ::utils::system::get_available_logical_cpus();

      if( logging_level == 1)
        LOG(INFO) << "num_threads " << num_threads << std::endl;
    }

    grow(root, data);
    i_node = num_nodes;
    save_tree(save_path, this);
    LOG(INFO) << "TREE IS COMPLETE AND SAVED";
  };

  //start growing the tree
  void grow(const std::vector<Sample*>& data, Timing jobTimer,
						boost::mt19937* rng_, int num_threads_ = -1, int logging_level_ = 1) {
    rng = rng_;
    timer = jobTimer;
    timer.restart();
    last_save_point = timer.elapsed();
    logging_level = logging_level_;

    if(num_threads_ < 1 ) {
      num_threads = ::utils::system::get_available_logical_cpus();
    }else{
      num_threads = num_threads_;
    }
    if( logging_level == 1)
      LOG(INFO) << "num_threads: " << num_threads << std::endl;

    LOG(INFO) << int((i_node / num_nodes) * 100) << "% : LOADED TREE " << std::endl;
    i_node = 0; // used for printing of progress percentage
    i_leaf = 0; // used for logging of leaf creations
    grow(root_node(), data);
    i_node = num_nodes;
    save_tree(save_path, this, true);
    LOG(INFO) << "TREE IS COMPLETE AND SAVED";

  }

  int get_split_mode(const std::vector<Sample*>& data, int depth) const {
    return Sample::get_split_mode(data, depth, fp.split_modes, rng);
  }

  //keep growing
  void grow(TreeNode<Sample>* node, const std::vector<Sample*>& data) {
    int depth = node->get_depth();

    // count element
    int nElements = data.size();
    std::vector<Sample*> setA;
    std::vector<Sample*> setB;
    if (nElements < fp.min_samples*2 || depth >= fp.max_depth || node->is_leaf()) {

      bool print = !node->is_leaf();
      node->create_leaf(data, class_weights, i_leaf);
      i_node += pow(2.0, int((fp.max_depth - depth) + 1)) - 1;
      i_leaf++;
      if(print && (logging_level == 1) ){
        LOG(INFO) << int((i_node / num_nodes) * 100) <<
            "% (" << i_leaf << "): leaf created ( depth: " << depth <<
            ", elements: " << data.size() << ")";
      }
    } else {


      if (node->is_split()) { //only in reload mode.
        node->split()->split(data, setA, setB);
        i_node++;

        grow(node->get_left_node(), setA);
        grow(node->get_right_node(), setB);

      } else {
        Split best_split;
        int split_mode = get_split_mode(data, depth);
        if (find_optimal_split(data, &best_split, depth, split_mode)) {

          i_node++;

          TreeNode<Sample>* left = new TreeNode<Sample>(depth + 1);
          TreeNode<Sample>* right = new TreeNode<Sample>(depth + 1);
          best_split.split(data, setA, setB);
          node->set_split(best_split);
          node->set_childs(left, right);

          auto_save();
          if(logging_level == 1){
            LOG(INFO) << int((i_node / float(num_nodes)) * 100) <<
              "% : split( mode: " << split_mode <<  " depth: " << depth <<
              ", elements: " << nElements << ") [" << setA.size() << ", " <<
              setB.size() << "]";
          }

          random_shuffle(setA.begin(), setA.end());
          random_shuffle(setB.begin(), setB.end());

          grow(left, setA);
          grow(right, setB);
        } else {
          LOG(INFO) << "no valid split found " << std::endl;
          node->create_leaf(data, class_weights, i_leaf);
          i_leaf++;
          i_node += (int) pow(2.0, int((fp.max_depth - depth) + 1)) - 1;
          if(logging_level == 1)
            LOG(INFO) << int((i_node / float(num_nodes)) * 100) << "% (" << i_leaf
              << "): make leaf ( mode: " << split_mode <<  ", depth: " << depth
              << ", elements: " << data.size() << ").";
        }
      }
    }
  };

  bool find_optimal_split(const std::vector<Sample*>& data,
													Split* best_split, int depth, int split_mode) const {

    best_split->info = boost::numeric::bounds<double>::lowest();
    best_split->gain = boost::numeric::bounds<double>::lowest();
    best_split->oob = boost::numeric::bounds<double>::highest();



    int num_splits = fp.num_split_candidates;

    // generates the splits;
    std::vector<Split> splits(num_splits);

    if(num_threads > 1) {
      boost::thread_pool::executor e(num_threads);
      for (unsigned int i = 0; i < num_splits; i++) {
        e.submit(boost::bind(&Sample::generateSplit, boost::ref(data),
            fp.patch_width, fp.patch_height, fp.min_samples,
          split_mode, depth, class_weights, i, &splits[i]));
      }
      e.join_all();
    }else{
      for (int i = 0; i < num_splits; i++) {
        Sample::generateSplit(data, fp.patch_width, fp.patch_height, fp.min_samples,
            split_mode, depth, class_weights, i, &splits[i]);
      }
    }

    // order splits by information gain
//    std::sort(splits.begin(), splits.end(), SplitComparision<Split>());
    for (unsigned int i = 0; i < splits.size(); i++) {
      if (splits[i].info > best_split->info) {
        *best_split = splits[i];
      }
    }

    if (best_split->info == boost::numeric::bounds<double>::lowest()) {
      return false;
    }

    // so far we always checked if we get a negative gain, but if we use subsamplint the gain is not working anymore.
    if( ! best_split->used_subsampling ) {
      double pre_info = Sample::eval(data, split_mode, class_weights);
      best_split->gain = best_split->info - pre_info;

      if(pre_info >= best_split->info) {

        if(logging_level == 1)
          LOG(INFO) << "negative gain";
        return false;
      }
    }
    return true;
  }


  //sends the sample down the tree and return a pointer to the leaf.
  static void evaluate(const Sample* sample, TreeNode<Sample>* node,
      std::vector<Leaf*>& leafs) {
    if (node->is_leaf())
      leafs.push_back(node->get_leaf());
    else {
      if (node->eval(sample)) {
        evaluate(sample, node->get_left_node(), leafs);
      } else {
        evaluate(sample, node->get_right_node(), leafs);
      }
    }
  }

  static void evaluate_mt(const Sample* sample,
      TreeNode<Sample>* node, Leaf** leaf) {
    if (node->is_leaf()) {
      *leaf = node->get_leaf();
    } else {
      if (node->eval(sample)) {
        evaluate_mt(sample, node->get_left_node(), leaf);
      } else {
        evaluate_mt(sample, node->get_right_node(), leaf);
      }
    }
  }

  void auto_save() {
    int time_stamp = timer.elapsed();
    int saveInterval = 250000;
    //save every 10 minutes
    if ((time_stamp - last_save_point) > saveInterval) {
      last_save_point = timer.elapsed();

      LOG(INFO) << int((i_node / num_nodes) * 100)  << "%, " << timer.elapsed() << ": save at " << last_save_point;
      save_tree(save_path, this, true);
    }
  }


  bool isFinished() const {
    if (num_nodes == 0)
      return false;
    return i_node == num_nodes;//((i_node / num_nodes) * 100) > 99.9;
    //TODO something seems to be fishy with i_node.
  }

  std::vector<float> get_class_weights() const {
    return class_weights;
  }

  TreeNode<Sample>* root_node() const {
    return root;
  }

  virtual ~Tree() {
    if (root)
      delete root;
  };

  ForestParam get_param() const {
    return fp;
  }

  ForestParam fp;


  void prune(int max_depth = 15) {
    prune(root, max_depth);
  }

  void prune(TreeNode<Sample>* node , int max_depth) {
    if( node->get_depth() < max_depth ){
      if( node->is_split() ) {
        prune(node->get_left_node(),  max_depth);
        prune(node->get_right_node(), max_depth);
      }
    }else{
      if( node->is_split() ) {
        std::vector<const Leaf*> leafs;
        node->collect_leafs(leafs);
        CHECK_GT(leafs.size(), 1);

        Leaf leaf;
        CHECK(leaf.merge(leafs) );
        node->set_leaf(leaf);
      }
    }
  }

  static bool save_tree(const std::string path, const Tree* tree, bool saveText) {
      if(saveText)
      {
          return save_tree_text(path,tree);
      } else
      {
          return save_tree_binary(path,tree);
      }
  }

  static bool save_tree_text(const std::string path, const Tree* tree) {
    try {
       std::ofstream ofs((path + ".new").c_str());
       CHECK(ofs);
       const int DISABLE_HEADER_INFORMATION = 1;
       boost::archive::text_oarchive oa(ofs, DISABLE_HEADER_INFORMATION);
       oa << tree;
       ofs.flush();
       ofs.close();
     } catch (boost::archive::archive_exception& ex) {
       LOG(INFO) << "Archive Exception during serializing:" << std::endl;
       LOG(INFO) << ex.what() << std::endl;
       LOG(INFO) << "it was tree: " << path << std::endl;
       throw;
     }
     boost::filesystem::remove(path);
     boost::filesystem::rename(path + ".new", path);
     LOG(INFO) << "saved " << path << std::endl;
     return true;
  }

  static bool save_tree_binary(const std::string path, const Tree* tree) {
    try {
       std::ofstream ofs((path + ".new").c_str());
       CHECK(ofs);
       boost::archive::binary_oarchive oa(ofs);
       oa << tree;
       ofs.flush();
       ofs.close();
     } catch (boost::archive::archive_exception& ex) {
       LOG(INFO) << "Archive Exception during serializing:" << std::endl;
       LOG(INFO) << ex.what() << std::endl;
       LOG(INFO) << "it was tree: " << path << std::endl;
       throw;
     }
     boost::filesystem::remove(path);
     boost::filesystem::rename(path + ".new", path);
     LOG(INFO) << "saved " << path << std::endl;
     return true;
  }

  static bool load_tree( std::string path, Tree** tree, bool binary)
  {
      if(binary)
      {
          return load_tree_binary(path, tree);
      } else
      {
          return load_tree_text(path, tree);
      }
  }

  static bool load_tree_text( std::string path, Tree** tree) {
    // non clean save:
    if (boost::filesystem::exists(path + ".new")){
      // tree path exists -> failed before remove in save -> save failed between
      // ofs creation and boost::filesystem::remove -> continue from old tree
      if (boost::filesystem::exists(path)){
        LOG(INFO) << "save_tree failed before, will continue from the previous tree " << path << std::endl;
      }
      // failed after remove, but before rename. assume "tree.new" is sane
      else {
        LOG(INFO) << "save_tree did not clean up properly, resuming from  " << path << ".new" <<  std::endl;
        boost::filesystem::rename(path + ".new", path);
      }
    }

    std::ifstream ifs(path.c_str());
    if (!ifs) {
      LOG(INFO) << "tree not found " << path;
    } else {
      try {
        const int DISABLE_HEADER_INFORMATION = 1;
        boost::archive::text_iarchive ia(ifs, DISABLE_HEADER_INFORMATION);
        ia >> *tree;
        return true;
      } catch (boost::archive::archive_exception& ex) {
        LOG(INFO) << "Reload Tree: Archive Exception during deserializing: "
                  << ex.what() << std::endl;
        LOG(INFO) << "not able to load  " << path << std::endl;
      }
    }
    return false;
  }

  static bool load_tree_binary( std::string path, Tree** tree) {
    // non clean save:
    if (boost::filesystem::exists(path + ".new")){
      // tree path exists -> failed before remove in save -> save failed between
      // ofs creation and boost::filesystem::remove -> continue from old tree
      if (boost::filesystem::exists(path)){
        LOG(INFO) << "save_tree failed before, will continue from the previous tree " << path << std::endl;
      }
      // failed after remove, but before rename. assume "tree.new" is sane
      else {
        LOG(INFO) << "save_tree did not clean up properly, resuming from  " << path << ".new" <<  std::endl;
        boost::filesystem::rename(path + ".new", path);
      }
    }

    std::ifstream ifs(path.c_str());
    if (!ifs) {
      LOG(INFO) << "tree not found " << path;
    } else {
      try {
        boost::archive::binary_iarchive ia(ifs);
        ia >> *tree;
        return true;
      } catch (boost::archive::archive_exception& ex) {
        LOG(INFO) << "Reload Tree: Archive Exception during deserializing: "
                  << ex.what() << std::endl;
        LOG(INFO) << "not able to load  " << path << std::endl;
      }
    }
    return false;
  }



private:

  // root node of the tree
  TreeNode<Sample>* root;

  boost::mt19937* rng;

  //class population
  std::vector<float> class_weights;

  // number of global attribute labels
  int num_global_attr_labels;

  //for statistic reason
  float num_nodes;
  float i_node;
  int i_leaf;

  // the lastest saving timestamp
  int last_save_point;

  // saving path of the trees
  std::string save_path;

  Timing timer;

  int num_threads;
  int logging_level;

  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {
    ar & num_nodes;
    ar & i_node;
    ar & fp;
    ar & save_path;
    ar & class_weights;
    ar & root;
    ar & num_global_attr_labels;
  }
};



} //namespace forest
} //namespace learning
#endif /* CRTREE_H_ */
