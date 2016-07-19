/*
 * FileUtils.cpp
 *
 *  Created on: Oct 19, 2011
 *      Author: lbossard
 */

#include "file_utils.hpp"
#include <boost/filesystem/path.hpp>
#include <boost/filesystem/operations.hpp>

namespace utils
{
namespace fs
{

namespace bfs = boost::filesystem;

//------------------------------------------------------------------------------
void collect_images(const std::string& input_path, std::vector<bfs::path>* image_paths)
{
  collect_files(
      input_path,
      ".*\\.(jpg|jpeg|gif|png|bmp|tiff)",
      std::back_inserter(*image_paths));
  std::sort(image_paths->begin(), image_paths->end());
}

void collect_directories( const std::string& input_path, std::vector<bfs::path>* paths) {

  bfs::directory_iterator end_iter;
  if (bfs::is_directory(input_path)) {
    for( bfs::directory_iterator dir_iter(input_path) ; dir_iter != end_iter ; ++dir_iter) {
       if (bfs::is_directory(dir_iter->status()) ) {
         paths->push_back(*dir_iter);
       }
     }

    // sort the paths
    std::sort(paths->begin(), paths->end());
  }
}

}} /* namespace utils */
