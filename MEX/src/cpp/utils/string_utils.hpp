/*
 * string_utils.hpp
 *
 *  Created on: Sep 29, 2011
 *      Author: stephaga
 */

#ifndef STRING_UTILS_HPP_
#define STRING_UTILS_HPP_

#include <string>
#include <glog/logging.h>
#include <vector>
#include <sstream>

namespace utils {

/**
 * Encodes the binary string s into a hex representation
 * @param s
 * @return
 */
const std::string bin_to_hex(const std::string& s);

/**
 * Splits a string at a given delimiter
 * @param strint_to_split
 * @param delimiter
 * @param split_strings
 */
void split_string(const std::string& strint_to_split, char delimiter, std::vector<std::string>* split_strings);



template <typename T>
std::string inline VectorToString(const std::vector<T>& v) {
  std::stringstream ss;
  ss << "[ ";
  for(unsigned int i=0; i < v.size(); i++){
    ss << v[i] ;
    if( i+1 < v.size())
      ss << ", ";
  }
  ss << " ]";
  return ss.str();
}

template<typename T>
std::string inline num2str(T num){
  std::ostringstream convert;
  convert<<num;
  std::string Result = convert.str();
  return Result;
}

}

#endif /* STRING_UTILS_HPP_ */
