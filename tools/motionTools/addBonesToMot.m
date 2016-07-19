% mot = addBonesToMot(mot);
% adds field "bones" to struct "mot" with the following columns:
% - name: name of the bone (cf. struct "skel")
% - bone vectors: father to son oriented vector for each frame
% - bone length: length of the bone (cf. struct "skel")
% - normalized bone vectors
% - father and son joints related to the bone

function mot=addBonesToMot(mot)

%
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
   
mot.bones.names{1,1}    = 'lhip';
mot.bones.vectors{1,1}  = mot.jointTrajectories{2}-mot.jointTrajectories{1};
mot.bones.joints{1,1}   = [1,2];
mot.bones.names{2,1}    = 'lfemur';
mot.bones.vectors{2,1}  = mot.jointTrajectories{3}-mot.jointTrajectories{2};
mot.bones.joints{2,1}   = [2,3];
mot.bones.names{3,1}    = 'ltibia';
mot.bones.vectors{3,1}  = mot.jointTrajectories{4}-mot.jointTrajectories{3};
mot.bones.joints{3,1}   = [3,4];
mot.bones.names{4,1}    = 'lfoot';
mot.bones.vectors{4,1}  = mot.jointTrajectories{5}-mot.jointTrajectories{4};
mot.bones.joints{4,1}   = [4,5];
mot.bones.names{5,1}    = 'ltoes';
mot.bones.vectors{5,1}  = mot.jointTrajectories{6}-mot.jointTrajectories{5};
mot.bones.joints{5,1}   = [5,6];
mot.bones.names{6,1}    = 'rhip';
mot.bones.vectors{6,1}  = mot.jointTrajectories{7}-mot.jointTrajectories{1};
mot.bones.joints{6,1}   = [1,7];
mot.bones.names{7,1}    = 'rfemur';
mot.bones.vectors{7,1}  = mot.jointTrajectories{8}-mot.jointTrajectories{7};
mot.bones.joints{7,1}   = [7,8];
mot.bones.names{8,1}    = 'rtibia';
mot.bones.vectors{8,1}  = mot.jointTrajectories{9}-mot.jointTrajectories{8};
mot.bones.joints{8,1}   = [8,9];
mot.bones.names{9,1}    = 'rfoot';
mot.bones.vectors{9,1}  = mot.jointTrajectories{10}-mot.jointTrajectories{9};
mot.bones.joints{9,1}   = [9,10];
mot.bones.names{10,1}   = 'rtoes';
mot.bones.vectors{10,1} = mot.jointTrajectories{11}-mot.jointTrajectories{10};
mot.bones.joints{10,1}  = [10,11];
mot.bones.names{11,1}   = 'lowerback';
mot.bones.vectors{11,1} = mot.jointTrajectories{12}-mot.jointTrajectories{1};
mot.bones.joints{11,1}  = [1,12];
mot.bones.names{12,1}   = 'upperback';
mot.bones.vectors{12,1} = mot.jointTrajectories{13}-mot.jointTrajectories{12};
mot.bones.joints{12,1}  = [12,13];
mot.bones.names{13,1}   = 'thorax';
mot.bones.vectors{13,1} = mot.jointTrajectories{14}-mot.jointTrajectories{13};
mot.bones.joints{13,1}  = [13,14];
mot.bones.names{14,1}   = 'lowerneck';
mot.bones.vectors{14,1} = mot.jointTrajectories{15}-mot.jointTrajectories{14};
mot.bones.joints{14,1}  = [14,15];
mot.bones.names{15,1}   = 'upperneck';
mot.bones.vectors{15,1} = mot.jointTrajectories{16}-mot.jointTrajectories{15};
mot.bones.joints{15,1}  = [15,16];
mot.bones.names{16,1}   = 'head';
mot.bones.vectors{16,1} = mot.jointTrajectories{17}-mot.jointTrajectories{16};
mot.bones.joints{16,1}  = [16,17];
mot.bones.names{17,1}   = 'lclavicle';
mot.bones.vectors{17,1} = mot.jointTrajectories{18}-mot.jointTrajectories{14};
mot.bones.joints{17,1}  = [14,18];
mot.bones.names{18,1}   = 'lhumerus';
mot.bones.vectors{18,1} = mot.jointTrajectories{19}-mot.jointTrajectories{18};
mot.bones.joints{18,1}  = [18,19];
mot.bones.names{19,1}   = 'lradius';
mot.bones.vectors{19,1} = mot.jointTrajectories{20}-mot.jointTrajectories{19};
mot.bones.joints{19,1}  = [19,20];
mot.bones.names{20,1}   = 'lwrist';
mot.bones.vectors{20,1} = mot.jointTrajectories{21}-mot.jointTrajectories{20};
mot.bones.joints{20,1}  = [20,21];
mot.bones.names{21,1}   = 'lhand';
mot.bones.vectors{21,1} = mot.jointTrajectories{22}-mot.jointTrajectories{21};
mot.bones.joints{21,1}  = [21,22];
mot.bones.names{22,1}   = 'lfingers';
mot.bones.vectors{22,1} = mot.jointTrajectories{23}-mot.jointTrajectories{22};
mot.bones.joints{22,1}  = [22,23];
mot.bones.names{23,1}   = 'lthumb';
mot.bones.vectors{23,1} = mot.jointTrajectories{24}-mot.jointTrajectories{21};
mot.bones.joints{23,1}  = [21,24];
mot.bones.names{24,1}   = 'rclavicle';
mot.bones.vectors{24,1} = mot.jointTrajectories{25}-mot.jointTrajectories{14};
mot.bones.joints{24,1}  = [14,25];
mot.bones.names{25,1}   = 'rhumerus';
mot.bones.vectors{25,1} = mot.jointTrajectories{26}-mot.jointTrajectories{25};
mot.bones.joints{25,1}  = [25,26];
mot.bones.names{26,1}   = 'rradius';
mot.bones.vectors{26,1} = mot.jointTrajectories{27}-mot.jointTrajectories{26};
mot.bones.joints{26,1}  = [26,27];
mot.bones.names{27,1}   = 'rwrist';
mot.bones.vectors{27,1} = mot.jointTrajectories{28}-mot.jointTrajectories{27};
mot.bones.joints{27,1}  = [27,28];
mot.bones.names{28,1}   = 'rhand';
mot.bones.vectors{28,1} = mot.jointTrajectories{29}-mot.jointTrajectories{28};
mot.bones.joints{28,1}  = [28,29];
mot.bones.names{29,1}   = 'rfingers';
mot.bones.vectors{29,1} = mot.jointTrajectories{30}-mot.jointTrajectories{29};
mot.bones.joints{29,1}  = [29,30];
mot.bones.names{30,1}   = 'rthumb';
mot.bones.vectors{30,1} = mot.jointTrajectories{31}-mot.jointTrajectories{28};
mot.bones.joints{30,1}  = [28,31];

for i=1:30
    mot.bones.length{i,1}=normOfColumns(mot.bones.vectors{i,1}(:,1));
end
for i=1:30
    mot.bones.normalizedVectors{i,1}=mot.bones.vectors{i,1}/mot.bones.length{i,1};
end
