/*
 * local_word_container.hpp
 *
 *  Created on: Sep 12, 2012
 *      Author: lbossard
 */

#ifndef VISON__FEATURES__LOCAL_WORD_CONTAINER_HPP_
#define VISON__FEATURES__LOCAL_WORD_CONTAINER_HPP_

#include <vector>

#include <boost/serialization/access.hpp>
#include <boost/serialization/vector.hpp>

#include <opencv2/core/core.hpp>

#include "cpp/vision/features/bow_histogram.hpp"
#include "cpp/utils/serialization/opencv_serialization.hpp"


namespace vision
{
namespace features
{

class LocalWordContainer
{
public:
	typedef int32_t Word;
	typedef cv::Mat_<Word> Words;
	typedef std::vector<cv::Point> Locations;

	LocalWordContainer();
	virtual ~LocalWordContainer();

	inline Locations& locations(){ return locations_;};
	inline const Locations& locations() const { return locations_;};
	inline Words& words() { return words_;};
	inline const Words& words() const { return words_;};
	inline int32_t wordCount() const { return wordCount_;};
	inline void setWordCount(Word word_count) {wordCount_ = word_count;};
	inline cv::Rect& rect(){ return rect_;};
	inline const cv::Rect& rect() const { return rect_;};

	void clear();


	template <typename T>
	void getBow(
			const cv::Rect& rect,
			const int pyramid_levels,
			cv::Mat_<T>& histogram
	) const;

  template <typename T>
  void getBow(
      const int pyramid_levels,
      cv::Mat_<T>& histogram
  ) const;

  template <typename T>
    void getBow(
        const cv::Rect& rect,
        const int pyramid_levels,
        BowHistogram_<T>& histogram
    ) const;

    template <typename T>
    void getBow(
        const int pyramid_levels,
        BowHistogram_<T>& histogram
    ) const;



private:
	// members
	Locations locations_;	// location relative to rect
	Words words_;
	Word wordCount_;
	cv::Rect rect_; // rectangle, where the features where extracted in the image

	friend class boost::serialization::access;
	template <class Archive>
	void serialize(Archive& archive, const unsigned int /*version*/)
	{
		archive & rect_;
		archive & locations_;
		archive & wordCount_;
		archive & words_;
	}

};

////////////////////////////////////////////////////////////////////////////////
// implementation

template <typename T>
void
LocalWordContainer::getBow(
    const int pyramid_levels,
    cv::Mat_<T>& histogram
    ) const
{
  getBow(rect_, pyramid_levels, histogram);
}

template <typename T>
void
LocalWordContainer::getBow(
    const cv::Rect& roi,
    const int pyramid_levels,
    cv::Mat_<T>& histogram
    ) const
{
  histogram = 0;

  if (!words_.data || words_.rows == 0)
  {
    return;
  }

  BowExtractor::sumPool(
      words_.col(0),
      locations_,
      roi,
      cv::Mat_<uchar>(),
      wordCount_,
      pyramid_levels,
      histogram);
}

template <typename T>
void
LocalWordContainer::getBow(
    const int pyramid_levels,
    BowHistogram_<T>& histogram
    ) const
{
  getBow(rect_, pyramid_levels, histogram);
}

template <typename T>
void
LocalWordContainer::getBow(
		const cv::Rect& roi,
		const int pyramid_levels,
		BowHistogram_<T>& histogram
		) const
{

	typename BowHistogram_<T>::Histogram h;
	getBow(roi, pyramid_levels, h);
	histogram.set(h, 0, wordCount_);

}

} /* namespace features */
} /* namespace vision */
#endif /* VISON__FEATURES__LOCAL_WORD_CONTAINER_HPP_ */
