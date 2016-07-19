/*
 * lib_svm_common.hpp
 *
 *  Created on: Oct 25, 2011
 *      Author: lbossard
 */

#ifndef UTLS_LIBSVM_LIB_SVM_COMMON_HPP_
#define UTLS_LIBSVM_LIB_SVM_COMMON_HPP_


#include <vector>
#include <iosfwd>

#include <opencv2/core/core.hpp>

namespace utils
{
namespace libsvm
{

struct PowerFunction;
struct SomeLogisticFunction;
struct SomeOtherLogisticFunction;
struct IdentityFunction;
struct OneFunction;
struct ClippFunction;
struct ClippnScaleFunction;
struct MinMaxFunction;



////////////////////////////////////////////////////////////////////////////////
//

struct ScaleFunction
{
    ScaleFunction(double scale_factor) : scale_factor_(scale_factor) {};

    template <typename T>
    inline double operator()(T x) const
    {
        return static_cast<double>(x) / scale_factor_;
    }
    double scale_factor_;
};

struct PowerFunction
{
    PowerFunction(double m) : m_(m){};

    template <typename T>
    inline double operator()(T x) const
    {
        return std::pow(x, 1.0/m_);
    }

    double m_;
};

struct SomeLogisticFunction
{
    template <typename T>
    inline double operator()(T x) const
    {
        return 2 * (1./(1 + std::exp(-x))-.5);
    }
};
struct SomeOtherLogisticFunction
{
    template <typename T>
    inline double operator()(T x) const
    {
        return 1./(1. + std::exp(-(x - 10)));
    }
};
struct IdentityFunction
{
    template <typename T>
    inline double operator()(T x) const
    {
        return static_cast<double>(x);
    }
};

struct OneFunction
{
    template <typename T>
    inline double operator()(T x) const
    {
        return static_cast<double>(1);
    }
};

struct ClippFunction
{
    ClippFunction(double max_val) : max_val_(max_val) {};

    template <typename T>
    inline double operator()(T x) const
    {
        return std::min(static_cast<double>(x), max_val_);
    }
    double max_val_;
};

struct ClippnScaleFunction
{
    ClippnScaleFunction(double max_val) : max_val_(max_val) {};

    template <typename T>
    inline double operator()(T x) const
    {
        return std::min(static_cast<double>(x), max_val_)/max_val_;
    }
    double max_val_;
};


struct MinMaxFunction
{
    MinMaxFunction(double min_val, double max_val) : min_val_(min_val),max_val_(max_val) {};

    template <typename T>
    inline double operator()(T x) const
    {
        return std::max(std::min(static_cast<double>(x), min_val_), max_val_)/max_val_;
    }
    double min_val_;
    double max_val_;
};
////////////////////////////////////////////////////////////////////////////////
//
template <typename T, typename Fun>
void write_libsvm_vector(std::ostream& output, const cv::Mat_<T>& histos, const Fun& feature_function)
{
    const cv::Mat_<T> histo = histos.reshape(1);
    assert( histo.rows == 1);
    for (int i = 0; i < histo.cols; ++i)
    {
        T h = histo(i);
        if (h != static_cast<T>(0))
        {
            output << (i + 1) << ":" << feature_function(h) << " ";
        }
    }
}

template <typename T>
void write_libsvm_vector_mpool(std::ostream& output, const cv::Mat_<T>& histos, const int m)
{
    write_libsvm_vector(output, histos, PowerFunction(m));
}

template <typename T>
void write_libsvm_vector_max_pool(std::ostream& output, const cv::Mat_<T>& histos)
{
    write_libsvm_vector(output, histos, OneFunction());
}

////////////////////////////////////////////////////////////////////////////////
//

template <typename T, typename F, typename Fun>
void convert_features(const cv::Mat_<T>& vec, std::vector<F>& features, const Fun& fun)
{
    features.clear();
    cv::MatConstIterator_<T> it(vec.begin());
    const cv::MatConstIterator_<T> end = vec.end();
    T value = 0;
    F node;
    for (int index = 1; it < end; ++it, ++index)
    {
        value = *it;
        if (value != static_cast<T>(0) )
        {
            node.index = index;
            node.value = fun(value);
            features.push_back(node);
        }
    }

    // add last element
    node.index = -1;
    node.value = 0;
    features.push_back(node);
}

template <typename T, typename F, typename Fun>
void convert_features_masked(const cv::Mat_<T>& vec, std::vector<F>& features, const Fun& fun, const cv::Mat_<unsigned char>& mask)
{
    assert( mask.rows == vec.rows);
    features.clear();

    cv::MatConstIterator_<unsigned char> it_mask = mask.begin();
    cv::MatConstIterator_<T> it(vec.begin());
    const cv::MatConstIterator_<T> end = vec.end();
    T value = 0;
    unsigned int mask_val = 0;
    F node;
    for (int index = 1; it < end; ++it, ++index, ++it_mask)
    {
        value = *it;
        mask_val = *it_mask;
        if (mask_val != 0 and value != static_cast<T>(0) )
        {
            node.index = index;
            node.value = fun(value);
            features.push_back(node);
        }
    }

    // add last element
    node.index = -1;
    node.value = 0;
    features.push_back(node);
}

template <typename T, typename F>
void convert_features_max_pool(const cv::Mat_<T>& vec, std::vector<F>& features)
{
    convert_features(vec, features, OneFunction());
}


template <typename T, typename F, typename Fun>
void convert_features(const cv::Mat_<T>& vec, std::vector<F>& features, const Fun& fun, const cv::Mat_<unsigned char>& mask)
{
    if (mask.data)
    {
        convert_features_masked(vec, features, fun, mask);
    }
    else
    {
        convert_features(vec, features, fun);
    }
}

template <typename T, typename F>
void convert_features(const cv::Mat_<T>& vec, std::vector<F>& features, const cv::Mat_<unsigned char>& mask)
{
    convert_features(vec, features, IdentityFunction(), mask);
}


} /* namespace libsvm */
} /* namespace utils */
#endif /* UTLS_LIBSVM_LIB_SVM_COMMON_HPP_ */
