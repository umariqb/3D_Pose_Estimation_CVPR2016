/*
 * image_file_utils.hpp
 *
 *  Created on: Apr 24, 2013
 *      Author: gandrada
 */

#include <vector>

#include <boost/filesystem/convenience.hpp>
#include <boost/filesystem/path.hpp>
#include <boost/format.hpp>
#include <boost/iostreams/device/file.hpp>
#include <boost/iostreams/stream.hpp>
#include <boost/progress.hpp>
#include <boost/thread/thread.hpp>

#include <glog/logging.h>

#include "cpp/utils/image_file_utils.hpp"

namespace utils {
namespace image_file {

bool load_paths(const std::string& url,
								std::vector<boost::filesystem::path> & paths) {
	if (boost::filesystem::exists(url.c_str())) {
		std::string filename(url.c_str());
		boost::iostreams::stream < boost::iostreams::file_source > file(
				filename.c_str());
		std::string line;
		while (getline(file, line)) {
			boost::filesystem::path p(line);
			paths.push_back(p);
		}
	  if(paths.size() == 0 ) {
	    LOG(INFO) << "file is empty" << url;
	  }
		return true;
	}else{
    LOG(INFO) << "file doesn't exist " << url;
	}

	return false;
}

bool load_images(const std::vector<boost::filesystem::path> paths,
								 std::vector<cv::Mat>& images, int num_images, int flag) {
	if (num_images < 1 || num_images > paths.size()) {
		num_images = paths.size();
	}
	boost::progress_display show_progress(num_images);
	for(int i = 0; i < paths.size() && images.size() < num_images;
			i++, ++show_progress) {
		bool loaded = false;
		for(int save =0; save < 5; save++) {
			cv::Mat img = cv::imread(paths[i].string(), flag);
			if (img.data == NULL) {
				LOG(INFO) << "could not load " << paths[i].string() << std::endl;
				LOG(INFO) << "waiting " << (save+1)*2 << " seconds." << std::endl;
				boost::this_thread::sleep( boost::posix_time::seconds(1) );
			}else{
				images.push_back(img);
				loaded = true;
				break;
			}
		}
		if(!loaded) {
			return false;
		}
	}
	return true;
}

bool load_images(const std::string& index_file,
								 std::vector<cv::Mat>& images, int num_images, int flag) {
	std::vector<boost::filesystem::path> img_paths;
	if (!load_paths(index_file, img_paths)) {
		return false;
	}
	return load_images(img_paths, images, num_images, flag);
}

static bool merge_images(const std::vector<boost::filesystem::path>& img_paths,
												 const std::string& out_dir,
												 int image_size, int batch_size) {
	const int image_count = img_paths.size();
	std::vector<cv::Mat> images;
	if (!load_images(img_paths, images, image_count, 1)) {
		return false;
	}

	// Check all square and same size.
	for (int i = 0; i < images.size(); ++i) {
		if (images[i].rows != image_size || images[i].cols != image_size) {
			return false;
		}
	}

	const int batch_count = image_count / batch_size +
		(image_count % batch_size != 0 ? 1 : 0);

	for (int k = 0; k < batch_count; ++k) {
		const int count = std::min(image_count - k * batch_size, batch_size);
		cv::Mat all = cv::Mat(cv::Size(image_size * count, image_size),
													images[0].type());

		for (int i = 0; i < count; ++i) {
			cv::Point p(image_size * i, 0);
			cv::Mat roi = cv::Mat(all,
														cv::Rect(p, cv::Size(image_size, image_size)));
			images[k * batch_count + i].copyTo(roi);
		}

		std::ostringstream oss;
		oss << out_dir << "/all_images_" << k << ".jpg";
		imwrite(oss.str(), all);
	}

	return true;
}

bool create_big_images(const std::string& index_file,
											 const std::string& out_dir,
											 int image_size, int batch_size) {
	std::vector<boost::filesystem::path> img_paths;
	if (!load_paths(index_file, img_paths)) {
		return false;
	}

	// Maximum number of images to load and process at a time.
	const size_t max_load = 20000;
	const int steps = img_paths.size() / max_load +
		(img_paths.size() % max_load != 0 ? 1 : 0);
	for (int k = 0; k < steps; ++k) {
		const size_t start = k * max_load;
		const size_t count = std::min(img_paths.size() - start, max_load);
		std::vector<boost::filesystem::path> tmp_paths(&img_paths[start],
																									 &img_paths[start + count]);

		std::ostringstream oss;
		oss << out_dir << "/" << k << "/";
		if (!boost::filesystem::is_directory(oss.str()) &&
				!boost::filesystem::create_directory(oss.str())) {
			LOG(INFO) << "Could not create directory " << oss.str() << "\n";
			return false;
		}
		merge_images(tmp_paths, oss.str(), image_size, batch_size);
	}

	return true;
}

bool load_big_images(const std::string& index_file, int image_width,
										 std::vector<cv::Mat>& images) {
	std::vector<boost::filesystem::path> img_paths;
	assert(load_paths(index_file, img_paths));
	std::vector<cv::Mat> big_images;
	if (!load_images(img_paths, big_images, img_paths.size(), 1)) {
		return false;
	}

	int image_id = 0;
	for (int k = 0; k < big_images.size(); ++k) {
		int image_height = big_images[k].rows;
		int local_count = big_images[k].cols / image_width;
		images.resize(images.size() + local_count);

		for (int i = 0; i < local_count; ++i) {
			cv::Point p(image_width * i, 0);
			cv::Mat roi = cv::Mat(big_images[k],
														cv::Rect(p, cv::Size(image_width, image_height)));
			roi.copyTo(images[image_id++]);
		}
	}
	return true;
}

static bool load_big_image(const boost::filesystem::path& img_path,
													 int image_width, std::vector<cv::Mat>& images) {
	cv::Mat img_big = cv::imread(img_path.string(), 1);
	if (img_big.data == NULL) {
		LOG(INFO) << "could not load " << img_path.string() << std::endl;
		return false;
	}

	int image_id = images.size();

	int local_count = img_big.cols / image_width;
	int image_height = img_big.rows;
	images.resize(images.size() + local_count);

	for (int i = 0; i < local_count; ++i) {
		cv::Point p(image_width * i, 0);
		cv::Mat roi = cv::Mat(img_big,
													cv::Rect(p, cv::Size(image_width, image_height)));
		roi.copyTo(images[image_id++]);
	}
	return true;
}

bool sample_big_images(const std::string& index_file, int image_count,
											 int image_size, std::vector<cv::Mat>& images) {
	std::vector<boost::filesystem::path> img_paths;
	assert(load_paths(index_file, img_paths));
	std::random_shuffle(img_paths.begin(), img_paths.end());

	images.clear();

	boost::progress_display show_progress(image_count);
	for (int i = 0; i < img_paths.size() && images.size() < image_count; ++i) {
		if (!load_big_image(img_paths[i], image_size, images)) {
			continue;
		}
		show_progress += images.size() - show_progress.count();
	}

	if (images.size() < image_count) {
		LOG(INFO) << "could not sample all " << image_count << " images "
			<< std::endl;
		return false;
	}

	std::random_shuffle(images.begin(), images.end());
	images.resize(image_count);
	return true;
}

// Load at most num_images from the paths list.
// The flag parameter is passed to cv::imread.
// images are downscaled if the length is bigger then max_side_length
bool load_images_and_rescale(const std::vector<boost::filesystem::path> paths,
    std::vector<cv::Mat>& images, int num_images,
    int flag, int max_side_length) {

  if (!utils::image_file::load_images(paths, images, num_images, flag)) {
    return false;
  }

  for(int i=0; i < images.size(); i++) {
    double scale_factor = static_cast<double>(max_side_length) /
        std::max(images[i].rows, images[i].cols);
    if (scale_factor < 1.) {
      resize(images[i], images[i], cv::Size(), scale_factor, scale_factor);
    }
  }
  return true;
}

cv::Mat BigImageIterator::next() {
	if (cache_index_ >= cache_.size()) {
		CHECK(paths_index_ < paths_.size() - 1)
			<< "No more images to load.\n";
		cache_.clear();
		cache_index_ = 0;
		load_big_image(paths_[paths_index_++], image_width_, cache_);
	}
	return cache_[cache_index_++];
}

cv::Mat ImagePatchIterator::next() {
	// No more patches in this row.
	if (x_ + patch_size_.width > image_.cols) {
		// No more patches at this scale.
		if (y_ + step_ + patch_size_.height > image_.rows) {
			// No more scales for this image.
			if (current_scale_ == scale_count_ - 1) {
				// Load another image.
				if (paths_index_ >= paths_.size()) {
					CHECK(index_files_index_ < index_files_.size())
						<< "No more images to load.\n";
					load_paths(index_files_[index_files_index_++], paths_);
				}
				image_ = cv::imread(paths_[paths_index_].string());
				++paths_index_;

				if (image_.data == NULL) {
					LOG(INFO) << "could not load " << paths_[paths_index_].string()
										<<	"\n";
					return next();
				}

				int width = (image_.cols / patch_size_.width + 1) * patch_size_.width;
				int height = (image_.rows / patch_size_.height + 1) *
					patch_size_.height;
				cv::resize(image_, image_, cv::Size(width, height));
				current_scale_ = x_ = y_ = 0;
			} else {
				int width = static_cast<int>(image_.cols * rescale_factor_);
				width = (width / patch_size_.width + 1) * patch_size_.width;
				int height = static_cast<int>(image_.rows * rescale_factor_);
				height = (height / patch_size_.height + 1) * patch_size_.height;

				cv::resize(image_, image_, cv::Size(width, height));
				++current_scale_;
				x_ = y_ = 0;
			}
		} else {
			x_ = 0;
			y_ += step_;
		}
	}

	++count_;
	cv::Mat patch(image_,
								cv::Rect(x_, y_, patch_size_.width, patch_size_.height));
	x_ += step_;
	return patch;
}

} // namespace image_file
} // namespace utils
