/*
 * system_utils.hpp
 *
 *  Created on: Mar 2, 2013
 *      Author: lbossard
 */

#ifndef SYSTEM_UTILS_HPP_
#define SYSTEM_UTILS_HPP_

namespace utils {
namespace system {

/**
 * @return number of logical cpus
 */
int get_logical_cpus();

/**
 * @return number of logical cpus, this program can use
 */
int get_available_logical_cpus();

} /* namespace system */
} /* namespace utils */
#endif /* SYSTEM_UTILS_HPP_ */
