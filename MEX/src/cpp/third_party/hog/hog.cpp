/*
// Author: Juergen Gall, BIWI, ETH Zurich
// Email: gall@vision.ee.ethz.ch
*/

#include "hog.h"

using namespace std;
using namespace cv;

HoG::HoG() {

  // Number of bins for HoG features
  bins = 9;
  binsize = (3.14159265f*80.0f)/float(bins);

  // Size of Gaussian kernel for smoothing
  g_w = 5;

  Gauss.create( g_w, g_w, CV_32FC1 );
  double a = -(g_w-1)/2.0;
  double sigma2 = 2*(0.5*g_w)*(0.5*g_w);
  double count = 0;
  for(int x = 0; x<g_w; ++x) {
    for(int y = 0; y<g_w; ++y) {
      double tmp = exp(-( (a+x)*(a+x)+(a+y)*(a+y) )/sigma2);
      count += tmp;
      Gauss.at<float>(x, y) = tmp;
    }
  }

  Gauss.convertTo( Gauss, -1, 1.0/count);

  ptGauss.resize(g_w*g_w);
  int i = 0;
  for(int y = 0; y<g_w; ++y)
    for(int x = 0; x<g_w; ++x)
      ptGauss[i++] = Gauss.at<float>( x, y );

}


void HoG::extractOBin(Mat& Iorient, Mat& Imagn, vector<Mat>& out, int off) {
  double* desc = new double[bins];

  // reset output image (border=0) and get pointers
  vector<uchar*> ptOut(bins);
  for(int k=off; k<bins+off; ++k) {
    out[k].setTo(0);
  }
  int off_w = int(g_w/2.0);


  for(int y=0;y<Iorient.rows-g_w; y++) {

    // get pointer
    for(int l=0; l<bins; ++l) {
      ptOut[l] = out[l+off].ptr<uchar>(y) + off_w;
    }
    uchar* ptr_Orient = Iorient.ptr<uchar>(y);
    uchar* ptr_Magn = Imagn.ptr<uchar>(y);

    for(int x=0; x<Iorient.cols-g_w; ++x) {

      calcHoGBin( ptr_Orient, ptr_Magn, Iorient.step, desc );

      ++ptr_Orient;
      ++ptr_Magn;
      for(int l=0; l<bins; ++l) {
        *ptOut[l] = saturate_cast<uchar>(desc[l]);
        ++ptOut[l];
      }
    }

  }

  delete[] desc;

}



