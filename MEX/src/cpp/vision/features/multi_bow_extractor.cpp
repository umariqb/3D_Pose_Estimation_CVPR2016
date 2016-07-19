/*
 * multi_bow_extractor.cpp
 *
 *  Created on: Nov 10, 2011
 *      Author: lbossard
 */

#include "multi_bow_extractor.hpp"

#include <vector>
#include <tr1/unordered_map>
#include <algorithm>

#include <boost/foreach.hpp>
#include <boost/filesystem/path.hpp>
namespace fs = boost::filesystem;

#include <glog/logging.h>

#include "cpp/utils/file_utils.hpp"

#include "cpp/utils/serialization/opencv_serialization.hpp"
#include "cpp/utils/serialization/serialization.hpp"

namespace vision
{
namespace features
{

MultiBowExtractor::MultiBowExtractor()
{
    // TODO Auto-generated constructor stub

}

MultiBowExtractor::~MultiBowExtractor()
{
}
bool MultiBowExtractor::loadBows(const std::vector<fs::path>& vocs)
{
    // make sure, that the same collection stays the same
    std::vector<fs::path> vocabulary_files(vocs);
    std::sort(vocabulary_files.begin(), vocabulary_files.end());

//    vocabulary_files.resize(std::min(200UL, vocabulary_files.size()));

    cv::Mat_<float> all_vocs;
    int voc_size = -1;
    BOOST_FOREACH(const fs::path& vocabulary_file, vocabulary_files)
    {
        // read vocabulary
        cv::Mat_<float> voc;
        if (!utils::serialization::read_binary_archive(vocabulary_file.string(), voc)
            || voc.data == NULL)
        {
             LOG(ERROR) << "Could not load vocabulary '"
                     << vocabulary_file.string() << "'" << std::endl;
             return false;
        }

        if (voc_size == -1)
        {
            voc_size = voc.rows;
        }
        else if (voc.rows != voc_size)
        {
             LOG(ERROR) << "Vocabularies don't have the same size. ("<< voc_size << "!= " << voc.rows << std::endl;
             return false;
        }
        all_vocs.push_back(voc);
    }
    bow_extractor_.reset(new BowExtractor(all_vocs, cvflann::FLANN_INDEX_KDTREE));
    words_per_voc_ = voc_size;
    /*
     * For non equal sized vocs: record start_id of the particular vocabulary.
     * the voc_id for a given word id can then be found via
     * int voc_id = std::upper_bound(voc_indexes.begin(), voc_indexes.end(), words[idx]) - voc_indexes.begin() - 1;
     */
    return true;
}

/**
 * Matches the features to all known words.
 * @param low_level_features
 * @param visual_words
 */
void MultiBowExtractor::match(const cv::Mat_<float>& low_level_features, std::vector<BowExtractor::WordId>& visual_words)
{
    bow_extractor_->match(low_level_features, visual_words);
}

/**
 * Matches each feature to the vocabulary
 * Returns not the word id, but the id of the particular vocabulary
 * @param low_level_features
 * @param visual_words
 */
void MultiBowExtractor::matchVocabulary(const cv::Mat_<float>& low_level_features, std::vector<BowExtractor::WordId>& visual_words)
{
    bow_extractor_->match(low_level_features, visual_words);
    for (unsigned int i = 0; i < visual_words.size(); ++i)
    {
        visual_words[i] = wordToVocabularyId(visual_words[i]);
    }
}

/**
 * Matches the features to its k nearest visual words and returns the dominant
 * class.
 * @param low_level_features
 * @param visual_words
 * @param k
 */
void MultiBowExtractor::matchVocabularyKnn(
        const cv::Mat_<float>& low_level_features,
        std::vector<BowExtractor::WordId>& visual_words,
        unsigned int k)
{
     static cv::Mat_<BowExtractor::WordId> indices;
     static cv::Mat_<float> dists;

     typedef std::tr1::unordered_map<VocabularyId, unsigned int> VoteMap;
     VoteMap vote_map;

     bow_extractor_->match(low_level_features, indices, dists, k);
     visual_words.resize(indices.rows);
     for (unsigned int r = 0; r < indices.rows; ++r)
     {
         // cast vote for classes
         vote_map.clear();
         for (unsigned int c = 0; c < indices.cols; ++c)
         {
             ++vote_map[wordToVocabularyId(indices(r,c))];
         }

         // find max
         VocabularyId max_id = 0;
         unsigned int max_count = 0;
         BOOST_FOREACH(const VoteMap::value_type& item, vote_map)
         {
             if (item.second > max_count)
             {
                 max_id = item.first;
                 max_count = item.second;
             }
         }

         visual_words[r] = max_id;
     }
}

} /* namespace features */
} /* namespace vision */
