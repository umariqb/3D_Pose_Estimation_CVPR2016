/*
 * Tree.h
 *
 *  Created on: May 2, 2011
 *      Author: Matthias Dantone
 */

#ifndef TREE_NODE_H_
#define TREE_NODE_H_

#include <vector>


#include "cpp/learning/forest/param.hpp"

namespace learning
{
namespace forest
{

template<typename Sample>
class TreeNode {
public:
  typedef typename Sample::Split Split;
  typedef typename Sample::Leaf Leaf;

  TreeNode() :
       _right_node(0), _left_node(0), _depth(-1), _is_leaf(false), _is_split(false) {
  };

  TreeNode(int depth_) :
       _right_node(0), _left_node(0), _depth(depth_), _is_leaf(false), _is_split(false) {
  };

  void create_leaf(const std::vector<Sample*>& data, const std::vector<float>& weightClasses, int iLeaf = -1) {

    Sample::create_leaf(_leaf, data, weightClasses, iLeaf);
    _is_leaf = true;
    _is_split = false;
  };

  const Leaf* leaf() const {
    return &_leaf;
  }

  Leaf* get_leaf() {
    return &_leaf;
  }

  const Split* split() const {
    return &_split;
  }

  Split* get_split() {
    return &_split;
  }

  void set_split(Split split_) {
    _is_split = true;
    _is_leaf = false;
    _split = split_;
  }

  void set_leaf(Leaf leaf_) {
    _is_leaf = true;
    _is_split = false;
    _leaf = leaf_;
    if (_left_node) {
      delete _left_node;
      _left_node = 0;
    }
    if (_right_node) {
      delete _right_node;
      _right_node = 0;
    }

  }

  void set_childs(TreeNode<Sample>* leftChild, TreeNode<Sample>* rightChild ) {
    _is_split = true;
    _left_node = leftChild;
    _right_node = rightChild;
    _is_leaf = false;
  };

  void add_left_child(TreeNode<Sample>* leftChild) {
    _left_node = leftChild;
  };

  void add_right_child(TreeNode<Sample>* rightChild) {
    _right_node = rightChild;
  };

  bool eval(const Sample* s) const {
    return _split.eval(s);
  }

  bool is_leaf() const {
    return _is_leaf;
  };

  bool is_split() const {
    return _is_split;
  };

  int get_depth() const {
    return _depth;
  };
  void collect_leafs(std::vector<const Leaf*>& leafs) const {
    if (!_is_leaf) {
      _right_node->collect_leafs(leafs);
      _left_node->collect_leafs(leafs);
    } else {
      leafs.push_back(&_leaf);
    }
  };

  void collect_splits(std::vector<const Split*>& splits) const {
    if (!_is_leaf) {
      splits.push_back(&_split);
      _right_node->collect_splits(splits);
      _left_node->collect_splits(splits);
    }
  };


  const TreeNode<Sample>* right_node() {
    return _right_node;
  }

  TreeNode<Sample>* get_right_node() {
    return _right_node;
  }

  const TreeNode<Sample>* left_node() {
    return _left_node;
  }

  TreeNode<Sample>* get_left_node() {
      return _left_node;
    }

  ~TreeNode() {
    if (!_is_leaf) {
      if (_left_node)
        delete _left_node;
      if (_right_node)
        delete _right_node;
    }
  };

private:

  TreeNode<Sample>* _right_node;
  TreeNode<Sample>* _left_node;

  int _depth;
  Leaf _leaf;
  Split _split;


  bool _is_leaf;
  bool _is_split;

  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {
    ar & _depth;
    ar & _is_leaf;
    ar & _is_split;
    if (_is_split) {
      ar & _split;
    }
    if (!_is_leaf) {
      ar & _left_node;
      ar & _right_node;
    } else {
      ar & _leaf;
    }
  }
};

} //namespace forest

} //namespace learning

BOOST_CLASS_VERSION(learning::forest::ForestParam, 1);


#endif /* TREE_NODE_H_ */

