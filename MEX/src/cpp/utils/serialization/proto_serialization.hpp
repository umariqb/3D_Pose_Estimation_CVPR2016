/*
 * proto_serialization.hpp
 *
 *  Created on: Jan 13, 2014
 *      Author: mdantone
 */

#ifndef PROTO_SERIALIZATION_HPP_
#define PROTO_SERIALIZATION_HPP_

#include <google/protobuf/text_format.h>
#include <google/protobuf/io/zero_copy_stream_impl.h>
#include <glog/logging.h>
#include <fstream>
#include <fcntl.h>


namespace utils {
namespace serialization {

//template<typename T>
//bool read_binary_archive(const std::string& file,
//    T& data_structure,
//    const Compression::T& compression=Compression::None);
//
//template<typename T>
//bool write_binary_archive(
//    const std::string& file,
//    const T& data_structure,
//    const Compression::T& compression=Compression::None);


template<typename T>
bool read_text_archive(const std::string& file_name,
    T& data_structure);

//template<typename T>
//bool write_binary_archive(
//    const std::string& file,
//    const T& data_structure);




////////////////////////////////////////////////////////////////////////////////
// implementation


template<typename T>
bool read_text_archive( const std::string& file_name,
    T& data_structure){

  int fileDescriptor = open(file_name.c_str(), O_RDONLY);
  if( fileDescriptor < 0 ) {
    LOG(INFO) << " Error opening the file "<< file_name;
    return false;
  }

  google::protobuf::io::FileInputStream fileInput(fileDescriptor);
  fileInput.SetCloseOnDelete( true );
  if(google::protobuf::TextFormat::Parse(&fileInput, &data_structure)) {
    return true;
  }else{
    LOG(INFO) << "Failed to parse file: " << file_name;
    return false;
  }
}



} /* namespace utils */
} /* namespace serialization */
#endif /* PROTO_SERIALIZATION_HPP_ */
