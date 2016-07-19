
#ifndef BODY_POSE_TYPES_HH
#define BODY_POSE_TYPES_HH

/*
 *  body_pose_types.hpp
 *
 *  Created on: Oct 15, 2014
 *      Author: Umar Iqbal
 */

namespace body_pose{

  // TYPE_BODY_J[Number of Joints]            //  pose style
  enum BodyPoseTypes { FULL_BODY_J13 = 13,   /*   /\
                                                 /| |\ [head, l_sho, r_sho, l_hips, r_hips, l_elb, l_wri, r_elb, r_wri, l_knee, l_ankl, r_knee, r_ankl]
                                                  | |
                                                  \ / */

                        FULL_BODY_J14 = 14, //[head_top, neck, l_sho, r_sho, l_hips, r_hips, l_elb, l_wri, r_elb, r_wri, l_knee, l_ankl, r_knee, r_ankl]
                        FULL_BODY_J17 = 17, // [head_top, chin, neck, l_sho', r_sho', abdomen', root', l_hip', r_hip', l_elb', l_wri', r_elb', r_wri' l_knee', l_ankl', r_knee', r_ankle]
                        FULL_BODY_J13_TEMPORAL = 39, // with two neighbouring frames
                        UPPER_BODY_J7 = 7, // upper body parts without hips
                        UPPER_BODY_J9 = 9, // upper body parts with hip joints
                        };
}

#endif
