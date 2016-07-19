/*
 * image_file_utils.hpp
 *
 *  Created on: Apr 24, 2013
 *      Author: gandrada
 */

#ifndef UTILS_IMAGE_FILE_UTILS_HPP_
#define UTILS_IMAGE_FILE_UTILS_HPP_

#include <boost/filesystem.hpp>
#include <opencv2/opencv.hpp>

namespace utils {
namespace image_file {

// Load paths from index_file.
bool load_paths(const std::string& index_file,
								std::vector<boost::filesystem::path> & paths);

// Load at most num_images from the index file.
// The flag parameter is passed to cv::imread.
bool load_images(const std::string& index_file,
								 std::vector<cv::Mat>& images, int num_images = -1,
								 int flag = 1);

// Load at most num_images from the paths list.
// The flag parameter is passed to cv::imread.
bool load_images(const std::vector<boost::filesystem::path> paths,
								 std::vector<cv::Mat>& images, int num_images = -1,
								 int flag = 1);

// Reads all the images in the index_file and merges them into larger images
// by concatenating batch_size small images in each larger image. The images
// need to be square of the given image_size.
bool create_big_images(const std::string& index_file,
											 const std::string& out_dir,
											 int image_size, int batch_size = 1000);

// Loads individual images from larger images created with create_big_images.
bool load_big_images(const std::string& index_file, int image_size,
										 std::vector<cv::Mat>& images);

// Samples at most image_count images from the large images in index_file.
// Note that the images in a batch (large file) are always loaded together and
// not randomized.
bool sample_big_images(const std::string& index_file, int image_count,
											 int image_size, std::vector<cv::Mat>& images);

// Load at most num_images from the paths list.
// The flag parameter is passed to cv::imread.
// images are downscaled if the length is bigger then max_side_length
bool load_images_and_rescale(const std::vector<boost::filesystem::path> paths,
    std::vector<cv::Mat>& images, int num_images = -1,
    int flag = 1, int max_side_length = 300);

// Abstract class for iterating through lots of images.
class ImageIterator {
public:
	virtual bool has_next() const = 0;

	virtual cv::Mat next() = 0;

	~ImageIterator() {}
};

// Iterates through individual patches (split by image_width) from the large
// images in index_file.
class BigImageIterator : public ImageIterator {
public:
	BigImageIterator(const std::string& index_file, int image_width)
			: image_width_(image_width) {
		load_paths(index_file, paths_);
		std::random_shuffle(paths_.begin(), paths_.end());
		paths_index_ = 0;
		cache_.clear();
		cache_index_ = 0;
	}

	bool has_next() const {
		return (paths_index_ < paths_.size() - 1) ||
					 (cache_index_ < cache_.size());
	}

	cv::Mat next();

private:
	int image_width_;
	std::vector<boost::filesystem::path> paths_;
	size_t paths_index_;
	std::vector<cv::Mat> cache_;
	size_t cache_index_;
};

// Iterates through patches in image list at different scales (can be used to
// extract lots of negative samples).
class ImagePatchIterator : public ImageIterator {
public:
	ImagePatchIterator(const std::vector<std::string>& index_files,
										 const cv::Size& patch_size,
										 int scale_count = 10, float rescale_factor = 0.8,
										 int step = 2)
			: patch_size_(patch_size),
				scale_count_(scale_count),
				rescale_factor_(rescale_factor),
				step_(step),
				count_(0) {
		load_paths(index_files[0], paths_);
		index_files_.assign(index_files.begin(), index_files.end());
		index_files_index_ = 1;
		std::random_shuffle(paths_.begin(), paths_.end());
		paths_index_ = 0;
		// Force new image loading.
		current_scale_ = scale_count_ - 1;
		x_ = 0;
		y_ = 0;
	}

	bool has_next() const {
		return x_ + patch_size_.width <= image_.cols ||
					 y_ + step_ + patch_size_.height <= image_.rows ||
					 current_scale_ < scale_count_ - 1 ||
					 paths_index_ < paths_.size() ||
					 index_files_index_ < index_files_.size();
	}

	cv::Mat next(); 

private:
	std::vector<std::string> index_files_;
	size_t index_files_index_;

	std::vector<boost::filesystem::path> paths_;
	size_t paths_index_;

	// Scanning params.
	cv::Size patch_size_;
	int scale_count_;
	float rescale_factor_;
	int step_;

	// Current image and position.
	cv::Mat image_;
	int current_scale_;
	int x_;
	int y_;

	// Counting loaded images.
	int count_;
};

} // namespace utils
} // namespace image_file

#endif /* UTILS_IMAGE_FILE_UTILS_HPP_ */
