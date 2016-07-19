function allJoints = H_myFormatJoints(inputDB)
switch inputDB
    case {'HumanEva','JHMDB','LeedSports'}
        allJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
            'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'; 'Left Shoulder'; 'Right Shoulder';
            'Left Hip'; 'Right Hip'; 'Neck'};
    case 'Human80K'
        allJoints = {'Root'; 'Right Hip'; 'Right Knee'; 'Right Ankle'; 'Left Hip'; 'Left Knee'; 'Left Ankle';
            'Abdomen'; 'Neck'; 'Chin'; 'Head';'Left Shoulder'; 'Left Elbow';  'Left Wrist';'Right Shoulder';'Right Elbow';'Right Wrist'};
    case 'Human36Mbm'
        allJoints = {'Right Hip'; 'Right Knee'; 'Right Ankle'; 'Left Hip'; 'Left Knee'; 'Left Ankle';
            'Neck'; 'Head';'Left Shoulder'; 'Left Elbow';  'Left Wrist';'Right Shoulder';'Right Elbow';'Right Wrist'};
    case 'default'
        allJoints = {'Right Hip'; 'Right Knee'; 'Right Ankle'; 'Left Hip'; 'Left Knee'; 'Left Ankle';
            'Neck'; 'Head';'Right Shoulder';'Right Elbow';'Right Wrist';'Left Shoulder'; 'Left Elbow';  'Left Wrist'};
    otherwise
        disp('H-error: please specify inputDB in function H_myFormatJoints ... ');
end

end


%%
%     allJoints = {'Left Ankle'; 'Right Ankle'; 'Left Wrist'; 'Right Wrist'; 'Head';
%         'Left Knee'; 'Right Knee';'Left Elbow'; 'Right Elbow'; 'Left Shoulder'; 'Right Shoulder';
%         'Left Hip'; 'Right Hip'; 'Neck';'Chin';'Abdomen';'Root'};

%     allJoints   = {'Root'; 'Right Hip'; 'Right Knee'; 'Right Ankle'; 'RightToeBase'; 'Site' ; 'Left Hip'; 'Left Knee';
%         'Left Ankle'; 'LeftToeBase'; 'Site'; 'Spine'; 'Abdomen'; 'Neck'; 'Chin'; 'Head'; 'LeftShoulder NeckBack';
%         'Left Shoulder'; 'Left Elbow';  'Left Wrist'; 'LeftHandThumb';'Site';'L_Wrist_End';'Site';'RightShoulder NeckBack';
%         'Right Shoulder';'Right Elbow';'Right Wrist'; 'RightHandThumb';'Site';'R_Wrist_End';'Site'};