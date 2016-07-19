/*
 * thread_pool.hpp
 *
 *  Created on: Jul 9, 2012
 *      Author: Matthias Dantone
 */

#ifndef THREAD_POOL_HPP_
#define THREAD_POOL_HPP_

#include <boost/asio.hpp>
#include <boost/bind.hpp>
#include <boost/thread.hpp>
#include <boost/bind/protect.hpp>

#include "threading.hpp"

namespace utils {

class ThreadPool {
public:
  ThreadPool(size_t n = 10) :
      service_(n), worker_(new boost::asio::io_service::work(service_)) {
    for (size_t i = 0; i < n; i++) {
      pool_.create_thread(boost::bind(&boost::asio::io_service::run, &service_));
    }
  }

  ~ThreadPool() {
    worker_.reset();
    service_.stop();
    pool_.join_all();
  }

  void join_all() {
    worker_.reset();
    pool_.join_all();
  }
  template<typename F> void submit(F task) {
    service_.post(task);
  }

protected:
  boost::thread_group pool_;
  boost::asio::io_service service_;
  boost::shared_ptr<boost::asio::io_service::work> worker_;

};

/**
 * Threadpool with a fixed queue size.
 */
class BlockingThreadPool {
public:
  BlockingThreadPool(uint32_t worker_threads, uint32_t max_queue_size)
      :
      _thread_pool(worker_threads),
      _semaphore(max_queue_size){
  }

  ~BlockingThreadPool() {
  }

  void join_all() {
    _thread_pool.join_all();
  }

  void submit(boost::function<void()> task) {

    // wait, until the queues has space again
    _semaphore.wait();

    _thread_pool.submit(boost::bind(&BlockingThreadPool::task_wrapper, this, boost::protect(task)));
  }

protected:
  ThreadPool _thread_pool;
  threading::Semaphore _semaphore;

  void task_wrapper(boost::function<void()> task) {
    // do the task
    task();

    // signal, that task is done
    _semaphore.signal();
  }

};
}

namespace boost {
namespace thread_pool {
typedef ::utils::ThreadPool executor;

}
}

#endif /* THREAD_POOL_HPP_ */
