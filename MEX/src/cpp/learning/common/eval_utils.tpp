/*
 * eval_utils.cpp
 *
 *  Created on: Apr 24, 2013
 *      Author: gandrada
 */

#include <boost/bind.hpp>
#include "cpp/utils/system_utils.hpp"
#include "cpp/utils/thread_pool.hpp"

namespace learning {
namespace common {
namespace utils {

template <typename T>
static void submit_eval(
		const ClassifierInterface<T>& classifier,
		int x, int y, const cv::Size& patch_size,
		const Image& sample,
		cv::Mat& foreground_map) {
	cv::Rect patch_box(x, y, patch_size.width, patch_size.height);
	T s(&sample, patch_box, false);
	foreground_map.at<double>(y + patch_size.height / 2,
														x + patch_size.width / 2) =
		classifier.predict(s);
}

template <typename T>
void get_forground_map_mt(
		const Image& sample,
		const ClassifierInterface<T>& classifier,
		cv::Mat& foreground_map,
		const cv::Rect& roi,
		const cv::Size& patch_size,
		int step_size = 1,
		bool blur = true) {
	foreground_map = cv::Mat::zeros(roi.height, roi.width,
																	cv::DataType<double>::type);

	int num_threads = ::utils::system::get_available_logical_cpus();
	boost::thread_pool::executor e(num_threads);
	for (int x = roi.x; x < roi.x + roi.width - patch_size.width;
			 x += step_size) {
		for (int y = roi.y; y < roi.y + roi.height - patch_size.height;
				 y += step_size) {
			e.submit(boost::bind(&submit_eval<T>, boost::ref(classifier), x, y,
													 patch_size, sample, foreground_map)); 
		}
	}
	e.join_all();
}

template <typename T>
void get_peaks(
		const cv::Mat& test_image,
		const ClassifierInterface<T>& classifier,
		const ImageClassifierParam& classifier_param,
		const FeatureChannelFactory& fcf,
		const PeakDetectionParams& detection_param,
		std::vector<PeakLocation>* detected_peaks,
		bool show_image) {
	const cv::Size& patch_size = classifier_param.patch_size;

	// Create array of downsampled images.
	std::vector<cv::Mat> pyramid;
  pyramid.resize(detection_param.scale_count);
  pyramid[0] = test_image;
  for (int i = 1; i < pyramid.size(); ++i) {
    cv::resize(pyramid[i - 1], pyramid[i], cv::Size(0, 0),
               detection_param.scale_factor,
							 detection_param.scale_factor);
  }
	
	std::vector<cv::Mat> heat_maps(pyramid.size());
	for (int i = 0; i < pyramid.size(); ++i) {
		Image sample(pyramid[i], classifier_param.features, fcf);
		cv::Rect bbox(0, 0, sample.width(), sample.height());
		LOG(INFO) << "Getting foreground map at scale " << i << "\n";
		get_forground_map_mt(sample, classifier, heat_maps[i], bbox, patch_size,
												 std::min(detection_param.max_step,
																	detection_param.scale_count - i)); 
		if (show_image) {
			cv::imshow("face", heat_maps[i]);
			cv::waitKey(0);
		}
	}

	// Used for showing detections if show_image is true.
	cv::Mat paint;
	if (show_image) {
		pyramid[0].copyTo(paint);
	}

	detected_peaks->clear();
	double prev_best = -1;
	while (true) {
		cv::Point best_max;
		int best_scale = -1;
		double best_val = -1;
		for (int i = 0; i < pyramid.size(); ++i) {
			cv::Point max;
			double max_val;
			cv::minMaxLoc(heat_maps[i], 0, &max_val, 0, &max);

			if (max_val > best_val) {
				best_val = max_val; 
				best_scale = i;
				best_max = max;
			}
		}
		
		LOG(INFO) << "Peak detected at scale " << best_scale
			        << " with peak " << best_val
							<< " and diff " << prev_best - best_val << "\n";

		if (best_val < detection_param.detection_threshold) {
			LOG(INFO) << "Stopping: peak too low. Expecting >= " 
				        << detection_param.detection_threshold << "\n";
			break;
		}

		if (prev_best - best_val > detection_param.rejection_threshold) {
			LOG(INFO) << "Stopping: relative value to previous detection "
								<< "too low.\n";
			break;
		}
		prev_best = best_val;

		double orig_scale = pow(1 / detection_param.scale_factor, best_scale);
		int orig_x = static_cast<int>(best_max.x * orig_scale);
		int orig_y = static_cast<int>(best_max.y * orig_scale);
		int orig_w = static_cast<int>(patch_size.width * orig_scale);
		int orig_h = static_cast<int>(patch_size.height * orig_scale);

		detected_peaks->push_back(PeakLocation(orig_x, orig_y,
																					 cv::Size(orig_w, orig_h),
																					 best_val));

		if (show_image) {
			cv::Rect scaled_bbox(orig_x - orig_w / 2, orig_y - orig_h / 2,
													 orig_w, orig_h);
			cv::rectangle(paint, scaled_bbox,
										// Create some colored scaled to the peak score (highest
										// score will be bright red, going to white).
										cv::Scalar(static_cast<int>(40 * detected_peaks->size()),
															 static_cast<int>(40 * detected_peaks->size()),
															 static_cast<int>(255), 0), 3);
		}

		// Remove detected face from all scales.
		for (int s = 0; s < heat_maps.size(); ++s) {
			cv::Rect bbox(orig_x - orig_w / 2, orig_y - orig_h / 2,
										orig_w, orig_h);
			cv::rectangle(heat_maps[s], bbox, cv::Scalar(0, 0, 0, 0), -1);
			//cv::blur(heat_maps[s], heat_maps[s], cv::Size(2, 2));
			orig_x = static_cast<int>(orig_x * detection_param.scale_factor);
			orig_y = static_cast<int>(orig_y * detection_param.scale_factor);
			orig_w = static_cast<int>(orig_w * detection_param.scale_factor);
			orig_h = static_cast<int>(orig_h * detection_param.scale_factor);
		}
	}

	if (show_image) {
		cv::imshow("face", paint);
		cv::waitKey(0);
	}
}

static double area(const PeakLocation& p) {
	return p.size.width * p.size.height;
}

static double join(const PeakLocation& p1, const PeakLocation& p2) {
	cv::Rect r1(p1.x - p1.size.width / 2, p1.y - p1.size.height / 2,
							p1.size.width, p1.size.height);
	cv::Rect r2(p2.x - p2.size.width / 2, p2.y - p2.size.height / 2,
							p2.size.width, p2.size.height);

	cv::Rect r = r1 & r2;
	return r.width * r.height;
}

void merge_peaks(std::vector<PeakLocation>* peaks,
								 double merge_th, double suppress_th) {
	// Find group for each peak.
	std::vector<int> group(peaks->size());
	for (size_t i = 0; i < peaks->size(); ++i) {
		group[i] = i;
	}
	for (size_t i = 0; i < peaks->size(); ++i) {
		for (size_t j = i + 1; j < peaks->size(); ++j) {
			const double join_area = join((*peaks)[i], (*peaks)[j]);
			const double union_area = area((*peaks)[i]) + area((*peaks)[j]) - join_area;

			// Mark for merging.
			if (join_area / union_area >= merge_th) {
				for (size_t k = 0; k < peaks->size(); ++k) {
					if (group[k] == j) {
						group[k] = i;
					}
				}
			}
		}
	}

	// Merge peaks in the same group.
	std::vector<PeakLocation> new_peaks;
	for (size_t i = 0; i < peaks->size(); ++i) {
		if (group[i] == -1) {
			continue;
		}
		int x_sum = 0, y_sum = 0, count = 0, w_sum = 0, h_sum = 0;
		double score = 0;
		for (size_t j = i; j < peaks->size(); ++j) {
			if (group[j] == group[i]) {
				group[j] = -1;
				x_sum += (*peaks)[j].x;
				y_sum += (*peaks)[j].y;
				w_sum += (*peaks)[j].size.width;
				h_sum += (*peaks)[j].size.height;
				score = std::max(score, (*peaks)[j].score);
				++count;
			}
		}
		new_peaks.push_back(PeakLocation(x_sum / count, y_sum / count,
																		 cv::Size(w_sum / count, h_sum / count),
																		 score));
	}

	// Find overlapping regions.
	std::vector<bool> keep(new_peaks.size(), true);
	for (size_t i = 0; i < new_peaks.size(); ++i) {
		for (size_t j = i + 1; j < new_peaks.size(); ++j) {
			const double join_area = join(new_peaks[i], new_peaks[j]);
			const double r1 = join_area / area(new_peaks[i]);
			const double r2 = join_area / area(new_peaks[j]);
			// Suppress regions that overlap too much (keep the one with the highest
			// score).
			if (fabs(r1 - r2) > suppress_th) {
				if (new_peaks[i].score > new_peaks[j].score) {
					keep[j] = false;
				} else {
					keep[i] = false;
				}
			}
		}
	}

	// Copy merged peaks that do not overlap.
	peaks->clear();
	for (size_t i = 0; i < new_peaks.size(); ++i) {
		if (keep[i]) {
			peaks->push_back(new_peaks[i]);
		}
	}
}

} // namespace utils
} // namespace common 
} // namespace learning
