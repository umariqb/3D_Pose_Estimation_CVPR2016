function [allJoints, cJoints] = getJointsHE (inputDB,database,cJno,bodyType)
%% all joints order (my format)
allJoints = H_myFormatJoints(inputDB);

%% control joints (used for KD-tree) order
switch  database
    case {'Human36Mbm','CMU_H36M','HumanEva_H36M'}
        switch  cJno
            case 14
                cJoints = {'Right Hip'; 'Right Knee'; 'Right Ankle'; 'Left Hip'; 'Left Knee'; 'Left Ankle';
                    'Neck'; 'Head';'Left Shoulder'; 'Left Elbow';
                    'Left Wrist';'Right Shoulder';'Right Elbow';'Right Wrist'};
            case 10
                if(strcmp( bodyType,'upper'))
                    cJoints = {'Right Hip'; 'Left Hip';'Neck'; 'Head';'Left Shoulder'; 'Left Elbow';
                        'Left Wrist';'Right Shoulder';'Right Elbow';'Right Wrist'};
                end
            case 6
                if(strcmp( bodyType,'lower'))
                    cJoints = {'Right Hip'; 'Right Knee'; 'Right Ankle';
                        'Left Hip'; 'Left Knee'; 'Left Ankle'};
                end
            case 8
                if(strcmp( bodyType,'left'))
                    cJoints = {'Left Hip'; 'Left Knee'; 'Left Ankle';
                        'Neck'; 'Head';'Left Shoulder'; 'Left Elbow';'Left Wrist'};
                elseif(strcmp( bodyType,'right'))
                    cJoints = {'Right Hip'; 'Right Knee'; 'Right Ankle';
                        'Neck'; 'Head';'Right Shoulder';'Right Elbow';'Right Wrist'};
                end
            otherwise
                disp('H_error: H_getJointsHE ... specify right control joints');
        end
    %----------------------------------------------------------------------    
    case 'Human80K'
        switch  cJno
            case 17
                cJoints = {'Root'; 'Right Hip'; 'Right Knee'; 'Right Ankle'; 'Left Hip'; 'Left Knee'; 'Left Ankle';
                    'Abdomen'; 'Neck'; 'Chin'; 'Head';'Left Shoulder'; 'Left Elbow';
                    'Left Wrist';'Right Shoulder';'Right Elbow';'Right Wrist'};
            case 13
                if(strcmp( bodyType,'upper'))
                    cJoints = {'Root'; 'Right Hip'; 'Left Hip'; 'Abdomen'; 'Neck'; 'Chin'; 'Head';'Left Shoulder'; 'Left Elbow';
                        'Left Wrist';'Right Shoulder';'Right Elbow';'Right Wrist'};
                end
            case 7
                if(strcmp( bodyType,'lower'))
                    cJoints = {'Root'; 'Right Hip'; 'Right Knee'; 'Right Ankle';
                        'Left Hip'; 'Left Knee'; 'Left Ankle'};
                end
            case 11
                if(strcmp( bodyType,'left'))
                    cJoints = {'Root'; 'Left Hip'; 'Left Knee'; 'Left Ankle';
                        'Abdomen'; 'Neck'; 'Chin'; 'Head';'Left Shoulder'; 'Left Elbow';'Left Wrist'};
                elseif(strcmp( bodyType,'right'))
                    cJoints = {'Root'; 'Right Hip'; 'Right Knee'; 'Right Ankle';
                        'Abdomen'; 'Neck'; 'Chin'; 'Head';'Right Shoulder';'Right Elbow';'Right Wrist'};
                end
            otherwise
                disp('H_error: H_getJointsHE ... specify right control joints');
        end
    %----------------------------------------------------------------------
    case {'HumanEva_regFit','HumanEva','CMU_amc_regFit','CMU_30'}
        switch  cJno
            case 5
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head'};
            case 9
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
                    'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'};
            case 11
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
                    'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'; 'Left Shoulder'; 'Right Shoulder'};
            case 14
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
                    'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'; 'Left Shoulder'; 'Right Shoulder';
                    'Left Hip'; 'Right Hip'; 'Neck'};
            case 10
                if(strcmp( bodyType,'upper'))
                    cJoints = {'Left Wrist'; 'Right Wrist'; 'Head'; 'Left Elbow'; 'Right Elbow'; 'Left Shoulder';
                        'Right Shoulder'; 'Left Hip'; 'Right Hip'; 'Neck'};
                end
            case 6
                if(strcmp( bodyType,'lower'))
                    cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Knee'; 'Right Knee';
                        'Left Hip'; 'Right Hip'; };
                end
            case 8
                if(strcmp( bodyType,'left'))
                    cJoints = {'Left Ankle'; 'Left Wrist'; 'Head'; 'Left Knee';'Left Elbow'; 'Left Shoulder';
                        'Left Hip'; 'Neck'};
                end
                if(strcmp( bodyType,'right'))
                    cJoints = {'Right Ankle'; 'Right Wrist'; 'Head'; 'Right Knee';'Right Elbow'; 'Right Shoulder';
                        'Right Hip'; 'Neck'};
                end
            otherwise
                disp('H_error: specify right control joints in function  H_getJointsHE ... ');
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head'};
        end
    %----------------------------------------------------------------------
    case 'CMU_amc'
        switch  cJno
            case 5
                cJoints = [4,9,21,28,17];                         % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17]
            case 9
                cJoints = [4,9,21,28,17,3,8,19,26];               % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17, LKnee=3, RKnee=8, LElbow=19, RElbow=26]
            case 11
                cJoints = [4,9,21,28,17,3,8,19,26,18,25];         % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17, LKnee=3, RKnee=8, LElbow=19, RElbow=26, LShoulder=18, RShoulder=25]
            case 14
                cJoints = [4,9,21,28,17,3,8,19,26,18,25,2,7,15];  % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17, LKnee=3, RKnee=8, LElbow=19, RElbow=26, LShoulder=18, RShoulder=25, LHip=2, RHip=7, Neck=15]
                %  cJoints = [9,4,28,21,17,8,3,26,19,25,18,7,2,15];  % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17, LKnee=3, RKnee=8, LElbow=19, RElbow=26, LShoulder=18, RShoulder=25, LHip=2, RHip=7, Neck=15]
            otherwise
                cJoints = [4,9,21,28,17];                         % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17]
        end
    %----------------------------------------------------------------------    
    case 'HDM05_amc'
        switch  cJno
            case 5
                cJoints = [4,9,21,28,17];                         % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17]
            case 9
                cJoints = [4,9,21,28,17,3,8,19,26];               % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17, LKnee=3, RKnee=8, LElbow=19, RElbow=26]
            case 11
                cJoints = [4,9,21,28,17,3,8,19,26,18,25];         % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17, LKnee=3, RKnee=8, LElbow=19, RElbow=26, LShoulder=18, RShoulder=25]
            case 14
                cJoints = [4,9,21,28,17,3,8,19,26,18,25,2,7,15];  % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17, LKnee=3, RKnee=8, LElbow=19, RElbow=26, LShoulder=18, RShoulder=25, LHip=2, RHip=7, Neck=15]
                %                  cJoints = [10,5,28,21,17,8,3,26,19,25,18,7,2,15];  % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17, LKnee=3, RKnee=8, LElbow=19, RElbow=26, LShoulder=18, RShoulder=25, LHip=2, RHip=7, Neck=15]
            otherwise
                cJoints = [4,9,21,28,17];                         % Joints [LFoot=4, RFoot=9, LHand=21, RHand=28, Head=17]
        end
    %----------------------------------------------------------------------
    case 'HDM05_c3d'
        switch  cJno
            case 5
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head'};
            case 9
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
                    'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'};
            case 11
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
                    'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'; 'Left Shoulder'; 'Right Shoulder'};
            case 14
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
                    'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'; 'Left Shoulder'; 'Right Shoulder';
                    'Left Hip'; 'Right Hip'; 'Neck'};
            otherwise
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head'};
        end
    %----------------------------------------------------------------------
    case {'CMU_c3d','CMU_c3d_regFit'}
        switch  cJno
            case 5
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head'};
            case 9
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
                    'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'};
            case 11
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
                    'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'; 'Left Shoulder'; 'Right Shoulder'};
            case 14
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
                    'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'; 'Left Shoulder'; 'Right Shoulder';
                    'Left Hip'; 'Right Hip'; 'Neck'};
            otherwise
                cJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head'};
        end
end
end