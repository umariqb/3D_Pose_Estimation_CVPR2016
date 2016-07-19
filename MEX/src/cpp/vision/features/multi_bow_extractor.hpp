/*
 * multi_bow_extractor.hpp
 *
 *  Created on: Nov 10, 2011
 *      Author: lbossard
 */

#ifndef MULTI_BOW_EXTRACTOR_HPP_
#define MULTI_BOW_EXTRACTOR_HPP_

#include <string>
#include <vector>

#include <boost/scoped_ptr.hpp>
#include <boost/filesystem/path.hpp>

#include <opencv2/core/core.hpp>

#include "bow_extractor.hpp"

namespace vision
{
namespace features
{

/**
 *
 */
class MultiBowExtractor
{
public:
    typedef BowExtractor::WordId WordId;
    typedef int VocabularyId;


    MultiBowExtractor();
    virtual ~MultiBowExtractor();

    bool loadBows(const std::vector<boost::filesystem::path>& vocabulary_files);

    void match(
            const cv::Mat_<float>& low_level_features,
            std::vector<WordId>& visual_words);

    void matchVocabulary(
            const cv::Mat_<float>& low_level_features,
            std::vector<VocabularyId>& visual_words);

    void matchVocabularyKnn(
            const cv::Mat_<float>& low_level_features,
            std::vector<VocabularyId>& visual_words,
            unsigned int k);

    inline WordId maxWordId() const;

    inline VocabularyId maxVocabularyId() const;

    inline std::size_t wordCount() const;

    inline VocabularyId wordToVocabularyId(WordId wordId) const;

private:
    boost::scoped_ptr<BowExtractor> bow_extractor_;
    std::size_t words_per_voc_;
};



////////////////////////////////////////////////////////////////////////////////
// implementation

inline MultiBowExtractor::WordId
MultiBowExtractor::maxWordId() const
{
    return bow_extractor_->maxWordId();
}

inline MultiBowExtractor::VocabularyId
MultiBowExtractor::maxVocabularyId() const
{
    return wordToVocabularyId(maxWordId());
}

inline std::size_t MultiBowExtractor::wordCount() const
{
    return bow_extractor_->wordCount();
}

inline MultiBowExtractor::VocabularyId
MultiBowExtractor::wordToVocabularyId(WordId wordId) const
{
    return wordId / words_per_voc_;
}
} /* namespace features */
} /* namespace vision */



#endif /* MULTI_BOW_EXTRACTOR_HPP_ */
