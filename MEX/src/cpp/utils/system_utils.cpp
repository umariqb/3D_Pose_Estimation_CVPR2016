/*
 * system_utils.cpp
 *
 *  Created on: Mar 2, 2013
 *      Author: lbossard
 */

#include "system_utils.hpp"
#ifdef __APPLE__


namespace utils {
namespace system {

int get_logical_cpus(){
  return 1;
}

int get_available_logical_cpus(){
  return 1;
}

}
}

#else


#include <sys/sysinfo.h> // get_nprocs
#include <sched.h> // sched_getaffinity

namespace utils {
namespace system {


int get_logical_cpus(){
  return get_nprocs();
}

int get_available_logical_cpus(){
  cpu_set_t  mask;
  CPU_ZERO(&mask);
  sched_getaffinity(0, sizeof(mask), &mask);
  return CPU_COUNT(&mask);
}

} /* namespace system */
} /* namespace utils */
#endif
