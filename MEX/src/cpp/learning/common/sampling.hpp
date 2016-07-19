/*
 * sampling.hpp
 *
 *  Created on: Jun 19, 2013
 *      Author: gandrada
 */

#ifndef LEARNING_COMMON_UTILS_HPP_
#define LEARNING_COMMON_UTILS_HPP_

#include <vector>
namespace learning {
namespace common {
namespace utils {

template <class Sample>
void sample_subset(const std::vector<Sample*>& all,
									 size_t sample_count,
									 const std::vector<double>& weights,
									 boost::mt19937& gen,
									 std::vector<Sample*>* sampled) {
	boost::random::discrete_distribution<> dist(weights.begin(), weights.end());

	for (size_t i = 0; i < sample_count; ++i) {
		sampled->push_back(all[dist(gen)]);
	}
}

template <class Sample>
void split_samples(const std::vector<Sample*>& samples,
									 std::vector<Sample*>* pos_samples,
									 std::vector<Sample*>* neg_samples) {
	for (size_t i = 0; i < samples.size(); ++i) {
		if (samples[i]->label()) {
			pos_samples->push_back(samples[i]);
		} else {
			neg_samples->push_back(samples[i]);
		}
	}
}




} // namespace utils
} // namespace common
} // namespace learning

#endif /* LEARNING_COMMON_UTILS_HPP_ */
