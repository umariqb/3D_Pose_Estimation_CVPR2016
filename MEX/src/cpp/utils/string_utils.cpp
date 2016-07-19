/*
 * string_utils.cpp
 *
 *  Created on: Oct 6, 2011
 *      Author: stephaga
 */

#include "cpp/utils/string_utils.hpp"
#include <sstream>

namespace utils {


//------------------------------------------------------------------------------
const std::string bin_to_hex(const std::string& s) {
  static const char* hex = "0123456789ABCDEF";
  std::string result;
  result.resize(s.length() * 2);
  for (int i = 0; i < s.length(); ++i) {
    unsigned char c = static_cast<unsigned char>(s[i]);
    result[2 * i] = hex[c >> 4];
    result[2 * i + 1] = hex[c & 0x0F];
  }
  return result;
}

//------------------------------------------------------------------------------
void split_string(const std::string& strint_to_split, char delimiter, std::vector<std::string>* split_strings){
  split_strings->clear();
  std::stringstream ss(strint_to_split);
  std::string item;
  while(std::getline(ss, item, delimiter)) {
    split_strings->push_back(item);
  }
}

}
