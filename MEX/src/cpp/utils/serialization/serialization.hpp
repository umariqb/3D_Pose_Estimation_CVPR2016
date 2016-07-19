/*
 * SerializationHelper.hpp
 *
 *  Created on: Oct 19, 2011
 *      Author: lbossard
 */

#ifndef UTILS_SERIALIZATIONHELPER_HPP_
#define UTILS_SERIALIZATIONHELPER_HPP_

#include <string>
#include <fstream>

#include <glog/logging.h>

#include <boost/iostreams/categories.hpp>
#include <boost/iostreams/filtering_stream.hpp>
#include <boost/iostreams/filter/gzip.hpp>
#include <boost/iostreams/filter/bzip2.hpp>
#include <boost/iostreams/filter/zlib.hpp>

#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include <boost/archive/text_iarchive.hpp>
#include <boost/archive/text_oarchive.hpp>
#include <boost/serialization/list.hpp>
#include <boost/serialization/vector.hpp>
#include <boost/serialization/utility.hpp>
#include <boost/serialization/map.hpp>


namespace utils {
namespace serialization {

struct Compression {
enum compression {
  None = 0,
  Gz,
  Z,
  Bz2,

  _unused
};
typedef compression T;
static T from_string(const std::string c);
static std::string to_string(const T& c);
};

template<typename T>
bool read_binary_archive(const std::string& file,
    T& data_structure,
    const Compression::T& compression=Compression::None);

template<typename T>
bool write_binary_archive(
    const std::string& file,
    const T& data_structure,
    const Compression::T& compression=Compression::None);


template<typename T>
bool read_simple_binary_archive(const std::string& file, T& data_structure);

template<typename T>
bool write_simple_binary_archive(const std::string& file, const T& data_structure);

template<typename T, typename decompressor>
bool read_compressed_binary_archive(const std::string& file, T& data_structure);

template<typename T, typename compressor>
bool write_compressed_binary_archive(const std::string& file, const T& data_structure);




////////////////////////////////////////////////////////////////////////////////
// implementation


template<typename T>
bool read_binary_archive(
    const std::string& file,
    T& data_structure,
    const Compression::T& compression){

  switch (compression){
    case Compression::None:
      return read_simple_binary_archive(file, data_structure);
      break;
    case Compression::Z:
      return read_compressed_binary_archive<T, boost::iostreams::zlib_decompressor>(file, data_structure);
      break;
    case Compression::Gz:
      return read_compressed_binary_archive<T, boost::iostreams::gzip_decompressor>(file, data_structure);
      break;
    case Compression::Bz2:
      return read_compressed_binary_archive<T, boost::iostreams::bzip2_decompressor>(file, data_structure);
      break;
    case Compression::_unused:
      CHECK(false) << "Unknown compression scheme " << compression;
      break;
  }
  CHECK(false) << "Unknown compression scheme " << compression;
  return false;

}

template<typename T>
bool write_binary_archive(
    const std::string& file,
    const T& data_structure,
    const Compression::T& compression){
  switch (compression){

    case Compression::None:
      return write_simple_binary_archive(file, data_structure);
      break;
    case Compression::Z:
      return write_compressed_binary_archive<T, boost::iostreams::zlib_compressor>(file, data_structure);
      break;
    case Compression::Gz:
      return write_compressed_binary_archive<T, boost::iostreams::gzip_compressor>(file, data_structure);
      break;
    case Compression::Bz2:
      return write_compressed_binary_archive<T, boost::iostreams::bzip2_compressor>(file, data_structure);
      break;
    case Compression::_unused:
      CHECK(false) << "Unknown compression scheme " << compression;
      break;
  }
  CHECK(false) << "Unknown compression scheme " << compression;
  return false;


}

template<typename T>
bool read_simple_binary_archive(const std::string& file, T& data_structure) {
  // open file
  std::ifstream istream;
  istream.open(file.c_str(), std::ios::in | std::ios::binary);
  if (!istream) {
    LOG(ERROR) << "Could not open file " << file;
    return false;
  }

  // read data structure
  try {
    boost::archive::binary_iarchive input_archive(istream);
    input_archive >> data_structure;

  }
  catch (boost::archive::archive_exception& ex) {
    LOG(ERROR) << "Deserialization error while reading file : " << ex.what();
    LOG(ERROR) << file;
    istream.close();
    return false;
  }

  // check, if stream is good
  if (istream.bad()) {
    LOG(ERROR) <<  "Error while reading file " << file;
    istream.close();
    return false;
  }
  istream.close();
  return true;
}

template<typename T>
bool write_simple_binary_archive(const std::string& file, const T& data_structure) {
  // open file
  std::ofstream ostream;
  ostream.open(file.c_str(), std::ios::out | std::ios::binary);
  if (!ostream) {
    LOG(ERROR) << "Could not open file " << file;
    return false;
  }

  // write to stream
  {
    boost::archive::binary_oarchive output_archive(ostream);
    output_archive << data_structure;
  }

  // check, if stream is good
  if (ostream.bad()) {
    LOG(ERROR) << "Error while writing file " << file;
    ostream.close();
    return false;
  }
  ostream.close();
  return true;
}

template<typename T, typename decompressor>
bool read_compressed_binary_archive(const std::string& file,
    T& data_structure) {
  // open file
  std::ifstream istream;
  istream.open(file.c_str(), std::ios::in | std::ios::binary);
  if (!istream) {
    LOG(ERROR) << "Could not open file " << file;
    return false;
  }

  // set up decompression
  boost::iostreams::filtering_stream<boost::iostreams::input> compressed_is;
  compressed_is.push(decompressor());
  compressed_is.push(istream);

  // read data structure
  try {
    boost::archive::binary_iarchive input_archive(compressed_is);
    input_archive >> data_structure;
  }
  catch (boost::archive::archive_exception& ex) {
    LOG(ERROR) << "Deserialization error while reading file : " << ex.what();
    LOG(ERROR) << file;
    istream.close();
    return false;
  }

  // check, if stream is good
  if (istream.bad()) {
    LOG(ERROR) << "Error while reading file " << file;
    istream.close();
    return false;
  }
  istream.close();
  return true;
}

template<typename T, typename compressor>
bool write_compressed_binary_archive(const std::string& file,
    const T& data_structure) {
  // open file
  std::ofstream ostream;
  ostream.open(file.c_str(), std::ios::out | std::ios::binary);
  if (!ostream) {
    LOG(ERROR) << "Could not open file " << file;
    return false;
  }

  // write to stream
  {
    // set up compression within scope as gzip_compressor flushes when f goes
    // out of scope. http://stackoverflow.com/questions/1753469
    boost::iostreams::filtering_stream<boost::iostreams::output> compressed_os;
    compressed_os.push(compressor());
    compressed_os.push(ostream);

    boost::archive::binary_oarchive output_archive(compressed_os);
    output_archive << data_structure;
  }

  // check, if stream is good
  if (ostream.bad()) {
    LOG(ERROR) << "Error while writing file " << file;
    ostream.close();
    return false;
  }
  ostream.close();
  return true;
}

}
} /* namespace utils::serialization */
#endif /* UTILS_SERIALIZATIONHELPER_HPP_ */
