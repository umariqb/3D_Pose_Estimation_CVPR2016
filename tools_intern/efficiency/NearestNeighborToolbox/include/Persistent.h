#ifndef __PERSISTENT_H
#define __PERSISTENT_H

enum ClassType
{
	ct_Sample = 0,
	ct_SampleSet = 1,
	ct_Trajectory = 2,
	ct_TrajectorySet = 3
};

class Persistent
{
public:
	virtual ClassType getClassType() = 0;
	virtual ~Persistent(){}
};


#endif /* __PERSISTENT_H */
