#include <ANN/ANN.h>

#include <iostream>
#include "Sample.h"
#include "SampleSet.h"
#include "Trajectory.h"
#include "TrajectorySet.h"

int main(const int& argc,const char** argv)
{
	Sample<double,double> s1(3),s2(3);

	double x1[3] = { 2.0, 3.0, 1.0};
	double x2[3] = { 1.0, 2.0, 3.0};
	
	s1.setValues(x1);
	s1.setTimeStamp(2.0);
	s1.setAttributes(4.0);

	s2.setValues(x2);
	s2.setTimeStamp(6.0);
	s2.setAttributes(1.0);

	Sample<double,double> s3;
	s3 = s1*2+s2*3;
	SampleSet<double,double> ss,ss1(s1),ss2(s2),ss3(s3);

	ss = ss1+ss2+ss3;

	int k = 3;
	int* result = new int[k*ss.getNumSamples()];

	ss.findNearestNeighbors(ss1,k,result);

	delete[] result;
}