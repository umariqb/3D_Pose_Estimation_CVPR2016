/*
 * threading.cpp
 *
 *  Created on: Sep 5, 2013
 *      Author: lbossard
 */

#include "threading.hpp"

namespace utils {
namespace threading {

/*explicit*/ Semaphore::Semaphore(int32_t capacity){
  _capacity = capacity;
}

Semaphore::~Semaphore() {
}

void Semaphore::signal() {
  boost::unique_lock<boost::mutex> lock(_mutex);
  ++_capacity;
  _condition.notify_one();

}

void Semaphore::wait() {
  // wait, until the queues has space again
  boost::unique_lock<boost::mutex> lock(_mutex);
  while(_capacity < 1) {
    _condition.wait(lock);
  }
  --_capacity;
}


} /* namespace threading */
} /* namespace utils */
