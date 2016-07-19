/*
 * forest.hpp
 *
 *  Created on: May 4, 2011
 *      Author: Matthias Dantone
 */

#ifndef FOREST_HPP_
#define FOREST_HPP_

#include "cpp/learning/common/classifier_interface.hpp"
#include "cpp/learning/forest/tree.hpp"

namespace learning {
namespace forest {

template<typename Sample>
class Forest : public learning::common::ClassifierInterface<Sample> {
public:
  typedef typename Sample::Split Split;
  typedef typename Sample::Leaf Leaf;
  Forest() { };
 
  Forest(const std::vector<Sample*> data, ForestParam tp, boost::mt19937* rng) {
    for (int i = 0; i < tp.num_trees; i++) {
      Tree<Sample>* tree = new Tree<Sample>(data, tp, rng);
      trees.push_back(tree);
    }
  };

  void addTree(Tree<Sample>* t) {
    trees.push_back(t);
  }

  //sends the Sample down the tree
  void evaluate(const Sample* f, std::vector<Leaf*>& leafs) const {
    for (unsigned int i = 0; i < trees.size(); i++)
      trees[i]->evaluate(f, trees[i]->root_node(), leafs);
  }

	double predict(const Sample& sample) const {
		std::vector<Leaf*> leafs;
    for (unsigned int i = 0; i < trees.size(); i++) {
      trees[i]->evaluate(&sample, trees[i]->root_node(), leafs);
		}
		double res = 0.0;
		for (size_t i = 0; i < leafs.size(); ++i) {
			res += leafs[i]->forground;
		}
		return res / leafs.size();
	}

	static void evaluate_tree(const Sample* f, const Tree<Sample>* tree,
													  std::vector<Leaf*>* leafs) {
		tree->evaluate(f, tree->root_node(), *leafs);
	}

	// Multi-threaded evaluation: one thread for each tree.
	void evaluate_parallel(const Sample* f, std::vector<Leaf*>& leafs,
                         int num_threads = 0) const {

    if(num_threads < 1){
      num_threads = ::utils::system::get_available_logical_cpus();
    }
		if (num_threads > 1) {
			std::vector<std::vector<Leaf*> > local_leafs(trees.size());
      boost::thread_pool::executor e(num_threads);
			for (unsigned int i = 0; i < trees.size(); i++) {
				e.submit(boost::bind(&Forest::evaluate_tree, f, trees[i], &local_leafs[i]));
			}
			e.join_all();

			leafs.clear();
			for (unsigned int i = 0; i < trees.size(); i++) {
				leafs.insert(leafs.end(), local_leafs[i].begin(), local_leafs[i].end());
			}
		} else {
			evaluate(f, leafs);
		}
	}

  void evaluate_mt(const Sample* f, Leaf** leafs) const {
    for (unsigned int i = 0; i < trees.size(); i++) {
      trees[i]->evaluate_mt(f, trees[i]->root_node(), leafs);
      leafs++;
    }
  }

  //stores the tree
  void save(std::string url, bool textTree, int offset = 0) const {
    for (unsigned int i = 0; i < trees.size(); i++) {
      char buffer[200];
      sprintf(buffer, "%s%03d.txt", url.c_str(), i + offset);

      std::string path = buffer;
      CHECK(Tree<Sample>::save_tree(path, trees[i], textTree));
    }
  }

	static bool load_forest(std::string config_file,
													Forest<Sample>* forest,
                                                    bool loadBinary,
													int num_trees = -1) {
		ForestParam param;
		if(loadConfigFile(config_file, param)) {
            return load_forest(param, forest, loadBinary, num_trees);
		}
		return false;
	}

  static bool load_forest(ForestParam param,
                          Forest<Sample>* forest,
                          bool loadBinary,
                          int num_trees = -1) {
    forest->load(param.tree_path, param, loadBinary, num_trees);
    return forest->trees.size() > 0;
  }

  bool load(std::string url, ForestParam tp, bool loadBinary, int max_trees = -1) {

    if (max_trees == -1)
      max_trees = tp.num_trees;

    for (int i = 0; i < tp.num_trees; i++) {
      if (static_cast<int>(trees.size()) >= max_trees)
        continue;
      char buffer[200];
      sprintf(buffer, "%s%03d.txt", url.c_str(), i);
      std::string tree_path = buffer;
      load_tree(tree_path, trees, loadBinary);
    }

    LOG(INFO) << trees.size() << " of "<< tp.num_trees << " loaded.";
    return trees.size() > 0;
  }


  static bool load_tree(std::string url, std::vector<Tree<Sample>*>& trees, bool loadBinary) {

    Tree<Sample>* tree;
    if( Tree<Sample>::load_tree(url,&tree, loadBinary)) {

      if (tree->isFinished()) {
        trees.push_back(tree);
      } else {
       // delete tree;
        return false;
      }
      return true;
    }
    return false;
  }

  void prune_trees( int max_depth) {
    for (unsigned int i = 0; i < trees.size(); i++) {
      trees[i]->prune(max_depth);
    }
  }

  ForestParam getParam() const {
    CHECK_GT(trees.size(), 0);
    return trees[0]->get_param();
  }

  std::vector<float> get_class_weights() const {
    CHECK_GT(trees.size(), 0);
    return trees[0]->get_class_weights();
  }


  void get_all_leafs(std::vector<std::vector<const Leaf*> >& leafs) const{
    leafs.resize(trees.size());
    for (unsigned int i = 0; i < trees.size(); i++)
      trees[i]->root_node()->collect_leafs(leafs[i]);
  }


  void get_all_splits(std::vector<std::vector<const Split*> >& splits) const {
    splits.resize(trees.size());
    for (unsigned int i = 0; i < trees.size(); i++)
      trees[i]->root_node()->collect_splits(splits[i]);
  }

  std::vector<Tree<Sample>*> trees;

private:
  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, const unsigned int version) {
    ar & trees;
  }

};

} //namespace forest

} //namespace learning
#endif /* FOREST_H_ */
