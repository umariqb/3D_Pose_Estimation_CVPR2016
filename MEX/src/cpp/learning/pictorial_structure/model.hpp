/*
 * model.hpp
 *
 *  Created on: Jan 24, 2013
 *      Author: mdantone
 */

#ifndef MODEL_HPP_
#define MODEL_HPP_
#include "part.hpp"
#include <glog/logging.h>

namespace learning
{
namespace ps
{

class Model {
public:
  Model(): weight(1) {}
  ~Model(){}

  std::string get_name() const {
    return _name;
  }

  void set_name( std::string name) {
    _name = name;
  }

  // part_ids are stored in increasing order.
  void set_parts(std::vector<Part> parts, std::vector<int> parents) {
    _parts = parts;
    _parents = parents;
    CHECK_EQ( parts.size(), parents.size());
  }

  std::vector<int> get_parents() const {
    return _parents;
  }

  int get_num_parts() const {
    return _parts.size();
  }

  const Part* get_root() const {
    CHECK(_parts.size() > 0 );
    return &_parts[0];
  }

   const Part* get_part(int part_id) const {
    CHECK(part_id < _parts.size()  );
    return &_parts[part_id];
  }

  Part* get_part(int part_id) {
    CHECK(part_id < _parts.size());
    return &_parts[part_id];
  }

  int get_parent_id(int part_id) const {
    return _parents[part_id];
  }

  std::vector<int> get_children_ids(int part_id) const {
    std::vector<int> children;
    for(int i=0; i < _parts.size(); i++) {
      int parent_id = get_parent_id(i);
      if(parent_id == part_id &&
         parent_id != i &&
         parent_id >= 0 ){
        children.push_back(i);
      }
    }
    return children;
  }

  void set_voting_maps(const std::vector<cv::Mat_<float> > maps, int normalize = -1) {
    CHECK_EQ(maps.size(), _parts.size());
    for(int i=0; i < _parts.size(); i++) {
      _parts[i].set_voting_map(maps[i], normalize);
    }
  }

  void set_deformation_costs(std::vector<Displacement> deform_cost) {
    CHECK_EQ(deform_cost.size(), _parts.size());
    for(int i=0; i < _parts.size(); i++) {
      _parts[i].set_deformation_cost(deform_cost[i]);
    }
  }

  // part_ids are stored in increasing order.
  bool has_parent(int part_id) {
    return part_id != 0; //get_parent_id(part_id) < part_id;
  }

  void set_weight(float w) {
    weight = w;
  }

  float get_weight() const {
    return weight;
  }

  void prune_tree( int node_id ) {
    std::vector<int> children_id = get_children_ids(node_id);
    for(int i=0; i < children_id.size(); i++) {
      _parents[ children_id[i] ] = -1;
      prune_tree(children_id[i]);
    }
  }
private:
  std::string _name;
  std::vector<Part> _parts;
  std::vector<int> _parents;
  float weight;

};


} /* namespace ps */
} /* namespace learning */

#endif /* MODEL_HPP_ */
