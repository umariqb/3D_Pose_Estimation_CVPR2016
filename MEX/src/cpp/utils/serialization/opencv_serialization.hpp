/*
 * serialize_helper.hpp
 *
 *  Created on: Oct 12, 2011
 *      Author: lbossard
 */

#ifndef UTILS_OPENCV_SERIALIZATION_HPP_
#define UTILS_OPENCV_SERIALIZATION_HPP_

#include <boost/serialization/binary_object.hpp>
#include <boost/serialization/split_free.hpp>

#include <opencv2/core/core.hpp>

namespace boost
{
namespace serialization
{
//=============================================================================
// cv::Mat

template<class Archive>
void save(Archive & ar, const cv::Mat& mat_, const unsigned int /*version*/)
{
    cv::Mat mat = mat_;
    if (!mat_.isContinuous())
    {
        mat = mat_.clone();
    }

    int elem_type = mat.type();
    std::size_t elem_size = mat.elemSize();
    ar & mat.rows;
    ar & mat.cols;
    ar & elem_type;
    ar & elem_size;
    ar & boost::serialization::make_binary_object(mat.data, mat.step * mat.rows);
}
template<class Archive>
void load(Archive & ar, cv::Mat& mat, const unsigned int /*version*/)
{
    int rows, cols, elem_type;
    std::size_t elem_size;
    ar & rows;
    ar & cols;
    ar & elem_type;
    ar & elem_size;
    mat.create(rows, cols, elem_type);
    ar & boost::serialization::make_binary_object(mat.data, mat.step * mat.rows);
}

template<class Archive>
inline void serialize(Archive & ar, cv::Mat & mat, const unsigned int version)
{
  ::boost::serialization::split_free(ar, mat, version);
}

//=============================================================================
// cv::Mat_<T>
template <class Archive, typename T>
void save(Archive & ar, const cv::Mat_<T>& mat_, const unsigned int version)
{
    save(ar, static_cast<const cv::Mat&>(mat_), version);
}

template <class Archive, typename T>
void load(Archive & ar, cv::Mat_<T>& mat_, const unsigned int version)
{
    load(ar, static_cast<cv::Mat&>(mat_), version);

    if (static_cast<cv::Mat&>(mat_).type() != cv::DataType<T>::type )
    {
        mat_.create(0,0);
    }
}

template <class Archive, typename T>
void serialize(Archive& ar, cv::Mat_<T>& mat, const unsigned int version)
{
  ::boost::serialization::split_free(ar, mat, version);
}

//=============================================================================
// cv::Rect_<T>
template<class Archive, class T>
void serialize(Archive & ar, cv::Rect_<T>& rect, const unsigned int /*version*/)
{
    ar & rect.x;
    ar & rect.y;
    ar & rect.width;
    ar & rect.height;
}

//=============================================================================
// cv::Point_<T>
template<class Archive, class T>
void serialize(Archive & ar, cv::Point_<T>& point, const unsigned int /*version*/)
{
    ar & point.x;
    ar & point.y;
}

//=============================================================================
// cv::Size_<T>
template<class Archive, class T>
void serialize(Archive & ar, cv::Size_<T>& size, const unsigned int /*version*/)
{
    ar & size.width;
    ar & size.height;
}

//=============================================================================
// cv::PCA
template<class Archive>
void serialize(Archive & ar, cv::PCA& pca, const unsigned int /*version*/)
{
    ar & pca.eigenvalues;
    ar & pca.eigenvectors;
    ar & pca.mean;
}

}
}

#endif /* UTILS_OPENCV_SERIALIZATION_HPP_ */
