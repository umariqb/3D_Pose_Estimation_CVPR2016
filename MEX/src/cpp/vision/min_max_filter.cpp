/*
 * min_max_filter.cpp
 *
 *  Created on: Oct 6, 2013
 *      Author: mdantone
 */

#include "min_max_filter.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <deque>

using namespace std;
using namespace cv;

namespace vision {


void MinMaxFilter::maxfilt(Mat &src, unsigned int width) {

  unsigned int step = src.step;
  uchar* s_data = src.ptr<uchar>(0);

  for(int  y = 0; y < src.rows; y++) {
    MinMaxFilter::maxfilt(s_data+y*step, 1, src.cols, width);
  }

  s_data = src.ptr<uchar>(0);

  for(int  x = 0; x < src.cols; x++)
    MinMaxFilter::maxfilt(s_data+x, step, src.rows, width);

}

void MinMaxFilter::minfilt(Mat &src, Mat &dst, unsigned int width) {

  unsigned int step = src.step;
  uchar* s_data = src.ptr<uchar>(0);
  uchar* d_data = dst.ptr<uchar>(0);

  for(int  y = 0; y < src.rows; y++)
    MinMaxFilter::minfilt(s_data+y*step, d_data+y*step, 1, src.cols, width);

  d_data = dst.ptr<uchar>(0);

  for(int  x = 0; x < src.cols; x++)
    MinMaxFilter::minfilt(d_data+x, step, src.rows, width);

}

void MinMaxFilter::maxfilt(uchar* data, uchar* maxvalues, unsigned int step,
                           unsigned int size, unsigned int width) {
  unsigned int d = int((width+1)/2)*step;
  size *= step;
  width *= step;

  maxvalues[0] = data[0];
  for(unsigned int i=0; i < d-step; i+=step) {
    for(unsigned int k=i; k<d+i; k+=step) {
      if(data[k]>maxvalues[i]) maxvalues[i] = data[k];
    }
    maxvalues[i+step] = maxvalues[i];
  }

  maxvalues[size-step] = data[size-step];
  for(unsigned int i=size-step; i > size-d; i-=step) {
    for(unsigned int k=i; k>i-d; k-=step) {
      if(data[k]>maxvalues[i]) maxvalues[i] = data[k];
    }
    maxvalues[i-step] = maxvalues[i];
  }

  deque<int> maxfifo;
  for(unsigned int i = step; i < size; i+=step) {
    if(i >= width) {
      maxvalues[i-d] = data[maxfifo.size()>0 ? maxfifo.front(): i-step];
    }

    if(data[i] < data[i-step]) {
      maxfifo.push_back(i-step);
      if(i==  width+maxfifo.front())
        maxfifo.pop_front();
    } else {
      while(maxfifo.size() > 0) {
        if(data[i] <= data[maxfifo.back()]) {
          if(i==  width+maxfifo.front())
            maxfifo.pop_front();
          break;
        }
        maxfifo.pop_back();
      }
    }
  }

  maxvalues[size-d] = data[maxfifo.size()>0 ? maxfifo.front():size-step];
}

void MinMaxFilter::maxfilt(uchar* data, unsigned int step, unsigned int size,
                           unsigned int width) {

  unsigned int d = int((width+1)/2)*step;
  size *= step;
  width *= step;

  deque<uchar> tmp;

  tmp.push_back(data[0]);
  for(unsigned int k=step; k<d; k+=step) {
    if(data[k]>tmp.back()) tmp.back() = data[k];
  }

  for(unsigned int i=step; i < d-step; i+=step) {
    tmp.push_back(tmp.back());
    if(data[i+d-step]>tmp.back()) tmp.back() = data[i+d-step];
  }


  deque<int> minfifo;
  for(unsigned int i = step; i < size; i+=step) {
    if(i >= width) {
      tmp.push_back(data[minfifo.size()>0 ? minfifo.front(): i-step]);
      data[i-width] = tmp.front();
      tmp.pop_front();
    }

    if(data[i] < data[i-step]) {

      minfifo.push_back(i-step);
      if(i==  width+minfifo.front())
        minfifo.pop_front();

    } else {

      while(minfifo.size() > 0) {
        if(data[i] <= data[minfifo.back()]) {
          if(i==  width+minfifo.front())
            minfifo.pop_front();
          break;
        }
        minfifo.pop_back();
      }

    }

  }

  tmp.push_back(data[minfifo.size()>0 ? minfifo.front():size-step]);

  for(unsigned int k=size-step-step; k>=size-d; k-=step) {
    if(data[k]>data[size-step]) data[size-step] = data[k];
  }

  for(unsigned int i=size-step-step; i >= size-d; i-=step) {
    data[i] = data[i+step];
    if(data[i-d+step]>data[i]) data[i] = data[i-d+step];
  }

  for(unsigned int i=size-width; i<=size-d; i+=step) {
    data[i] = tmp.front();
    tmp.pop_front();
  }

}


void MinMaxFilter::minfilt(uchar* data, uchar* minvalues, unsigned int step,
                           unsigned int size, unsigned int width) {
  unsigned int d = int((width+1)/2)*step;
  size *= step;
  width *= step;

  minvalues[0] = data[0];
  for(unsigned int i=0; i < d-step; i+=step) {
    for(unsigned int k=i; k<d+i; k+=step) {
      if(data[k]<minvalues[i]) minvalues[i] = data[k];
    }
    minvalues[i+step] = minvalues[i];
  }

  minvalues[size-step] = data[size-step];
  for(unsigned int i=size-step; i > size-d; i-=step) {
    for(unsigned int k=i; k>i-d; k-=step) {
      if(data[k]<minvalues[i]) minvalues[i] = data[k];
    }
    minvalues[i-step] = minvalues[i];
  }

  deque<int> minfifo;
  for(unsigned int i = step; i < size; i+=step) {
    if(i >= width) {
      minvalues[i-d] = data[minfifo.size()>0 ? minfifo.front(): i-step];
    }

    if(data[i] > data[i-step]) {

      minfifo.push_back(i-step);
      if(i==  width+minfifo.front())
        minfifo.pop_front();

    } else {

      while(minfifo.size() > 0) {
        if(data[i] >= data[minfifo.back()]) {
          if(i==  width+minfifo.front())
            minfifo.pop_front();
          break;
        }
        minfifo.pop_back();
      }

    }

  }

  minvalues[size-d] = data[minfifo.size()>0 ? minfifo.front():size-step];

}

void MinMaxFilter::minfilt(uchar* data, unsigned int step, unsigned int size,
                           unsigned int width) {
  unsigned int d = int((width+1)/2)*step;
  size *= step;
  width *= step;

  deque<uchar> tmp;

  tmp.push_back(data[0]);
  for(unsigned int k=step; k<d; k+=step) {
    if(data[k]<tmp.back()) tmp.back() = data[k];
  }

  for(unsigned int i=step; i < d-step; i+=step) {
    tmp.push_back(tmp.back());
    if(data[i+d-step]<tmp.back()) tmp.back() = data[i+d-step];
  }

  deque<int> minfifo;
  for(unsigned int i = step; i < size; i+=step) {
    if(i >= width) {
      tmp.push_back(data[minfifo.size()>0 ? minfifo.front(): i-step]);
      data[i-width] = tmp.front();
      tmp.pop_front();
    }

    if(data[i] > data[i-step]) {

      minfifo.push_back(i-step);
      if(i==  width+minfifo.front())
        minfifo.pop_front();
    } else {
      while(minfifo.size() > 0) {
        if(data[i] >= data[minfifo.back()]) {
          if(i==  width+minfifo.front())
            minfifo.pop_front();
          break;
        }
        minfifo.pop_back();
      }
    }
  }

  tmp.push_back(data[minfifo.size()>0 ? minfifo.front():size-step]);

  for(unsigned int k=size-step-step; k>=size-d; k-=step) {
    if(data[k]<data[size-step]) data[size-step] = data[k];
  }

  for(unsigned int i=size-step-step; i >= size-d; i-=step) {
    data[i] = data[i+step];
    if(data[i-d+step]<data[i]) data[i] = data[i-d+step];
  }

  for(unsigned int i=size-width; i<=size-d; i+=step) {
    data[i] = tmp.front();
    tmp.pop_front();
  }
}

} /* namespace vision */
