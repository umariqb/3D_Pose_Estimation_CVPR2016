#ifndef _CTIMING_H_
#define _CTIMING_H_

#include <iostream>
#include <sys/time.h>

// Timing in milliseconds
class Timing {
public:
  Timing(){
    start();
  }

  void start() {
    gettimeofday(&m_time, NULL);
  }

  float restart() {
    float val = elapsed();
    gettimeofday(&m_time, NULL);
    return val;
  }

  float elapsed() {
    return now() - (*this);
  }

  void print(const char * _name) {
    float time = elapsed();
    std::cout << _name << ": took " << time << " milliseconds\n" << std::endl;
    restart();
  }

  static inline Timing now() {
    Timing t;
    t.start();
    return t;
  }

  float operator -(const Timing & t1) {
    return (float) 1000.0f * (m_time.tv_sec - t1.m_time.tv_sec) + 1.0e-3f * (m_time.tv_usec - t1.m_time.tv_usec);
  }

private:
  timeval m_time;
};

#endif //_CTIMING_H_
