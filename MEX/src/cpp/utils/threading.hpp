/*
 * threading.hpp
 *
 *  Created on: Sep 5, 2013
 *      Author: lbossard
 */

#ifndef UTILS__THREADING_HPP_
#define UTILS__THREADING_HPP_

#include <boost/thread/condition_variable.hpp>
#include <boost/thread/mutex.hpp>

namespace utils {
namespace threading {

class Semaphore {
public:
  explicit Semaphore(int32_t capacity);

  ~Semaphore();

  void signal();

  void wait();

private:
  int32_t _capacity;
  boost::condition_variable _condition;
  boost::mutex _mutex;

};


} /* namespace threading */
} /* namespace utils */
#endif /* UTILS__THREADING_HPP_ */

