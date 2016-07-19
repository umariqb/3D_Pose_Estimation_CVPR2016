function mot=addCrossToMot(mot)

%                                       17
%                                        |  head
%                                       16
%                                        |  upperneck
%                                       15  
%                                        |  lowerneck
%              lhand  lradius  lclavicle | rclavicle  rradius  rhand
%  lfingers 23-22-21-20-----19------18--14--25------26-----27-28-29-30 rfingers
%          lthumb | lwrist   lhumerus    |   rhumerus   rwrist | rthumb
%                24                      |  thorax             31
%                                       13
%                                        |  upperback 
%                                        |  
%                                       12
%                                        |  lowerback
%                                        | 
%                               lhip  2--1--7  rhip
%                                    /       \
%                                   /         \
%                          lfemur  /           \  rfemur
%                                 /             \
%                                /               \
%                               3                 8
%                               |                 |
%                               |                 |
%                        ltibia |                 | rtibia
%                               |                 |
%                               4                 9
%                              / lfoot       rfoot \
%                    ltoes 6--5                     10-11 rtoes


                
segment_1_2=mot.jointTrajectories{2}-mot.jointTrajectories{1};
segment_1_7=mot.jointTrajectories{7}-mot.jointTrajectories{1};
segment_1_12=mot.jointTrajectories{12}-mot.jointTrajectories{1};
segment_2_3=mot.jointTrajectories{3}-mot.jointTrajectories{2};
segment_3_4=mot.jointTrajectories{4}-mot.jointTrajectories{3};
segment_4_5=mot.jointTrajectories{5}-mot.jointTrajectories{4};
segment_5_6=mot.jointTrajectories{6}-mot.jointTrajectories{5};
segment_7_8=mot.jointTrajectories{8}-mot.jointTrajectories{7};
segment_8_9=mot.jointTrajectories{9}-mot.jointTrajectories{8};
segment_9_10=mot.jointTrajectories{10}-mot.jointTrajectories{9};
segment_10_11=mot.jointTrajectories{11}-mot.jointTrajectories{10};
segment_12_13=mot.jointTrajectories{13}-mot.jointTrajectories{12};
segment_13_14=mot.jointTrajectories{14}-mot.jointTrajectories{13};
segment_14_15=mot.jointTrajectories{15}-mot.jointTrajectories{14};
segment_14_18=mot.jointTrajectories{18}-mot.jointTrajectories{14};
segment_14_25=mot.jointTrajectories{25}-mot.jointTrajectories{14};
segment_15_16=mot.jointTrajectories{16}-mot.jointTrajectories{15};
segment_16_17=mot.jointTrajectories{17}-mot.jointTrajectories{16};
segment_18_19=mot.jointTrajectories{19}-mot.jointTrajectories{18};
segment_19_20=mot.jointTrajectories{20}-mot.jointTrajectories{19};
segment_20_21=mot.jointTrajectories{21}-mot.jointTrajectories{20};
segment_21_22=mot.jointTrajectories{22}-mot.jointTrajectories{21};
segment_22_23=mot.jointTrajectories{23}-mot.jointTrajectories{22};
segment_25_26=mot.jointTrajectories{26}-mot.jointTrajectories{25};
segment_26_27=mot.jointTrajectories{27}-mot.jointTrajectories{26};
segment_27_28=mot.jointTrajectories{28}-mot.jointTrajectories{27};
segment_28_29=mot.jointTrajectories{29}-mot.jointTrajectories{28};
segment_29_30=mot.jointTrajectories{30}-mot.jointTrajectories{29};

% mot.crossProducts{1,1}=cross(segment_1_2,segment_1_12); %1a
% mot.crossProducts{2,1}=cross(segment_1_7,segment_1_12); %1b
% mot.crossProducts{3,1}=cross(segment_1_2,segment_1_7); %1c
% mot.crossProducts{4,1}=cross(-segment_1_2,segment_2_3); %2
% mot.crossProducts{5,1}=cross(-segment_2_3,segment_3_4); %3
% mot.crossProducts{6,1}=cross(-segment_3_4,segment_4_5); %4
% mot.crossProducts{7,1}=cross(-segment_4_5,segment_5_6); %5
% mot.crossProducts{8,1}=cross(-segment_1_7,segment_7_8); %7
% mot.crossProducts{9,1}=cross(-segment_7_8,segment_8_9); %8
% mot.crossProducts{10,1}=cross(-segment_8_9,segment_9_10); %9
% mot.crossProducts{11,1}=cross(-segment_9_10,segment_10_11); %10
% mot.crossProducts{12,1}=cross(-segment_1_12,segment_12_13); %12
% mot.crossProducts{13,1}=cross(-segment_12_13,segment_13_14); %13
% mot.crossProducts{14,1}=cross(-segment_13_14,segment_14_25); %14a
% mot.crossProducts{15,1}=cross(-segment_13_14,segment_14_18); %14b
% mot.crossProducts{16,1}=cross(segment_14_15,segment_14_25); %14c
% mot.crossProducts{17,1}=cross(segment_14_15,segment_14_18); %14d
% mot.crossProducts{18,1}=cross(-segment_13_14,segment_14_15); %14e
% mot.crossProducts{19,1}=cross(segment_14_18,segment_14_25); %14f
% mot.crossProducts{20,1}=cross(-segment_14_15,segment_15_16); %15
% mot.crossProducts{21,1}=cross(-segment_15_16,segment_16_17); %16
% mot.crossProducts{22,1}=cross(-segment_14_18,segment_18_19); %18
% mot.crossProducts{23,1}=cross(-segment_18_19,segment_19_20); %19
% mot.crossProducts{24,1}=cross(-segment_19_20,segment_20_21); %20
% mot.crossProducts{25,1}=cross(-segment_20_21,segment_21_22); %21
% mot.crossProducts{26,1}=cross(-segment_21_22,segment_22_23); %22
% mot.crossProducts{27,1}=cross(-segment_14_25,segment_25_26); %25
% mot.crossProducts{28,1}=cross(-segment_25_26,segment_26_27); %26
% mot.crossProducts{29,1}=cross(-segment_26_27,segment_27_28); %27
% mot.crossProducts{30,1}=cross(-segment_27_28,segment_28_29); %28
% mot.crossProducts{31,1}=cross(-segment_28_29,segment_29_30); %29

mot.crossProducts{1,2}=segment_1_2; %1a
mot.crossProducts{2,2}=segment_1_7; %1b
mot.crossProducts{3,2}=segment_1_2; %1c
mot.crossProducts{4,2}=-segment_1_2; %2
mot.crossProducts{5,2}=-segment_2_3; %3
mot.crossProducts{6,2}=-segment_3_4; %4
mot.crossProducts{7,2}=-segment_4_5; %5
mot.crossProducts{8,2}=-segment_1_7; %7
mot.crossProducts{9,2}=-segment_7_8; %8
mot.crossProducts{10,2}=-segment_8_9; %9
mot.crossProducts{11,2}=-segment_9_10; %10
mot.crossProducts{12,2}=-segment_1_12; %12
mot.crossProducts{13,2}=-segment_12_13; %13
mot.crossProducts{14,2}=-segment_13_14; %14a
mot.crossProducts{15,2}=-segment_13_14; %14b
mot.crossProducts{16,2}=segment_14_15; %14c
mot.crossProducts{17,2}=segment_14_15; %14d
mot.crossProducts{18,2}=-segment_13_14; %14e
mot.crossProducts{19,2}=segment_14_18; %14f
mot.crossProducts{20,2}=-segment_14_15; %15
mot.crossProducts{21,2}=-segment_15_16; %16
mot.crossProducts{22,2}=-segment_14_18; %18
mot.crossProducts{23,2}=-segment_18_19; %19
mot.crossProducts{24,2}=-segment_19_20; %20
mot.crossProducts{25,2}=-segment_20_21; %21
mot.crossProducts{26,2}=-segment_21_22; %22
mot.crossProducts{27,2}=-segment_14_25; %25
mot.crossProducts{28,2}=-segment_25_26; %26
mot.crossProducts{29,2}=-segment_26_27; %27
mot.crossProducts{30,2}=-segment_27_28; %28
mot.crossProducts{31,2}=-segment_28_29; %29

mot.crossProducts{1,3}=segment_1_12; %1a
mot.crossProducts{2,3}=segment_1_12; %1b
mot.crossProducts{3,3}=segment_1_7; %1c
mot.crossProducts{4,3}=segment_2_3; %2
mot.crossProducts{5,3}=segment_3_4; %3
mot.crossProducts{6,3}=segment_4_5; %4
mot.crossProducts{7,3}=segment_5_6; %5
mot.crossProducts{8,3}=segment_7_8; %7
mot.crossProducts{9,3}=segment_8_9; %8
mot.crossProducts{10,3}=segment_9_10; %9
mot.crossProducts{11,3}=segment_10_11; %10
mot.crossProducts{12,3}=segment_12_13; %12
mot.crossProducts{13,3}=segment_13_14; %13
mot.crossProducts{14,3}=segment_14_25; %14a
mot.crossProducts{15,3}=segment_14_18; %14b
mot.crossProducts{16,3}=segment_14_25; %14c
mot.crossProducts{17,3}=segment_14_18; %14d
mot.crossProducts{18,3}=segment_14_15; %14e
mot.crossProducts{19,3}=segment_14_25; %14f
mot.crossProducts{20,3}=segment_15_16; %15
mot.crossProducts{21,3}=segment_16_17; %16
mot.crossProducts{22,3}=segment_18_19; %18
mot.crossProducts{23,3}=segment_19_20; %19
mot.crossProducts{24,3}=segment_20_21; %20
mot.crossProducts{25,3}=segment_21_22; %21
mot.crossProducts{26,3}=segment_22_23; %22
mot.crossProducts{27,3}=segment_25_26; %25
mot.crossProducts{28,3}=segment_26_27; %26
mot.crossProducts{29,3}=segment_27_28; %27
mot.crossProducts{30,3}=segment_28_29; %28
mot.crossProducts{31,3}=segment_29_30; %29

for i=1:31
    mot.crossProducts{i,1}=cross(mot.crossProducts{i,2},mot.crossProducts{i,3});
end