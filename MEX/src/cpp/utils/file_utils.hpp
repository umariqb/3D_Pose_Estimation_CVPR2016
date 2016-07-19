/*
 * FileUtils.hpp
 *
 *  Created on: Oct 19, 2011
 *      Author: lbossard
 */

#ifndef FILE_UTILS_HPP_
#define FILE_UTILS_HPP_

#include <iterator>
#include <string>
#include <algorithm>

#include <boost/filesystem/path.hpp>
#include <boost/filesystem/operations.hpp>
#include <boost/regex.hpp>
#include <boost/random/mersenne_twister.hpp>

#include "cpp/utils/data_structure/fixed_priority_queue.hpp"

namespace utils
{
namespace fs
{

/**
 * Recursively adds all files from a path to the insert iterator.
 * Ex:
 *   std::vector<boost::filesystem::path> images;
 *   utils::fs::collect_files(image_dir, ".*\\.jpg", std::back_inserter(images));
 * @param path
 * @param pattern
 * @param insert_iterator
 */
template<typename T>
inline void collect_files(const std::string& path, std::string pattern, T insert_iterator);

/**
 * Collects a uniformly sampled portion of files from path.
 * @param path to recursively search
 * @param max_files maximum number of files to search
 * @param pattern_str pattern to match
 * @param insert_iterator insert iterator
 * @param rng random number generator object
 */
template<typename T, typename RNG>
inline void collect_rand_files(
        const std::string& path,
        std::size_t max_files,
        std::string pattern_str,
        T insert_iterator,
        RNG rng);

/**
 * seeded with current time at first call
 * @param path
 * @param max_files
 * @param pattern
 * @param insert_iterator
 */
template<typename T>
inline void collect_rand_files(
        const std::string& path,
        std::size_t max_files,
        std::string pattern,
        T insert_iterator);


void collect_images(
		const std::string& input_path,
		std::vector<boost::filesystem::path>* image_paths);


void collect_directories(
    const std::string& input_path,
    std::vector<boost::filesystem::path>* paths);

////////////////////////////////////////////////////////////////////////////////
// implementation


template<typename T>
inline void collect_rand_files(
        const std::string& path,
        std::size_t max_files,
        std::string pattern,
        T insert_iterator)
{
    typedef boost::mt19937 RNGType;
    static RNGType rng(static_cast<unsigned int>(std::time(0)));
    collect_rand_files<T, RNGType>(path, max_files, pattern, insert_iterator, rng);
}

template<typename T, typename RNG>
inline void collect_rand_files(
        const std::string& path,
        std::size_t max_files,
        std::string pattern_str,
        T insert_iterator,
        RNG rng)
{
    namespace fs = boost::filesystem;
    typedef std::pair<unsigned int, fs::path> PathEntry;
    typedef utils::data_structure::FixedPriorityQueue<PathEntry> FixedQueue;
    typedef fs::recursive_directory_iterator FsIt;
    FixedQueue fixed_heap(max_files);

    /*
     * go through all the files. generate for each file a random number.
     * we keep the files with the max_files number smallest/biggest rand
     * numbers
     */
    const FsIt fs_end;
    boost::regex pattern(pattern_str);
    for (FsIt it(path, fs::symlink_option::recurse); it != fs_end; ++it)
    {
        const fs::path& entry = *it;
        if (!fs::is_directory(entry)
                && boost::regex_match(entry.filename().string(), pattern))
        {
            fixed_heap.push(std::make_pair(rng(), entry));
        }
    }

    // copy paths to the output
    const FixedQueue::iterator end = fixed_heap.end();
    FixedQueue::iterator it = fixed_heap.begin();
    while (it != end)
    {
        (*insert_iterator) = it->second;
        ++insert_iterator;
        ++it;
    }
}

//------------------------------------------------------------------------------
template<typename T>
struct FileCollectIterator : public std::iterator<std::output_iterator_tag, void, void, void, void>
{
    FileCollectIterator(T insert_iterator, std::string pattern=".*");

    FileCollectIterator operator=(const boost::filesystem::path& path);
    FileCollectIterator& operator*();
    FileCollectIterator& operator++();
    FileCollectIterator operator++(int);

private:
    boost::regex pattern_;
    T insert_iterator_;
};

template<typename T>
inline FileCollectIterator<T> make_file_collector(T insert_iterator, std::string pattern)
{
    return FileCollectIterator<T>(insert_iterator, pattern);
}

//------------------------------------------------------------------------------

template<typename T>
inline void collect_files(const std::string& path, std::string pattern, T insert_iterator)
{
    std::copy(
        boost::filesystem::recursive_directory_iterator(path, boost::filesystem::symlink_option::recurse),
        boost::filesystem::recursive_directory_iterator(),
        make_file_collector(insert_iterator, pattern));
}


//------------------------------------------------------------------------------
// FileCollectIterator
template<typename T>
FileCollectIterator<T>::FileCollectIterator(T insert_iterator, std::string pattern)
: pattern_(pattern, boost::regex::icase),
  insert_iterator_(insert_iterator)
{
}

template<typename T>
FileCollectIterator<T> FileCollectIterator<T>::operator=(const boost::filesystem::path& path)
{
    namespace fs = boost::filesystem;
    if (!fs::is_directory(path)
        && boost::regex_match(path.filename().string(), pattern_))
    {
        (*insert_iterator_) = path;
        ++insert_iterator_;
    }
    return *this;
}

template<typename T>
FileCollectIterator<T> & FileCollectIterator<T>::operator*()
{
    return *this;
}

template<typename T>
FileCollectIterator<T> & FileCollectIterator<T>::operator++()
{
    return *this;
}

template<typename T>
FileCollectIterator<T> FileCollectIterator<T>::operator++(int)
{
    return *this;
}

}} /* namespace utils */

#endif /* FILE_UTILS_HPP_ */

