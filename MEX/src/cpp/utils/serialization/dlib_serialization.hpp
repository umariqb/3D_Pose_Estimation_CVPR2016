/*
 * dlib_serialization.hpp
 *
 *  Created on: 01.03.2013
 *      Author: luk
 */

#ifndef UTILS_DLIB_SERIALIZATION_HPP_
#define UTILS_DLIB_SERIALIZATION_HPP_

#include <glog/logging.h>

#include <boost/serialization/split_free.hpp>

#include <dlib/matrix/matrix.h>
#include <dlib/svm/function.h>
#include <dlib/svm/one_vs_all_decision_function.h>

namespace detail {
template<typename sample_type, typename scalar_type>
struct copy_to_df_helper {
  copy_to_df_helper(dlib::any_decision_function<sample_type, scalar_type>& target_)
      : target(target_) {
  }

  dlib::any_decision_function<sample_type, scalar_type>& target;

  template<typename T>
  void operator()(const T& item) const {
    target = item;
  }
};

template <typename Archive>
struct serialize_helper
{
  Archive& _ar;
  serialize_helper(Archive& ar): _ar(ar) {}
  template <typename T>
  void operator() (const T& item) const { _ar & item; }
};
}


namespace boost
{
namespace serialization
{

//------------------------------------------------------------------------------
// dlib::matrix
template <typename Archive, typename T, long NR, long NC, typename mm, typename l>
void save(Archive & ar, const dlib::matrix<T,NR,NC,mm,l>& mat, const unsigned int version)
{
	long rows = mat.nr();
	long cols =  mat.nc();
	ar & rows;
	ar & cols;
    for (long row = 0; row < mat.nr(); ++row)
    {
    	for (long col = 0; col < mat.nc(); ++col)
    	{
    		ar & mat(row,col);
    	}
    }
}

template <typename Archive, typename T, long NR, long NC, typename mm, typename l>
void load(Archive & ar, dlib::matrix<T,NR,NC,mm,l>& mat, const unsigned int version)
{
	long rows = 0;
	long cols = 0;

    ar & rows;
    ar & cols;
    CHECK(NR == 0 || NR == rows) << "number of rows do not match";
    CHECK(NC == 0 || NC == cols) << "number of rows do not match";
    mat.set_size(rows,cols);
    for (long r = 0; r < rows; ++r)
    {
    	for (long c = 0; c < cols; ++c)
    	{
    		ar & mat(r,c);
    	}
    }
}


template <typename Archive, typename T, long NR, long NC, typename mm, typename l>
void serialize(Archive& ar, dlib::matrix<T,NR,NC,mm,l>& mat, const unsigned int version)
{
	::boost::serialization::split_free(ar, mat, version);
}

//------------------------------------------------------------------------------
// dlib::multiclass_linear_decision_function

template <typename Archive, typename K, typename R>
void serialize(Archive& ar,  dlib::multiclass_linear_decision_function<K,R>& fun, const unsigned int version)
{
  ar & fun.weights;
  ar & fun.b;
  ar & fun.labels;
}
//------------------------------------------------------------------------------
// dlib::_void
template <typename Archive>
void serialize(Archive& ar, dlib::_void& v, const unsigned int version)
{
}
//------------------------------------------------------------------------------
// dlib::null_df

template <typename Archive>
void serialize(Archive& ar, dlib::null_df& fun, const unsigned int version)
{
}
//------------------------------------------------------------------------------
// dlib::type_safe_union
template <
    typename Archive,
    typename T1, typename T2, typename T3, typename T4, typename T5,
    typename T6, typename T7, typename T8, typename T9, typename T10,
    typename T11, typename T12, typename T13, typename T14, typename T15,
    typename T16, typename T17, typename T18, typename T19, typename T20
    >
void save (
    Archive& ar,
    const dlib::type_safe_union<T1,T2,T3,T4,T5,T6,T7,T8,T9,T10, T11,T12,T13,T14,T15,T16,T17,T18,T19,T20>& item,
    const unsigned int version
)
{
  int type_identity = 0;
  // query type id!111
  if (item.template contains<T1>())
    type_identity = item.template get_type_id<T1>();
  else if (item.template contains<T2>())
    type_identity = item.template get_type_id<T2>();
  else if (item.template contains<T3>())
    type_identity = item.template get_type_id<T3>();
  else if (item.template contains<T4>())
    type_identity = item.template get_type_id<T4>();
  else if (item.template contains<T5>())
    type_identity = item.template get_type_id<T5>();
  else if (item.template contains<T6>())
    type_identity = item.template get_type_id<T6>();
  else if (item.template contains<T7>())
    type_identity = item.template get_type_id<T7>();
  else if (item.template contains<T8>())
    type_identity = item.template get_type_id<T8>();
  else if (item.template contains<T9>())
    type_identity = item.template get_type_id<T9>();
  else if (item.template contains<T10>())
    type_identity = item.template get_type_id<T10>();
  else if (item.template contains<T11>())
    type_identity = item.template get_type_id<T11>();
  else if (item.template contains<T12>())
    type_identity = item.template get_type_id<T12>();
  else if (item.template contains<T13>())
    type_identity = item.template get_type_id<T13>();
  else if (item.template contains<T14>())
    type_identity = item.template get_type_id<T14>();
  else if (item.template contains<T15>())
    type_identity = item.template get_type_id<T15>();
  else if (item.template contains<T16>())
    type_identity = item.template get_type_id<T16>();
  else if (item.template contains<T17>())
    type_identity = item.template get_type_id<T17>();
  else if (item.template contains<T18>())
    type_identity = item.template get_type_id<T18>();
  else if (item.template contains<T19>())
    type_identity = item.template get_type_id<T19>();
  else if (item.template contains<T20>())
    type_identity = item.template get_type_id<T20>();
  else
    throw std::runtime_error(
        "Can't serialize typesafe_union.  Not all types defined.");
  // serialize in the end
  ar & type_identity;
  item.apply_to_contents(::detail::serialize_helper<Archive>(ar));
}


template <
    typename Archive,
    typename T1, typename T2, typename T3, typename T4, typename T5,
    typename T6, typename T7, typename T8, typename T9, typename T10,
    typename T11, typename T12, typename T13, typename T14, typename T15,
    typename T16, typename T17, typename T18, typename T19, typename T20
    >
void load(
    Archive& ar,
    dlib::type_safe_union<T1,T2,T3,T4,T5,T6,T7,T8,T9,T10, T11,T12,T13,T14,T15,T16,T17,T18,T19,T20>& item,
    const unsigned int version
)
{
  typedef dlib::type_safe_union<T1,T2,T3,T4,T5,T6,T7,T8,T9,T10, T11,T12,T13,T14,T15,T16,T17,T18,T19,T20> tsu_type;

  int type_identity;
  ar & type_identity;
  switch (type_identity)
  {
    // swap an empty type_safe_union into item since it should be in the empty state
    case 0: tsu_type().swap(item); break;

    case 1: ar & item.template get<T1>();  break;
    case 2: ar & item.template get<T2>();  break;
    case 3: ar & item.template get<T3>();  break;
    case 4: ar & item.template get<T4>();  break;
    case 5: ar & item.template get<T5>();  break;

    case 6: ar & item.template get<T6>();  break;
    case 7: ar & item.template get<T7>();  break;
    case 8: ar & item.template get<T8>();  break;
    case 9: ar & item.template get<T9>();  break;
    case 10: ar & item.template get<T10>();  break;

    case 11: ar & item.template get<T11>();  break;
    case 12: ar & item.template get<T12>();  break;
    case 13: ar & item.template get<T13>();  break;
    case 14: ar & item.template get<T14>();  break;
    case 15: ar & item.template get<T15>();  break;

    case 16: ar & item.template get<T16>();  break;
    case 17: ar & item.template get<T17>();  break;
    case 18: ar & item.template get<T18>();  break;
    case 19: ar & item.template get<T19>();  break;
    case 20: ar & item.template get<T20>();  break;

    default: throw std::runtime_error("Corrupt data detected while deserializing type_safe_union");
  }
}

template <
    typename Archive,
    typename T1, typename T2, typename T3, typename T4, typename T5,
    typename T6, typename T7, typename T8, typename T9, typename T10,
    typename T11, typename T12, typename T13, typename T14, typename T15,
    typename T16, typename T17, typename T18, typename T19, typename T20
    >
void serialize(
    Archive& ar,
    dlib::type_safe_union<T1,T2,T3,T4,T5,T6,T7,T8,T9,T10, T11,T12,T13,T14,T15,T16,T17,T18,T19,T20>& item,
    const unsigned int version
)
{
  ::boost::serialization::split_free(ar, item, version);
}
//------------------------------------------------------------------------------
// dlib::linear_kernel
template <typename Archive, typename T>
void serialize(Archive& ar, dlib::linear_kernel<T>& kern, const unsigned int version){
}
//------------------------------------------------------------------------------
// dlib::sparse_linear_kernel
template <typename Archive, typename T>
void serialize(Archive& ar, dlib::sparse_linear_kernel<T>& kern, const unsigned int version){
}
//------------------------------------------------------------------------------
// dlib::decision_function<K>
template <typename Archive, typename K>
void serialize(Archive& ar, dlib::decision_function<K>& item, const unsigned int version){
  ar & item.alpha;
  ar & item.b;
  ar & item.kernel_function;
  ar & item.basis_vectors;
}

//------------------------------------------------------------------------------
// dlib::dlib::one_vs_all_decision_function

template <
    typename Archive,
    typename T,
    typename DF1, typename DF2, typename DF3,
    typename DF4, typename DF5, typename DF6,
    typename DF7, typename DF8, typename DF9,
    typename DF10
    >
void save(
    Archive& ar,
    const dlib::one_vs_all_decision_function<T, DF1, DF2, DF3, DF4, DF5, DF6, DF7, DF8, DF9, DF10>& fun,
    const unsigned int version) {


  dlib::type_safe_union<DF1, DF2, DF3, DF4, DF5, DF6, DF7, DF8, DF9, DF10> temp;
  typedef typename T::label_type result_type;
  typedef typename T::sample_type sample_type;
  typedef typename T::scalar_type scalar_type;
  typedef std::map<result_type, dlib::any_decision_function<sample_type, scalar_type> > binary_function_table;

  const unsigned long size = fun.get_binary_decision_functions().size();
  ar & size;

  for (typename binary_function_table::const_iterator i = fun.get_binary_decision_functions().begin();
      i != fun.get_binary_decision_functions().end();
      ++i) {
    // serialize label
    ar & i->first;

    if (i->second.template contains<DF1>())
      temp.template get<DF1>() = dlib::any_cast<DF1>(i->second);
    else if (i->second.template contains<DF2>())
      temp.template get<DF2>() = dlib::any_cast<DF2>(i->second);
    else if (i->second.template contains<DF3>())
      temp.template get<DF3>() = dlib::any_cast<DF3>(i->second);
    else if (i->second.template contains<DF4>())
      temp.template get<DF4>() = dlib::any_cast<DF4>(i->second);
    else if (i->second.template contains<DF5>())
      temp.template get<DF5>() = dlib::any_cast<DF5>(i->second);
    else if (i->second.template contains<DF6>())
      temp.template get<DF6>() = dlib::any_cast<DF6>(i->second);
    else if (i->second.template contains<DF7>())
      temp.template get<DF7>() = dlib::any_cast<DF7>(i->second);
    else if (i->second.template contains<DF8>())
      temp.template get<DF8>() = dlib::any_cast<DF8>(i->second);
    else if (i->second.template contains<DF9>())
      temp.template get<DF9>() = dlib::any_cast<DF9>(i->second);
    else if (i->second.template contains<DF10>())
      temp.template get<DF10>() = dlib::any_cast<DF10>(i->second);
    else
      throw std::runtime_error(
          "Can't serialize one_vs_all_decision_function.  Not all decision functions defined.");

    ar & temp;
  }
}


template <
typename Archive,
typename T,
typename DF1, typename DF2, typename DF3,
typename DF4, typename DF5, typename DF6,
typename DF7, typename DF8, typename DF9,
typename DF10
>
void load(
    Archive & ar,
    dlib::one_vs_all_decision_function<T,DF1,DF2,DF3,DF4,DF5,DF6,DF7,DF8,DF9,DF10>& fun,
    const unsigned int version
)
{

  typedef typename T::label_type result_type;
  typedef typename T::sample_type sample_type;
  typedef typename T::scalar_type scalar_type;
  typedef ::detail::copy_to_df_helper<sample_type, scalar_type> copy_to;



  unsigned long size;
  ar & size;

  typedef std::map<result_type, dlib::any_decision_function<sample_type, scalar_type> > binary_function_table;
  binary_function_table dfs;

  result_type label;
  dlib::type_safe_union<DF1,DF2,DF3,DF4,DF5,DF6,DF7,DF8,DF9,DF10> temp;
  for (unsigned long i = 0; i < size; ++i)
  {
    ar & label;
    ar & temp;
    if (temp.template contains<dlib::null_df>()){
      throw std::runtime_error("A sub decision function of unknown type was encountered.");
    }
    temp.apply_to_contents(copy_to(dfs[label]));
  }

  fun = dlib::one_vs_all_decision_function<T,DF1,DF2,DF3,DF4,DF5,DF6,DF7,DF8,DF9,DF10>(dfs);
}

template <
    typename Archive,
    typename T,
    typename DF1, typename DF2, typename DF3,
    typename DF4, typename DF5, typename DF6,
    typename DF7, typename DF8, typename DF9,
    typename DF10
    >
void serialize(Archive& ar, dlib::one_vs_all_decision_function<T,DF1,DF2,DF3,DF4,DF5,DF6,DF7,DF8,DF9,DF10>& fun, const unsigned int version)
{
  ::boost::serialization::split_free(ar, fun, version);
}


} /* namespace serialization */
} /* namespace boost */
#endif /* UTILS_DLIB_SERIALIZATION_HPP_ */
