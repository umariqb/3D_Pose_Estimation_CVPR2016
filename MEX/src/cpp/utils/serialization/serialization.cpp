/*
 * serialization.cpp
 *
 *  Created on: Aug 19, 2013
 *      Author: lbossard
 */

#include "serialization.hpp"

namespace utils {
namespace serialization {

Compression::T Compression::from_string(const std::string c) {

  if (c == "gzip" || c == "gz"){
    return Compression::Gz;
  }
  else if (c =="zlib" || c == "z"){
    return Compression::Z;
  }
  else if (c == "bzip2" || c == "bz2") {
    return Compression::Bz2;
  }
  else if (c == "" || c == "none"){
      return Compression::None;
  };

  CHECK(false) << c << " is not a valid compression scheme";
  return Compression::None;

}

std::string Compression::to_string(const Compression::T& c) {

  switch (c){
    case Compression::Gz:
      return "gz";
    case Compression::Z:
      return "z";
    case Compression::Bz2:
      return "bz2";
    case Compression::None:
      return "";


    case Compression::_unused:
      CHECK(false) << c << " is not a valid compression scheme";
      return "INVALID";
  }

  CHECK(false) << c << " is not a valid compression scheme";
  return "INVALID";
}

} /* namespace serialization */
} /* namespace utils */
