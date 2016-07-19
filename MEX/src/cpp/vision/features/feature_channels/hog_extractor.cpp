/*
 * hog_extractor.cpp
 *
 *  Created on: Mar 22, 2012
 *      Author: Juergen Gall, mdantone
 */

#include <deque>

#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"

#include "hog_extractor.h"
#include "cpp/vision/min_max_filter.hpp"

using namespace std;
using namespace cv;

namespace vision {
namespace features {
namespace feature_channels {

void HOGExtractor::extractFeatureChannels9(const cv::Mat& img,
                                            std::vector<cv::Mat>& Channels,
                                            bool use_max_filter) {

  // 9 feature channels
  // 3+9 channels: Lab + HOGlike features with 9 bins
  const int FEATURE_CHANNELS = 9;
  Channels.resize(FEATURE_CHANNELS);
  for (int c=0; c<FEATURE_CHANNELS; ++c)
    Channels[c].create(img.rows,img.cols, CV_8U);

  if( MIN(img.cols, img.rows) < 5 ){
    cout <<"image is too small for HoG Extractor"<< endl;
    return;
  }

  Mat I_x;
  Mat I_y;


  // |I_x|, |I_y|
  Sobel(img,I_x,CV_16S,1,0,3);
  Sobel(img,I_y,CV_16S,0,1,3);

  //convertScaleAbs( I_x, Channels[3], 0.25);
  //convertScaleAbs( I_y, Channels[4], 0.25);

  int rows = I_x.rows;
  int cols = I_y.cols;

  Mat Iorient(img.rows,img.cols, CV_8UC1);
  Mat Imagn(img.rows,img.cols, CV_8UC1);

  if (I_x.isContinuous() && I_y.isContinuous() && Iorient.isContinuous() &&
      Imagn.isContinuous()) {
    cols *= rows;
    rows = 1;
  }

  for( int y = 0; y < rows; y++ ) {
    short* ptr_Ix = I_x.ptr<short>(y);
    short* ptr_Iy = I_y.ptr<short>(y);
    uchar* ptr_out = Iorient.ptr<uchar>(y);
    for( int x = 0; x < cols; x++ )
    {
      // Avoid division by zero
      float tx = (float)ptr_Ix[x] + (float)copysign(0.000001f, (float)ptr_Ix[x]);
      // Scaling [-pi/2 pi/2] -> [0 80*pi]
      ptr_out[x]=saturate_cast<uchar>( ( atan((float)ptr_Iy[x]/tx)+3.14159265f/2.0f ) * 80 );
    }
  }

  // Magnitude of gradients
  for (int y = 0; y < rows; y++) {
    short* ptr_Ix = I_x.ptr<short>(y);
    short* ptr_Iy = I_y.ptr<short>(y);
    uchar* ptr_out = Imagn.ptr<uchar>(y);
    for( int x = 0; x < cols; x++ )
    {
      ptr_out[x] = saturate_cast<uchar>(
          sqrt((float)ptr_Ix[x]*(float)ptr_Ix[x] +
               (float)ptr_Iy[x]*(float)ptr_Iy[x]));
    }
  }

  // 9-bin HOG feature stored at vImg[7] - vImg[15]
  hog.extractOBin(Iorient, Imagn, Channels, 0);


  //max filter
  if( use_max_filter ) {
    for(int c=0; c<Channels.size(); ++c)
      ::vision::MinMaxFilter::maxfilt(Channels[c], 5);
  }

}

void HOGExtractor::extractFeatureChannels15(const cv::Mat& img,
																						std::vector<cv::Mat>& Channels) {
	// 9 feature channels
	// 3+9 channels: Lab + HOGlike features with 9 bins
	const int FEATURE_CHANNELS = 15;
	Channels.resize(FEATURE_CHANNELS);
	for (int c=0; c<FEATURE_CHANNELS; ++c)
		Channels[c].create(img.rows,img.cols, CV_8U);

	if( MIN(img.cols, img.rows) < 5 ){
	  cout <<"image is too small for HoG Extractor"<< endl;
	  return;
	}

	Mat I_x;
	Mat I_y;

	// Get intensity
	cvtColor( img, Channels[0], CV_RGB2GRAY );

	// |I_x|, |I_y|
	Sobel(Channels[0],I_x,CV_16S,1,0,3);
	Sobel(Channels[0],I_y,CV_16S,0,1,3);

	//convertScaleAbs( I_x, Channels[3], 0.25);
	//convertScaleAbs( I_y, Channels[4], 0.25);

	int rows = I_x.rows;
	int cols = I_y.cols;

	if (I_x.isContinuous() && I_y.isContinuous() && Channels[1].isContinuous() &&
			Channels[2].isContinuous()) {
		cols *= rows;
		rows = 1;
	}

	for( int y = 0; y < rows; y++ ) {
		short* ptr_Ix = I_x.ptr<short>(y);
		short* ptr_Iy = I_y.ptr<short>(y);
		uchar* ptr_out = Channels[1].ptr<uchar>(y);
		for( int x = 0; x < cols; x++ )
		{
			// Avoid division by zero
			float tx = (float)ptr_Ix[x] + (float)copysign(0.000001f, (float)ptr_Ix[x]);
			// Scaling [-pi/2 pi/2] -> [0 80*pi]
			ptr_out[x]=saturate_cast<uchar>( ( atan((float)ptr_Iy[x]/tx)+3.14159265f/2.0f ) * 80 );
		}
	}

	// Magnitude of gradients
	for (int y = 0; y < rows; y++) {
		short* ptr_Ix = I_x.ptr<short>(y);
		short* ptr_Iy = I_y.ptr<short>(y);
		uchar* ptr_out = Channels[2].ptr<uchar>(y);
		for( int x = 0; x < cols; x++ )
		{
			ptr_out[x] = saturate_cast<uchar>(
					sqrt((float)ptr_Ix[x]*(float)ptr_Ix[x] +
							 (float)ptr_Iy[x]*(float)ptr_Iy[x]));
		}
	}

	// 9-bin HOG feature stored at vImg[7] - vImg[15]
	hog.extractOBin(Channels[1], Channels[2], Channels, 3);

	// |I_xx|, |I_yy|
	//Sobel(Channels[0],I_x,CV_16S, 2,0,3);
	//convertScaleAbs( I_x, Channels[5], 0.25);

	//Sobel(Channels[0],I_y,CV_16S, 0,2,3);
	//convertScaleAbs( I_y, Channels[6], 0.25);

	// L, a, b
	Mat imgRGB(img.size(), CV_8UC3);
	cvtColor( img, imgRGB, CV_RGB2Lab  );

	// Split color channels
	// overwriting the first 3 channels
	//  Mat out[] = { Channels[0], Channels[1], Channels[2] };
	//  int from_to[] = { 0,0 , 1,1, 2,2 };
	//  mixChannels( &imgRGB, 1, out, 3, from_to, 3 );
	split(imgRGB, &Channels[0]);

	// min filter
	for(int c=0; c<3; ++c)
	  MinMaxFilter::minfilt(Channels[c], Channels[c+12], 5);

	//max filter
	for(int c=0; c<12; ++c)
		MinMaxFilter::maxfilt(Channels[c], 5);

#if 0
	// Debug
	namedWindow( "Show", CV_WINDOW_AUTOSIZE );
	for(int i=0; i<FEATURE_CHANNELS; i++) {
		imshow( "Show", Channels[i] );
		waitKey(0);
	}
#endif
}

void HOGExtractor::extractFeatureChannels(const Mat& img, std::vector<cv::Mat>& channels) {
	// 32 feature channels
	// 7+9 channels: L, a, b, |I_x|, |I_y|, |I_xx|, |I_yy|, HOGlike features
	// with 9 bins (weighted orientations 5x5 neighborhood)
	// 16+16 channels: minfilter + MinMaxFilter::maxfilter on 5x5 neighborhood

	assert( img.channels() == 3);

	channels.resize(32);
	for(int c=0; c<32; ++c)
		channels[c].create(img.rows,img.cols, CV_8U);
	Mat I_x;
	Mat I_y;

	// Get intensity
	cvtColor( img, channels[0], CV_RGB2GRAY );

	// |I_x|, |I_y|
	Sobel(channels[0],I_x,CV_16S,1,0,3);
	Sobel(channels[0],I_y,CV_16S,0,1,3);

	convertScaleAbs( I_x, channels[3], 0.25);
	convertScaleAbs( I_y, channels[4], 0.25);

	int rows = I_x.rows;
	int cols = I_y.cols;

	if (I_x.isContinuous() && I_y.isContinuous() && channels[1].isContinuous() &&
			channels[2].isContinuous()) {
		cols *= rows;
		rows = 1;
	}

	for( int y = 0; y < rows; y++ ) {
		short* ptr_Ix = I_x.ptr<short>(y);
		short* ptr_Iy = I_y.ptr<short>(y);
		uchar* ptr_out = channels[1].ptr<uchar>(y);
		for( int x = 0; x < cols; x++ )
		{
			// Avoid division by zero
			float tx = (float)ptr_Ix[x] + (float)copysign(0.000001f, (float)ptr_Ix[x]);
			// Scaling [-pi/2 pi/2] -> [0 80*pi]
			ptr_out[x]=saturate_cast<uchar>(
					(atan((float)ptr_Iy[x]/tx)+3.14159265f/2.0f) * 80);
		}
	}

	// Magnitude of gradients
	for( int y = 0; y < rows; y++ ) {
		short* ptr_Ix = I_x.ptr<short>(y);
		short* ptr_Iy = I_y.ptr<short>(y);
		uchar* ptr_out = channels[2].ptr<uchar>(y);
		for( int x = 0; x < cols; x++ )
		{
			ptr_out[x] = saturate_cast<uchar>(
					sqrt((float)ptr_Ix[x]*(float)ptr_Ix[x] +
							 (float)ptr_Iy[x]*(float)ptr_Iy[x]));
		}
	}

	// 9-bin HOG feature stored at vImg[7] - vImg[15]
	hog.extractOBin(channels[1], channels[2], channels, 7);

	// |I_xx|, |I_yy|
	Sobel(channels[0],I_x,CV_16S, 2,0,3);
	convertScaleAbs( I_x, channels[5], 0.25);

	Sobel(channels[0],I_y,CV_16S, 0,2,3);
	convertScaleAbs( I_y, channels[6], 0.25);

	// L, a, b
	Mat img_;
	cvtColor( img, img_, CV_RGB2Lab  );

	// Split color channels
	Mat out[] = { channels[0], channels[1], channels[2] };
	int from_to[] = { 0,0 , 1,1, 2,2 };
	mixChannels( &img_, 1, out, 3, from_to, 3 );

	// int num_treads = boost::thread::hardware_concurrency();
	{
		// boost::thread_pool::executor e(num_treads);
		// min filter
		for(int c=0; c<16; ++c){
			// e.submit(boost::bind(&HOGExtractor::minfilt,
			// channels[old_size+c], channels[old_size+c+16], 5  ));
		  MinMaxFilter::minfilt(channels[c], channels[c+16], 5);
		}
		// e.join_all();
	}
	{
		// boost::thread_pool::executor e(num_treads);
		// max filter
		for(int c=0; c<16; ++c){
			// e.submit(boost::bind(&HOGExtractor::MinMaxFilter::maxfilt, channels[old_size+c], 5 ));
			MinMaxFilter::maxfilt(channels[c], 5);
		}
		// e.join_all();
	}

#if 0
	// Debug
	namedWindow( "Show", CV_WINDOW_AUTOSIZE );
	for(int i=0; i<32; i++) {
		imshow( "Show", channels[old_size+i] );
		waitKey(0);
	}
#endif


}


} // namespace vision
} // namespace features
} // namespace feature_channels
