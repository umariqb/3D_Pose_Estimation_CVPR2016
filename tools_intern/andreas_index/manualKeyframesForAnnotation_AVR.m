function [keyframes, keyframePositions, keyframeIndex, keyframeDistances, stiffness, templateLength] = manualKeyframesForAnnotation_AVR(categoryName)
%keyframes can be defined for every class.
keyframes = cell(0, 0);
keyframeFeatureSet = {'AK_upper', 'AK_lower', 'AK_mix_avr'}; %the feature sets to which the keyframes belong
%for every class there exists a vector which indicates which keyframe
%belongs to which keyframeFeatureSet.



categoryName = concatStringsInCell(categoryName);

%Category: cartwheelLHandStart1Reps
%Template length: 106

switch (categoryName)
    case 'cartwheelLHandStart1Reps'
    keyframes{1} = [ 1.0; 1.0; 0.5; 1.0; 0.0; 1.0; 0.0; 1.0; 0.5; 0.0; 1.0; 1.0; 1.0; 0.5]; % Index: 3 Position: 44
    keyframes{2} = [ 1.0; 1.0; 0.0; 1.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.5]; % Index: 3 Position: 57
    keyframes{3} = [ 1.0; 1.0; 0.5; 0.5; 0.0; 0.0; 1.0; 1.0; 0.5; 0.0; 0.0; 1.0; 1.0; 0.5]; % Index: 3 Position: 64
    keyframeIndex = [ 3, 3, 3, ];
    keyframePositions = [ 44, 57, 64, ];
    keyframeDistances =  diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = 106;

    case 'cartwheelLHandStart1RepsMirrored'
    keyframes{1} = [ 1.0; 1.0; 1.0; 0.5; 0.0; 1.0; 1.0; 0.0; 0.0; 0.5; 1.0; 1.0; 1.0; 0.5]; % Index: 3 Position: 44
    keyframes{2} = [ 1.0; 1.0; 1.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.5]; % Index: 3 Position: 57
    keyframes{3} = [ 1.0; 1.0; 0.5; 0.5; 0.0; 0.0; 1.0; 1.0; 0.0; 0.5; 0.0; 1.0; 1.0; 0.5]; % Index: 3 Position: 64
    keyframeIndex = [ 3, 3, 3, ];
    keyframePositions = [ 44, 57, 64, ];
    keyframeDistances =  diff(keyframePositions);
    stiffness = [ 0.50, 0.70, ];
    templateLength = 106;

% 	 case 'clap1Reps'
%     %Category: clap1Reps
%     %Template length: 12
%     keyframes{1} = [ 0.5; 0.5; 0.5; 0.5; 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 5
%     keyframes{2} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 3    
%     keyframes{3} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 5
%     keyframeIndex = [ 1,3,1 ];
%     keyframePositions = [ 5, 5, 12];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 1.0, 0.7 ];
%     templateLength = [12];

    
    case  'clap1Reps'
%     Category: clap1Reps
%     Template length: 11
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 3
    keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; ]; % Index: 1 Position: 3
    keyframes{3} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 4
    keyframes{4} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 4
    keyframes{5} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0 ]; % Index: 3 Position: 3
    keyframeIndex = [ 3, 2, 1, 1, 3];
    keyframePositions = [ 3, 3, 3, 4, 9];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.0, 0.90, 0.9];
    templateLength = [11];


    case 'clapAboveHead1Reps'
    %Category: clapAboveHead1Reps
    %Template length: 11
    keyframes{1} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0]; % Index: 3 Position: 3
%     keyframes{2} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
    keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 0.5; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 4
    keyframes{3} = [ 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 4
    keyframeIndex = [ 3, 1, 1];
    keyframePositions = [ 3, 8, 15];
    keyframeDistances =  diff(keyframePositions);
    stiffness = [ 0.80, 0.8];
    templateLength = [23];
    
    
%     case 'clapAboveHead1Reps'
%     %Category: clapAboveHead1Reps
%     %Template length: 11
%     keyframes{1} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 3
%     keyframes{2} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
%     keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 1.0; 0.5; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 4
%     keyframes{4} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 9
%     keyframes{5} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 11
%     keyframeIndex = [ 3, 2, 1, 3, 3];
%     keyframePositions = [ 3, 3, 4, 9, 11];
%     keyframeDistances =  diff(keyframePositions);
%     stiffness = [ 0.80, 0.8, 0.80, 0.8];
%     templateLength = [23];

    case 'depositFloorR'
    %Category: depositFloorR
    %Template length: 73
%    keyframes{1} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 27
%    keyframes{2} = [ 1.0; 0.5; 1.0; 1.0; 1.0; 0.5; 1.0; 0.5; 0.0; 0.5; 1.0; 0.0; 0.5; ]; % Index: 3 Position: 31
%    keyframes{3} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 31
%    keyframes{4} = [ 1.0; 0.5; 1.0; 1.0; 1.0; 0.5; 1.0; 0.5; 0.0; 0.5; 1.0; 0.0; 0.5; ]; % Index: 3 Position: 36
%    keyframes{5} = [ 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5]; % Index: 2 Position: 36
%    keyframeIndex = [ 2, 3, 2, 3, 1 ];
%    keyframePositions = [ 27, 31, 31, 39, 42 ];
%    keyframeDistances =  diff(keyframePositions);
%    stiffness = [ 0.50, 0.8, 0.20, 0.5 ];
%    templateLength = [73];
    keyframes{1} = [ 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5];
    keyframes{2} = [ 1.0; 0.5; 1.0; 1.0; 0.5; 0.5; 1.0; 0.5; 0.0; 0.5; 1.0; 0.0; 0.5; 0.0]; % Index: 3 Position: 36
    keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.5; 1.0; 0.5; 0.0; 0.5; 1.0; 0.5; 0.0; 0.0]; % Index: 3 Position: 36    
    keyframeIndex = [ 1, 3, 3];
    keyframePositions = [ 25, 32, 40 ];
    keyframeDistances =  diff(keyframePositions);
    stiffness = [ 0.5 0.5  ];
    templateLength = [73];
    
    case 'depositLowR'
    keyframes{1} = [ 1.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 22
    keyframes{2} = [ 1.0; 0.5; 1.0; 1.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; ]; % Index: 3 Position: 30
    keyframeIndex = [ 1, 3 ];
    keyframePositions = [ 22, 30 ];
    keyframeDistances =  diff(keyframePositions);
    stiffness = [ 0.8 ];
    templateLength = [71];
 
    case 'depositMiddleR'
%     keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 22
%     keyframes{2} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 30
%     keyframes{3} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.5; 0.5;0.0; 0.0; ]; % 
%     keyframes{4} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.5; 0.5;0.0; 0.0; ]; % 
% 
% 
%     keyframeIndex = [ 1 3 2, 2];
%     keyframePositions = [ 10 10 10, 25];
%     keyframeDistances =  diff(keyframePositions);
%     stiffness = [ 1.0 1.0 0.8];
%     templateLength = [78];
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 22
    keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 41
    keyframes{3} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % 
    keyframes{4} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; %     
    
    keyframes{5} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 22

    keyframeIndex = [ 1, 3, 2, 2, 1];
    keyframePositions = [ 10, 10, 20, 28, 50];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.8, 0.5, 0.9, 0.6];
    templateLength = [56];
   
    
    case 'depositHighR'
        %Category: depositHighR
    %Template length: 73
%     keyframes{1} = [ 1.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 14
%     keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 14
%     keyframes{3} = [ 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 54
%     keyframeIndex = [ 1, 3, 1];
%     keyframePositions = [ 14, 30, 54 ];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.7, 0.7];
%     templateLength = [69];
%     
%     

    keyframes{1} = [ 1.0; 0.5; 0.0; 0.0; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 12
    keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0]; % Index: 3 Position: 33
    keyframes{3} = [ 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 12
    keyframes{4} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0;]; % Index: 2 Position: 12
    keyframeIndex = [ 1, 3, 1, 2];
    keyframePositions = [10 10 27 27];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.5 1.0];
    templateLength = [69];




    case 'elbowToKnee1RepsLelbowStart'
    %Category: elbowToKnee1RepsLelbowStart
    %Template length: 38
    keyframes{1} = [ 0.5; 1.0; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0]; % Index: 3 Position: 12
    keyframes{2} = [ 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 17
    keyframes{3} = [ 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 1 Position: 24
    keyframeIndex = [ 3, 2, 2, ];
    keyframePositions = [ 12, 17, 24, ];
    keyframeDistances =  diff(keyframePositions);
    stiffness = [ 0.50, 0.80, ];
    templateLength = [38];



    case 'elbowToKnee1RepsRelbowStart'
    %Category: elbowToKnee1RepsRelbowStart
    %Template length: 38
    keyframes{1} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 8
    keyframes{2} = [ 1.0; 0.5; 0.5; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0 ]; % Index: 3 Position: 11
    keyframes{3} = [ 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 1 Position: 16
    keyframes{4} = [ 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 1 Position: 25
    keyframeIndex = [ 2, 3, 2, 2, ];
    keyframePositions = [ 9, 11, 16, 25, ];
    keyframeDistances =diff(keyframePositions);
    stiffness = [ 0.5, 0.60, 0.60, ];
    templateLength = [38];
    
    case 'grabFloorR'
    %Category: grabFloorR
    %Template length: 61
    keyframes{1} = [ 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; 1.0; 1.0 ]; % Index: 2 Position: 14
    keyframes{2} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 14    
    keyframes{3} = [ 1.0; 0.5; 1.0; 1.0; 1.0; 0.5; 1.0; 0.5; 0.0; 0.5; 1.0; 0.0; 0.5; 0.0 ]; % Index: 3 Position: 14    


    keyframeIndex = [ 1, 2, 3 ];
    keyframePositions = [ 17, 40, 40 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [0.6 1.0 ];
    templateLength = [61];

    case 'grabHighR'
    %Category: grabHighR
    %Template length: 69
    keyframes{1} = [ 1.0; 0.5; 0.0; 0.0; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 12
    keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0]; % Index: 3 Position: 33
    keyframes{3} = [ 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 12
    keyframes{4} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0;]; % Index: 2 Position: 12
    keyframeIndex = [ 1, 3, 1, 2];
    keyframePositions = [10 10 27 27];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.5 1.0];
    templateLength = [69];

    case 'grabLowR'
    %Category: grabLowR
    %Template length: 72
    keyframes{1} = [ 1.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 20
    keyframes{2} = [ 1.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 22
    keyframes{3} = [ 1.0; 0.5; 1.0; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0 ]; % Index: 3 Position: 33
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 51
    keyframeIndex = [ 1, 1, 3, 1, ];
    keyframePositions = [ 20, 22, 35, 51, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.7, 0.70, ];
    templateLength = [72];

    case 'grabMiddleR'
    %Category: grabMiddleR
    %Template length: 56
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 22
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0 ]; % Index: 3 Position: 41
    keyframes{3} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % 
    keyframes{4} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % 
    keyframes{5} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 22

    keyframeIndex = [ 1, 3, 2, 2,  1];
    keyframePositions = [ 10, 10, 20, 28, 45];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.8, 0.5, 0.9, 0.5];
    templateLength = [56];

	 case 'hitRHandHead'
    %Category: hitRHandHead
    %Template length: 56
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5; ]; % Index: 1 Position: 10
    keyframes{2} = [ 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 1 Position: 22
    keyframeIndex = [ 1, 1, ];
    keyframePositions = [ 10, 22, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70 ];
    templateLength = [56];




    case 'hopBothLegs1hops'

    %Category: hopBothLegs1hops
    %Template length: 24
    keyframes{1} = [ 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0]; % Index: 3 Position: 24

    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 10
    keyframes{3} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 15
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 17
    keyframes{5} = [ 0.5; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0]; % Index: 3 Position: 24
    %keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 24

    keyframeIndex = [ 3, 2, 1, 2, 3];
    keyframePositions = [ 5, 10, 15, 19, 19];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.8, 0.80, 0.50, 0.6];
    templateLength = [24];

    case 'hopLLeg1hops'
    %Category: hopLLeg1hops
    %Template length: 19
%     keyframes{1} = [ 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 6
%     keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 7
%     keyframes{3} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.5; ]; % Index: 1 Position: 17
%     keyframeIndex = [ 2, 1, 2, ];
%     keyframePositions = [ 6, 7, 17, ];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.80, 0.80, ];
%     templateLength = [19];
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 13
    keyframes{2} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 13
    keyframes{3} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 13
    
%     keyframes{1} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.0; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 7
%     keyframes{2} = [ 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 13
%     keyframes{3} = [ 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 15
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 4, 8, 16, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.50, ];
    templateLength = [18];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);



%     case 'hopRLeg1hops'
%     %Category: hopRLeg1hops
%     %Template length: 18
%     keyframes{1} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 5
%     keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 10
%     keyframes{3} = [ 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.5; 1.0; ]; % Index: 1 Position: 13
%     keyframes{4} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 5
%     keyframeIndex = [ 3, 1, 2, 3];
%     keyframePositions = [ 5, 10, 14, 14 ];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.80, 0.50, 1.0];
%     templateLength = [18];
	 case 'hopRLeg1hops'
    %Category: hopRLeg1hops
    %Template length: 18
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 13
    keyframes{2} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 13
    keyframes{3} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 13
    
%     keyframes{1} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.0; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 7
%     keyframes{2} = [ 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 13
%     keyframes{3} = [ 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 15
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 4, 8, 16, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.50, ];
    templateLength = [18];



%keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    
	case 'jog2StepsLstart'
    %Category: jog2StepsLstart
    %Template length: 23
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 6
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 10
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 17
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 6, 10, 17, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [23];
	
  
   case 'jog2StepsLstartMirrored'
    %Category: jog2StepsRstart
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 6
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 10
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 17
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 6, 10, 17, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [23]; 
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    
    
	 case 'jogLeftCircle2StepsRstart'
    %Category: jogLeftCircle2StepsRstart
    %Template length: 23
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 6
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 10
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 17
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 6, 10, 17, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [23];

	 case 'jogRightCircle2StepsLstart'
    %Category: jogLeftCircle2StepsRstart
    %Template length: 23
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 6
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 10
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 17
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 6, 10, 17, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [23];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    

	 case 'jogRightCircle2StepsRstart'
    %Category: jogRightCircle2StepsRstart
    %Template length: 24
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 6
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 11
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 18
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 6, 11, 18, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [24];

	 case 'jogLeftCircle2StepsLstart'
    %Category: jogRightCircle2StepsRstart
    %Template length: 24
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 6
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 11
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 18
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 6, 11, 18, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [24];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    
    
    case 'jogLeftCircle4StepsRstart'
    %Category: jogLeftCircle4StepsRstart
    %Template length: 63
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 30
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 43
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 44
    keyframes{4} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 48
    keyframeIndex = [ 2, 2, 1, 2, ];
    keyframePositions = [ 30, 43, 44, 48, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.8, 0.80, 0.80, ];
    templateLength = [63];

    case 'jogOnPlaceStartFloor2StepsRStart'
    %Category: jogOnPlaceStartFloor2StepsRStart
    %Template length: 29
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 4
    keyframes{3} = [ 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 22
    keyframes{4} = [ 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 22
    keyframes{5} = [ 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 1 Position: 3
    keyframeIndex = [ 2, 3, 3, 3, 2, ];
    keyframePositions = [ 3, 4, 15, 22, 25];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.8, 0.70, 0.7];
    templateLength = [29];
    %extrem schlecht Klasse: Gemeinsame einsen nur im AK_upper-Feature set, das
    %aber so inkonsistent innerhalb der Klasse ist, so dass zu viele
    %0.5-Werte in die Keyframes kommen würden.

    case 'jogRightCircle4StepsRstart'
    %Category: jogRightCircle4StepsRstart
    %Template length: 58

    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 29
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5; ]; % Index: 1 Position: 32
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 1 Position: 45
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 26, 32, 45, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.70, ];
    templateLength = [58];

    case 'jumpDown'
    %Category: jumpDown
    %Template length: 65
    keyframes{1} = [ 1.0; 1.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 16
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 16
    keyframes{3} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0]; % Index: 3 Position: 22
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 37
    %keyframes{4} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 45
    keyframeIndex = [ 1,2, 3, 2];
    keyframePositions = [ 16, 16, 22, 35];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.70, 0.70];
    templateLength = [65];

    case 'jumpingJack1Reps'
    %Category: jumpingJack1Reps
    %Template length: 35
%     keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 8
%     keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 1.0; 0.0; 0.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 11
%     keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 15
%     keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 15
%     keyframeIndex = [ 1, 1, 2, 1, ];
%     keyframePositions = [ 8, 11, 18, 25, ];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.80, 0.5,  0.50, ];
%     templateLength = [35];
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 11    
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 15
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 15
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 15
    keyframeIndex = [1, 2, 2,  2, ];
    keyframePositions = [ 3, 8, 18, 28, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.6, 0.60, 0.6 ];
    templateLength = [35];




    
	 case 'kickLFront1Reps'
    %Category: kickLFront1Reps
    %Template length: 56
    keyframes{1} = [ 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 21
    keyframes{2} = [ 1.0; 0.0; 0.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 26
    keyframeIndex = [ 2, 2 ];
    keyframePositions = [ 21, 26 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80 ];
    templateLength = [56];

    
    
%     case 'kickLFront1Reps'
%     %Category: kickLFront1Reps
%     %Template length: 55
%     keyframes{1} = [ 0.5; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 10
%     keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 10
% 
%     keyframes{3} = [ 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 0.5; 0.5; 0.5; 1.0; ]; % Index: 1 Position: 18
%     keyframes{4} = [ 1.0; 0.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 1 Position: 20
%     keyframes{5} = [ 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 25
%     keyframeIndex = [ 3, 2, 2, 2, 2, ];
%     keyframePositions = [ 10, 10, 20, 22, 27, ];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 1.0, 0.6, 0.80, 0.80, ];
%     templateLength = [55];
    
%     case 'kickLSide1Reps'
% 
%     %Category: kickLSide1Reps 
%     %Template length: 55
%     keyframes{1} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 1.0; ]; % Index: 1 Position: 19
%     keyframes{2} = [ 0.5; 0.5; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; 0.5; 1.0; ]; % Index: 1 Position: 22
%     keyframes{3} = [ 0.5; 0.5; 0.0; 1.0; 1.0; 0.0; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 29
%     keyframes{4} = [ 1.0; 0.5; 0.5; 1.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 1.0; 0.5; ]; % Index: 3 Position: 29
%     keyframeIndex = [ 2, 2, 2, 3];
%     keyframePositions = [ 19, 22, 29, 29];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.80, 0.80, 1.0 ];
%     templateLength = [55];
%     % Hinweis: Durch den 4. Keyframe werden 3 Sidekick-Bewegungen
%     % herausgefiltert (3 von Meinard). Diese stellen sich bei der Durchsicht
%     % allerdings als front-kicks heraus.

	 case 'kickLSide1Reps'
    %Category: kickLSide1Reps
    %Template length: 65
    keyframes{1} = [ 0.0; 0.5; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; 0.0; 1.0; ]; % Index: 2 Position: 19
    keyframes{2} = [ 0.5; 0.5; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 26
    keyframes{3} = [ 0.5; 0.5; 0.0; 1.0; 1.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 28
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 19, 26, 28, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.60, 0.60, ];
    templateLength = [65];





%     case 'kickRFront1Reps'
%     %Category: kickRFront1Reps
%     %Template length: 53
%     keyframes{1} = [ 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 1 Position: 19
%     keyframes{2} = [ 0.0; 0.5; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 1 Position: 22
%     keyframes{3} = [ 0.5; 0.5; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 22
%     keyframes{4} = [ 0.0; 0.5; 1.0; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 32
%     keyframes{5} = [ 0.5; 0.5; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 29
%     keyframeIndex = [ 2, 2, 3, 2, 3];
%     keyframePositions = [ 19, 22, 26, 32, 32];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.80, 0.6, 0.6, 1.0 ];
%     templateLength = [53];
	 case 'kickRFront1Reps'
    %Category: kickRFront1Reps
    %Template length: 53
    keyframes{1} = [ 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 15
    keyframes{2} = [ 0.0; 0.5; 1.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 34
    keyframeIndex = [ 2, 2, ];
    keyframePositions = [ 15, 34, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70,  ];
    templateLength = [53];



    case 'kickRSide1Reps'
    %Category: kickRSide1Reps
    %Template length: 51
    keyframes{1} = [ 0.5; 0.0; 0.5; 0.0; 0.5; 1.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; ]; % Index: 1 Position: 18
    keyframes{2} = [ 0.5; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 33
    keyframeIndex = [ 2, 2, ];
    keyframePositions = [ 18, 27 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0 ];
    templateLength = [51];

% Bemerkung: KickSide1Reps_009 ist extrem kurz und enthält kaum Daten.


    case 'kickLFront1RepsMirrored'
    %Category: kickLFront1RepsMirrored
    %Template length: 56
    keyframes{1} = [ 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 21
    keyframes{2} = [ 1.0; 0.0; 0.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 26
    keyframeIndex = [ 2, 2 ];
    keyframePositions = [ 21, 26 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80 ];
    templateLength = [56];
    
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    
    
    case 'kickLSide1RepsMirrored'

    %Category: kickLSide1RepsMirrored 

        %Template length: 65
    keyframes{1} = [ 0.0; 0.5; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; 0.0; 1.0; ]; % Index: 2 Position: 19
    keyframes{2} = [ 0.5; 0.5; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 26
    keyframes{3} = [ 0.5; 0.5; 0.0; 1.0; 1.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 28
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 19, 26, 28, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.60, 0.60, ];
    templateLength = [65];

%     keyframes{1} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 1.0; ]; % Index: 1 Position: 19
%     keyframes{2} = [ 0.5; 0.5; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; 0.5; 1.0; ]; % Index: 1 Position: 22
%     keyframes{3} = [ 0.5; 0.5; 0.0; 1.0; 1.0; 0.0; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 29
%     keyframes{4} = [ 1.0; 0.5; 0.5; 1.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 1.0; 0.5; ]; % Index: 3 Position: 29
%     keyframeIndex = [ 2, 2, 2, 3];
%     keyframePositions = [ 19, 22, 29, 29];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.80, 0.80, 1.0 ];
%     templateLength = [55];
    % Hinweis: Durch den 4. Keyframe werden 3 Sidekick-Bewegungen
    % herausgefiltert (3 von Meinard). Diese stellen sich bei der Durchsicht
    % allerdings als front-kicks heraus.
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);    

    case 'kickRFront1RepsMirrored'

    %Category: kickRFront1RepsMirrored
    %Template length: 53
    keyframes{1} = [ 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 15
    keyframes{2} = [ 0.0; 0.5; 1.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 34
    keyframeIndex = [ 2, 2, ];
    keyframePositions = [ 15, 34, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70,  ];
    templateLength = [53];

    keyframes = mirrorKeyframes(keyframes, keyframeIndex);    

    case 'kickRSide1RepsMirrored'
    %Category: kickRSide1RepsMirrored
    %Template length: 51
    keyframes{1} = [ 0.5; 0.0; 0.5; 0.0; 0.5; 1.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; ]; % Index: 1 Position: 18
    keyframes{2} = [ 0.5; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 33
    keyframeIndex = [ 2, 2, ];
    keyframePositions = [ 18, 27 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0 ];
    templateLength = [51];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);    

    case 'lieDownFloor'
    %Category: lieDownFloor
    %Template length: 170
    keyframes{1} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5]; % Index: 3 Position: 31
    keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 0.0 ]; % Index: 3 Position: 75
    keyframes{3} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 132
    keyframeIndex = [ 3, 3, 3, ];
    keyframePositions = [ 31, 70, 135, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.50, ];
    templateLength = [150];
    %perfekt match!

    case 'lieDownFloorNew'
    %Category: lieDownFloor
    %Template length: 170
    keyframes{1} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5]; % Index: 3 Position: 31
    keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 0.0]; % Index: 3 Position: 75
    keyframes{3} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 132
    keyframeIndex = [ 3, 3, 3, ];
    keyframePositions = [ 31, 70, 135, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.50, ];
    templateLength = [150];
    %perfekt match!

    case 'punchLFront1Reps'
    %Category: punchLFront1Reps
    %Template length: 49
    keyframes{1} = [ 0.5; 1.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.0; 0.5; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 20
    keyframes{2} = [ 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 24
%     keyframes{2} = [ 0.5; 1.0; 0.0; 0.5; 0.0; 1.0; 0.5; 0.5; 0.0; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 24
%     keyframes{3} = [ 0.0; 1.0; 0.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.5; 0.5; 0.5; 0.5; 1.0; ]; % Index: 2 Position: 26
%     keyframes{4} = [ 0.5; 1.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 132
%     keyframes{5} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 26

    keyframeIndex = [ 1, 1 ];
    keyframePositions = [ 17, 30];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.60 ];
    templateLength = [49];
    %Sehr schwierige Klasse: Extrem unterschiedlich im lower-Bereich.
    
    case 'punchLSide1Reps'

    %Category: punchLSide1Reps
    %Template length: 42
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 0.0; 0.5; 0.5; 0.5; 0.5; 1.0; ]; % Index: 2 Position: 19
    keyframes{2} = [ 0.5; 0.5; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 29
    keyframes{3} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 29
    keyframeIndex = [ 1,1, 1 ];
    keyframePositions = [ 10, 20, 30 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.5, 0.5];
    templateLength = [42];
    %extrem schwierige Klasse
    

	 case 'punchRFront1Reps'
    %Category: punchRFront1Reps
    %Template length: 46
    keyframes{1} = [ 0.5; 0.0; 0.0; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.5; 0.5; 1.0; 0.5; ]; % Index: 1 Position: 16
    keyframes{2} = [ 1.0; 0.5; 0.5; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.5; 0.5; 1.0; 0.5; ]; % Index: 1 Position: 18
    keyframes{3} = [ 1.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 22
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 16, 18, 22, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.70, ];
    templateLength = [46];

    

 	 case 'punchRSide1Reps'
    %Category: punchRSide1Reps
    %Template length: 45
    keyframes{1} = [ 0.5; 0.0; 0.0; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 1 Position: 13
    keyframes{2} = [ 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 0.0; 0.0; 1.0; 0.5; ]; % Index: 1 Position: 26
    keyframes{3} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; ]; % Index: 1 Position: 33
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 13, 26, 33, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.50, ];
    templateLength = [45];


    case 'punchLFront1RepsMirrored'
    %Category: punchLFront1Reps
    %Template length: 49
    keyframes{1} = [ 0.5; 1.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.0; 0.5; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 20
    keyframes{2} = [ 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 24
%     keyframes{2} = [ 0.5; 1.0; 0.0; 0.5; 0.0; 1.0; 0.5; 0.5; 0.0; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 24
%     keyframes{3} = [ 0.0; 1.0; 0.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.5; 0.5; 0.5; 0.5; 1.0; ]; % Index: 2 Position: 26
%     keyframes{4} = [ 0.5; 1.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 132
%     keyframes{5} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 26

    keyframeIndex = [ 1, 1 ];
    keyframePositions = [ 17, 30];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.60 ];
    templateLength = [49];

    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    
    case 'punchLSide1RepsMirrored'

    %Category: punchLSide1Reps
    %Template length: 42
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 0.0; 0.5; 0.5; 0.5; 0.5; 1.0; ]; % Index: 2 Position: 19
    keyframes{2} = [ 0.5; 0.5; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 29
    keyframes{3} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 29
    keyframeIndex = [ 1,1, 1 ];
    keyframePositions = [ 10, 20, 30 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.5, 0.5];
    templateLength = [42];
    %extrem schwierige Klasse
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);

	 case 'punchRFront1RepsMirrored'
    %Category: punchRFront1Reps
    %Template length: 46
    keyframes{1} = [ 0.5; 0.0; 0.0; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.5; 0.5; 1.0; 0.5; ]; % Index: 1 Position: 16
    keyframes{2} = [ 1.0; 0.5; 0.5; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.5; 0.5; 1.0; 0.5; ]; % Index: 1 Position: 18
    keyframes{3} = [ 1.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 22
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 16, 18, 22, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.70, ];
    templateLength = [46];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    

 	 case 'punchRSide1RepsMirrored'
    %Category: punchRSide1Reps
    %Template length: 45
    keyframes{1} = [ 0.5; 0.0; 0.0; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 1 Position: 13
    keyframes{2} = [ 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 0.0; 0.0; 1.0; 0.5; ]; % Index: 1 Position: 26
    keyframes{3} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; ]; % Index: 1 Position: 33
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 13, 26, 33, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.50, ];
    templateLength = [45];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    

    case 'rotateArmsBothBackward1Reps'
    %Category: rotateArmsBothBackward1Reps
    %Template length: 29
    keyframes{1} = [ 1.0; 1.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 4
    keyframes{2} = [ 0.0; 0.0; 1.0; 1.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 11
    keyframes{3} = [ 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 17
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 4, 9, 15, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.60, ];
    templateLength = [29];
    % perfekt match

    case 'rotateArmsBothForward1Reps'
    %Category: rotateArmsBothForward1Reps
    %Template length: 31
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 5
    keyframes{2} = [ 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 12

    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 12

    keyframes{4} = [ 1.0; 1.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 19
    keyframeIndex = [ 1,  1, 1, 1, ];
    keyframePositions = [ 5,  12,  15, 19, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.5, 0.6, 0.50, ];
    templateLength = [31];

    case 'rotateArmsLBackward1Reps'
    %Category: rotateArmsLBackward1Reps
    %Template length: 30
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 4
    keyframes{2} = [ 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 10
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 27
    keyframeIndex = [ 1,  1, 1, ];
    keyframePositions = [ 4,  10, 27, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.60, 0.40, ];
    templateLength = [30];
    %perfekt match

    case 'rotateArmsLForward1Reps'

    %Category: rotateArmsLForward1Reps
    %Template length: 30
    keyframes{1} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 7
    keyframes{2} = [ 0.5; 1.0; 0.0; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 12
    keyframes{3} = [ 0.5; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 19
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 7, 12, 19, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [30];
    %perfekt match

    case 'rotateArmsRBackward1Reps'
    %Category: rotateArmsRBackward1Reps
    %Template length: 28
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 4
    keyframes{2} = [ 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 8
    keyframes{3} = [ 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 24
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 4, 8, 24, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.50, ];
    templateLength = [28];
    %perfekt match

    case 'rotateArmsRForward1Reps'
    %Category: rotateArmsRForward1Reps
    %Template length: 27
    keyframes{1} = [ 1.0; 0.0; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 11
    keyframes{2} = [ 1.0; 0.5; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 13
    keyframes{3} = [ 1.0; 0.5; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 16
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 11, 13, 16, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.60, 0.60, ];
    templateLength = [27];
    %perfekt match

    
  case 'rotateArmsLBackward1RepsM'
    %Category: rotateArmsLBackward1Reps
    %Template length: 30
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 4
    keyframes{2} = [ 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 10
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 27
    keyframeIndex = [ 1,  1, 1, ];
    keyframePositions = [ 4,  10, 27, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.60, 0.40, ];
    templateLength = [30];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    

    case 'rotateArmsLForward1RepsM'

    %Category: rotateArmsLForward1Reps
    %Template length: 30
    keyframes{1} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 7
    keyframes{2} = [ 0.5; 1.0; 0.0; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 12
    keyframes{3} = [ 0.5; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 19
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 7, 12, 19, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [30];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);

    case 'rotateArmsRBackward1RepsM'
    %Category: rotateArmsRBackward1Reps
    %Template length: 28
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 4
    keyframes{2} = [ 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 8
    keyframes{3} = [ 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 24
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 4, 8, 24, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.50, ];
    templateLength = [28];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);

    case 'rotateArmsRForward1RepsM'
    %Category: rotateArmsRForward1Reps
    %Template length: 27
    keyframes{1} = [ 1.0; 0.0; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 11
    keyframes{2} = [ 1.0; 0.5; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 13
    keyframes{3} = [ 1.0; 0.5; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 16
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 11, 13, 16, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.60, 0.60, ];
    templateLength = [27];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    
    
    case 'runOnPlaceStartFloor2StepsRStart'
    %Category: runOnPlaceStartFloor2StepsRStart
    %Template length: 22
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 14
    keyframes{2} = [ 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 4
    keyframes{3} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 14
    keyframes{4} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.5; 1.0; ]; % Index: 1 Position: 17
    keyframes{5} = [ 0.5; 0.5; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 4

    keyframeIndex = [ 2, 3, 2, 2, 3];
    keyframePositions = [ 4, 4, 14, 17, 17];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.80, 0.80, 1.0];
    templateLength = [22];

	 case 'shuffle2StepsLStart'
    %Category: shuffle2StepsLStart
    %Template length: 49
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 5
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 21
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 44
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 5, 21, 44, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [49];


    
 	 case 'shuffle2StepsRStart'
    %Category: shuffle2StepsRStart
    %Template length: 62
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 25
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 34
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 42
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 25, 34, 42, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [62];
    %HDM_dg_shuffle2StepsRStart_005_120.amc.MAT ist eine 4stepsRstart Bewegung!

    
	 case 'sitDownChair'
    %Category: sitDownChair
    %Template length: 76
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 23
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 23
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 46
    keyframes{4} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0]; % Index: 3 Position: 49
    keyframeIndex = [ 2, 2, 2, 3, ];
    keyframePositions = [ 10, 23, 49, 49, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, 0.8, ];
    templateLength = [76];

     case 'sitDownChairNew'
    %Category: sitDownChair
    %Template length: 76
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 23
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 23
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 46
    keyframes{4} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0;]; % Index: 3 Position: 49
    keyframeIndex = [ 2, 2, 2, 3, ];
    keyframePositions = [ 10, 23, 49, 49, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, 0.8, ];
    templateLength = [76];
    
    
    
%    case 'sitDownChair'
    %Category: sitDownChair
    %Template length: 84
%     keyframes{1} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5]; % Index: 3 Position: 11
%     keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 34
%     keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 42
%     keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 56
%     keyframes{5} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 11
%     keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 34
% 
%     keyframeIndex = [ 3, 2, 2, 2, 3, 2];
%     keyframePositions = [ 22, 34, 42, 56, 56, 65];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.9, 1.00, 0.90, 1.0, 0.6];
%     templateLength = [84];

%     case 'sitDownFloor'
% 
%     %Category: sitDownFloor
%     %Template length: 106
%     keyframes{1} = [ 0.5; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 1.0; ]; % Index: 3 Position: 30
%     keyframes{2} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 42
% 
%     keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; 0.5; 0.0; ]; % Index: 3 Position: 78
% 
%     keyframes{4} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.0; 1.0; 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; ]; % Index: 3 Position: 93
%     keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 11
%     keyframeIndex = [ 3, 2, 3, 3, 1 ];
%     keyframePositions = [ 30, 30, 50, 63, 63 ];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 1.00, 0.40, 0.4, 1.0];
%     templateLength = [106];


	 case 'sitDownFloor'
    %Category: sitDownFloor
    %Template length: 105
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 30
    keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.0; 1.0; 1.0; 0.5; 0.5; 1.0; 0.5; 0.0; 0.0]; % Index: 3 Position: 78
    keyframeIndex = [ 2, 3, ];
    keyframePositions = [ 30, 70, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70 ];
    templateLength = [105];

	 case 'sitDownFloorNew'
    %Category: sitDownFloor
    %Template length: 105
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 30
    keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.0; 1.0; 1.0; 0.5; 0.5; 1.0; 0.5; 0.0; 0.0]; % Index: 3 Position: 78
    keyframeIndex = [ 2, 3, ];
    keyframePositions = [ 30, 70, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70 ];
    templateLength = [105];

    case 'sitDownKneelTieShoes'
    %Category: sitDownKneelTieShoes
    %Template length: 165
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 56
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 56
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 1.0; 1.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.0]; % Index: 3 Position: 62
    keyframes{4} = [ 1.0; 1.0; 0.5; 1.0; 0.5; 0.5; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0]; % Index: 3 Position: 85
    keyframeIndex = [ 2, 2, 3, 3, ];
    keyframePositions = [ 10, 46, 52, 145, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.8, 1.00, 0.60, ];
    templateLength = [155];
    %perfekt match
    
    case 'sitDownKneelTieShoesNew'
    %Category: sitDownKneelTieShoes
    %Template length: 165
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 56
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 56
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 1.0; 1.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.0]; % Index: 3 Position: 62
    keyframes{4} = [ 1.0; 1.0; 0.5; 1.0; 0.5; 0.5; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0]; % Index: 3 Position: 85
    keyframeIndex = [ 2, 2, 3, 3, ];
    keyframePositions = [ 10, 46, 52, 145, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.8, 1.00, 0.60, ];
    templateLength = [155];
    %perfekt match    

    case 'sitDownTable'
    %Category: sitDownTable
    %Template length: 70
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 25
    keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 2 Position: 11
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 2 Position: 22
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 11

    keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 39
    keyframes{6} = [ 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 85

    keyframeIndex = [ 2, 1, 1, 1, 1, 3];
    keyframePositions = [ 22, 22, 27, 35, 41, 41];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.50, 0.8, 0.80, 1.0 ];
    templateLength = [70];
    %Sehr schlecht Klasse: !KEINE! gemeinsamen einsen können gefunden werden!


    case 'skier1RepsLstart'
    %Category: skier1RepsLstart
    %Template length: 36
     keyframes{1} = [ 0.5; 0.5; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.5; 0.0]; % Index: 3 Position: 10
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 5
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 5
    keyframes{4} = [ 0.0; 1.0; 0.0; 0.5; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.5; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 20
    keyframes{5} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 25

    keyframeIndex = [ 3, 2, 2, 1, 2 ];
    keyframePositions = [ 5, 10, 13, 15, 24  ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.7, 0.5, 0.5, 0.50,  ];
    templateLength = [36];

    case 'sneak2StepsLStart'
    %Category: sneak2StepsLStart
    %Template length: 58
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 16
    keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 25
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 31
    keyframes{4} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 31

    keyframeIndex = [ 2, 2, 2, 2];
    keyframePositions = [ 16, 25, 31,45];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.60, 0.8];
    templateLength = [58];

    case 'sneak2StepsRStart'
    %Category: sneak2StepsRStart
    %Template length: 63
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 21
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 20
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 21
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 36
    keyframes{5} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 1 Position: 41
    keyframes{6} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 21

    keyframeIndex = [ 2, 1, 2, 2, 2, 2];
    keyframePositions = [ 21, 21, 25, 36, 45, 53];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.0, 0.80, 0.50, 0.8];
    templateLength = [63];

    case 'squat1Reps'
    %Category: squat1Reps
    %Template length: 47
    keyframes{1} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0]; % Index: 3 Position: 15
    keyframes{2} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 0.0; 0.0]; % Index: 3 Position: 25
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.0]; % Index: 3 Position: 30
    keyframes{4} = [ 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 20

    keyframeIndex = [ 3, 3, 3, 1];
    keyframePositions = [ 15, 25, 30, 32];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, 0.5];
    templateLength = [47];
    %perfekt match

    
     case 'staircaseDown2Lstart'
    %Category: staircaseDown2Lstart
    %Template length: 30
    keyframes{1} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 4
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 12
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 20
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 4, 12, 20, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [30];
	 case 'staircaseDown2Rstart'
    %Category: staircaseDown2Rstart
    %Template length: 29
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 11
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 20
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 25
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 9, 20, 25, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.80, ];
    templateLength = [29];

    
    case 'staircaseDown3Rstart'
    %Category: staircaseDown3Rstart
    %Template length: 52
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 23
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 23
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 27
    keyframes{4} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 30
    keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.5; 1.0; 0.0; ]; % Index: 1 Position: 36
    keyframeIndex = [ 2, 2, 2, 3, 2, ];
    keyframePositions = [ 13, 23, 27, 27, 36, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.8, 0.70, 1.0, 0.70, ];
    templateLength = [52];
    % schlecht von walk-Bewegungen separierbar


    
	 case 'staircaseUp2Lstart'
    %Category: staircaseUp2Lstart
    %Template length: 39
    keyframes{1} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 11
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 16
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 35
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 11, 16, 35, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.50, ];
    templateLength = [39];

 	 case 'staircaseUp2Rstart'
    %Category: staircaseUp2Rstart
    %Template length: 34
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 11
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 17
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 31
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 11, 17, 31, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [34];

    case 'staircaseUp3Rstart'
    %Category: staircaseUp3Rstart
    %Template length: 78
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 11
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 18
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 18
    keyframes{4} = [ 0.0; 0.0; 0.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0]; % Index: 3 Position: 30
    keyframes{5} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 1 Position: 41
    keyframeIndex = [ 2, 2, 2, 3, 2, ];
    keyframePositions = [ 11, 18, 30, 32, 35, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.5, 0.5, 0.30, ];
    templateLength = [78];

    case 'standStill500'
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 12    
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 9
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0]; % Index: 1 Position: 12
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 12    
    keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 9
    keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0]; % Index: 1 Position: 12
    keyframeIndex = [ 1, 2, 3, 1, 2, 3 ];
    keyframePositions = [ 5, 5, 5, 10, 10, 10 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.0, 0.5, 1.0, 1.0 ];
    templateLength = [15];

    
    case 'standStill2000'
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 12    
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 9
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0]; % Index: 1 Position: 12
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 12    
    keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 9
    keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0]; % Index: 1 Position: 12
    keyframes{7} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 12    
    keyframes{8} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 9
    keyframes{9} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0]; % Index: 1 Position: 12
    keyframeIndex = [ 1, 2, 3, 1, 2, 3, 1, 2, 3];
    keyframePositions = [ 5, 5, 5, 30, 30, 30, 55, 55, 55 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0];
    templateLength = [60];

    
    
    case 'standUpKneelToStand'
    %Category: standUpKneelToStand
    %Template length: 44
    keyframes{1} = [ 0.5; 1.0; 1.0; 1.0; 0.5; 0.5; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0]; % Index: 3 Position: 5
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 9
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 12
    keyframeIndex = [ 3, 2, 1, ];
    keyframePositions = [ 5, 12, 12, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 1.00, ];
    templateLength = [44];

   case 'standUpKneelToStandNew'
    %Category: standUpKneelToStand
    %Template length: 44
    keyframes{1} = [ 0.5; 1.0; 1.0; 1.0; 0.5; 0.5; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0]; % Index: 3 Position: 5
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 9
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 12
    keyframeIndex = [ 3, 2, 1, ];
    keyframePositions = [ 5, 12, 12, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 1.00, ];
    templateLength = [44];
    
    case 'standUpLieFloor'
    %Category: standUpLieFloor
    %Template length: 134
    keyframes{1} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 15
    keyframes{2} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 33
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5]; % Index: 3 Position: 110
    keyframeIndex = [ 3, 3, 3, ];
    keyframePositions = [ 20, 33, 100, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.70, ];
    templateLength = [134];
    %perfekt match

    case 'standUpLieFloorNew'
    %Category: standUpLieFloor
    %Template length: 134
    keyframes{1} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 15
    keyframes{2} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 33
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5]; % Index: 3 Position: 110
    keyframeIndex = [ 3, 3, 3, ];
    keyframePositions = [ 20, 33, 100, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.70, ];
    templateLength = [134];
    %perfekt match
    
	 case 'standUpSitChair'
    %Category: standUpSitChair
    %Template length: 71
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 9
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 27
    keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0]; % Index: 3 Position: 58
    keyframes{4} = [ 0.0; 0.5; 1.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0]; % Index: 3 Position: 58
    keyframes{5} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 27
    keyframeIndex = [ 2, 2, 3, 3, 2 ];
    keyframePositions = [ 9, 27, 27, 48, 57 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.8, 0.70, 0.8];
    templateLength = [71];

    case 'standUpSitChairNew'
    %Category: standUpSitChair
    %Template length: 71
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 9
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 27
    keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0 ]; % Index: 3 Position: 58
    keyframes{4} = [ 0.0; 0.5; 1.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0 ]; % Index: 3 Position: 58
    keyframes{5} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 27
    keyframeIndex = [ 2, 2, 3, 3, 2 ];
    keyframePositions = [ 9, 27, 27, 48, 57 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.8, 0.70, 0.8];
    templateLength = [71]; 
    
    
%     case 'standUpSitChair'
%     %Category: standUpSitChair
%     %Template length: 72
%     keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 9
%     keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 9
%     keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; ]; % Index: 3 Position: 39
%     keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 9
%     keyframes{5} = [ 0.0; 0.5; 1.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 58
%     keyframeIndex = [ 2, 2, 3, 2, 3];
%     keyframePositions = [ 9, 15, 39, 39, 47];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.80, 0.7, 1.00, 0.5];
%     templateLength = [72];

    case 'standUpSitFloor'
    %Category: standUpSitFloor
    %Template length: 96

    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0]; % Index: 3 Position: 18
    keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 1.0; 1.0; 0.5; 0.0; 1.0; 0.5; 0.5; 0.0]; % Index: 3 Position: 40
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 0.5; 0.0]; % Index: 3 Position: 70
    keyframes{4} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.5; 0.0]; % Index: 3 Position: 70

    keyframeIndex = [ 2, 3, 3, 3 ];
    keyframePositions = [ 18, 60, 79, 95];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.6, 0.6,0.6 ];
    templateLength = [96];

    case 'standUpSitFloorNew'
    %Category: standUpSitFloor
    %Template length: 96

    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0]; % Index: 3 Position: 18
    keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 1.0; 1.0; 0.5; 0.0; 1.0; 0.5; 0.5; 0.0]; % Index: 3 Position: 40
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 0.5; 0.0]; % Index: 3 Position: 70
    keyframes{4} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.5; 0.0]; % Index: 3 Position: 70

    keyframeIndex = [ 2, 3, 3, 3 ];
    keyframePositions = [ 18, 60, 79, 95];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.6, 0.6,0.6 ];
    templateLength = [96];

    case 'standUpSitTable'
    %Category: standUpSitTable
    %Template length: 60
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 7
    keyframes{2} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 65
    keyframes{3} = [ 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 7
    keyframes{4} = [ 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 11
    keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 7
    keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 7
    keyframes{7} = [ 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 11
    keyframeIndex = [ 1, 2, 3, 3, 1, 1, 3];
    keyframePositions = [ 7, 7, 7, 11, 20, 30, 45];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.0, 0.70, 0.9, 0.9, 0.5];
    templateLength = [60];
    %extrem schlecht Klasse: Keine gemeinsamten einsen!

    case 'throwBasketball'
    %Category: throwBasketball
    %Template length: 95
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.5; 1.0; 1.0; 0.5; 0.5; 0.0; 0.5; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 18
    keyframes{2} = [ 0.5; 0.0; 0.5; 0.5; 1.0; 1.0; 0.5; 0.5; 0.0; 0.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 22
    keyframes{3} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0]; % Index: 3 Position: 27
    keyframes{4} = [ 0.5; 0.5; 1.0; 1.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 22
    keyframes{5} = [ 1.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0]; % Index: 3 Position: 27
    keyframeIndex = [ 1, 1, 3, 1, 3];
    keyframePositions = [ 18, 22, 27, 40, 40];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.00, 0.50, 0.6, 1.0];
    templateLength = [95];

	 case 'throwSittingHighR'
    %Category: throwSittingHighR
    %Template length: 77
    keyframes{1} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.5; 0.0; 1.0; 0.0; 1.0; 1.0; 0.0; 0.0 ]; % Index: 3 Position: 22
    keyframes{2} = [ 1.0; 0.0; 1.0; 0.0; 0.5; 0.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.5; 1.0; 0.5 ]; % Index: 3 Position: 27
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 22
    keyframeIndex = [ 3, 1, 3 ];
    keyframePositions = [ 22, 37, 37 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 1.0 ];
    templateLength = [77];

	 case 'throwSittingLowR'
    %Category: throwSittingLowR
    %Template length: 69
    keyframes{1} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 1.0; 0.5; 1.0; 0.0; 1.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 30
    keyframes{2} = [ 1.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.5; 0.5; 0.5; 1.0; 0.5; 0.5; 1.0; 0.5 ]; % Index: 1 Position: 30
    keyframes{3} = [ 1.0; 0.5; 1.0; 1.0; 0.5; 0.0; 1.0; 0.5; 0.5; 0.0; 1.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 38
    keyframes{4} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.5; 0.5; 0.0; 0.5; 1.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 53
    keyframeIndex = [ 3, 1, 3, 3, ];
    keyframePositions = [ 30, 38, 38, 48, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 1.0,  0.50, ];
    templateLength = [69];

    
	 case 'throwStandingHighR'
    %Category: throwStandingHighR
    %Template length: 93
    keyframes{1} = [ 1.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.5; 0.0]; % Index: 3 Position: 41
    keyframes{2} = [ 1.0; 0.0; 1.0; 0.0; 0.5; 0.5; 1.0; 0.5; 0.0; 0.5; 0.5; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 47
    keyframes{3} = [ 1.0; 0.0; 1.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.5; 0.5; 0.0; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 53
    keyframeIndex = [ 3, 1, 1, ];
    keyframePositions = [ 41, 47, 53, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [93];

	 case 'throwStandingLowR'
    %Category: throwStandingLowR
    %Template length: 91
    keyframes{1} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0;]; %Index: 3 Position: 19
    keyframes{2} = [ 1.0; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 0.0]; %Index: 3 Position: 19
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 1.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 39
    keyframes{4} = [ 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 62
    keyframeIndex = [ 2, 3, 1, 1, ];
    keyframePositions = [ 18, 30, 39, 50, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.7, 0.50, 0.50, ];
    templateLength = [91];

 	 case 'tpose500'
    %Category: tpose500
    %Template length: 15
    keyframes{1} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; ]; % Index: 3 Position: 3
    keyframes{2} = [ 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 3
    keyframes{4} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; ]; % Index: 3 Position: 3
    keyframes{5} = [ 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
    keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 3
    keyframeIndex = [ 3, 1, 2, 3, 1, 2];
    keyframePositions = [ 5, 5, 5, 10, 10, 10 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.00, 0.5, 1.0, 1.0 ];
    templateLength = [15];

 	 case 'tpose1000'
    %Category: tpose500
    %Template length: 15
    keyframes{1} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; ]; % Index: 3 Position: 3
    keyframes{2} = [ 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 3
    keyframes{4} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; ]; % Index: 3 Position: 3
    keyframes{5} = [ 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
    keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 3
    keyframeIndex = [ 3, 1, 2, 3, 1, 2,];
    keyframePositions = [ 5, 5, 5, 25 25, 25];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.00, 0.5, 1.0, 1.0];
    templateLength = [30];    
    
    
 	 case 'tpose2000'
    %Category: tpose500
    %Template length: 15
    keyframes{1} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; ]; % Index: 3 Position: 3
    keyframes{2} = [ 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 3
    keyframes{4} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; ]; % Index: 3 Position: 3
    keyframes{5} = [ 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
    keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 3
    keyframes{7} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; ]; % Index: 3 Position: 3
    keyframes{8} = [ 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
    keyframes{9} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 3
    keyframeIndex = [ 3, 1, 2, 3, 1, 2, 3, 1, 2];
    keyframePositions = [ 5, 5, 5, 30, 30, 30, 55, 55, 55];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.00, 0.5, 1.0, 1.0 0.5, 1.0 1.0];
    templateLength = [60];    
   
    
    case 'turnLeft'
    %Category: turnLeft
    %Template length: 48
%     keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 20
%     keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5 ]; % Index: 3 Position: 29
%     keyframes{3} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; ]; % Index: 1 Position: 65
% 
%     keyframes{4} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 20
% 
%     keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5]; % Index: 3 Position: 29
%     keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5]; % Index: 3 Position: 44
%     keyframes{7} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 1 Position: 65
%     keyframeIndex = [ 1, 3, 2, 1, 3, 3, 2];
%     keyframePositions = [ 20, 20, 20, 24, 29, 44, 44];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 1.0, 1.0, 0.7, 0.80, 0.80, 1.0 ];
    keyframes{1} = [ 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0 ];
    keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.5; ]; 
%     keyframes{3} = [ 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0 ];
%     keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5]; 
    keyframeIndex = [ 3, 1];%, 3, 3];
    keyframePositions = [ 10, 10];%, 15, 25];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0 ];% 0.7, 0.8 ];
    templateLength = [20];

    case 'turnRight'
    %Category: turnRight
    %Template length: 49
%     keyframes{1} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.5; ]; % Index: 1 Position: 43
%     keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 20
%     keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 22
% 
%     keyframes{4} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; ]; % Index: 1 Position: 43
%     keyframes{5} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 20
%     keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 22
% 
%     keyframes{7} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 22
% 
%     keyframes{8} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 43
%     keyframes{9} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 22
% 
%     keyframeIndex =     [ 2, 1, 3, 2,   1,  3, 3, 2, 3];
%     keyframePositions = [ 8, 8, 8, 22, 22, 22, 30, 43, 43 ];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 1.0, 1.0, 0.8, 1.00, 1.00, 0.8, 0.8, 1.0 ];
%     templateLength = [49];
%     % dg_turnRight_022 ist eine TurnLeft - Bewegung!!
%     % Klasse extrem schlecht, keine gemeinsamen einsen!

    keyframes{1} = [ 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0 ];
    keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.5; ]; 
%     keyframes{3} = [ 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0 ];
%     keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5]; 
    keyframeIndex = [ 3, 1];%, 3, 3];
    keyframePositions = [ 10, 10];%, 15, 25];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0 ];% 0.7, 0.8 ];
    templateLength = [20];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);

    case 'walk2StepsLstart'
    %Category: walk2StepsLstart
    %Template length: 41
%     keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 6
%     keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 15
%     keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 15
%     keyframes{4} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 26
%     keyframes{5} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 26
%     keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 15
%     keyframeIndex = [ 2, 2, 3, 2, 2, 3];
%     keyframePositions = [ 6, 15, 15, 26, 35, 35];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.90, 1.0, 0.90, 0.8, 1.0 ];
%     templateLength = [41];
    % high confusion with other 'walking' classes!

    %Template length: 38
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 5
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 13
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 19
    keyframes{4} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 13
    keyframeIndex = [ 2, 2, 2, 2];
    keyframePositions = [ 5, 13, 19, 33];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.70, 0.7];
    templateLength = [38];

    
    

    case 'walk2StepsRstart'
    %Category: walk2StepsRstart
    %Template length: 39
%     keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 5
%     keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 5
%     keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 25
%     keyframes{4} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 34
%     keyframes{5} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 20
%     keyframeIndex = [ 2, 2, 2, 2, 1  ];
%     keyframePositions = [ 5, 17, 25, 34, 34];
%     keyframeDistances = diff(keyframePositions);
%     stiffness = [ 0.80, 0.7, 0.70, 1.0];
%     templateLength = [39];
    % high confusion with other 'walking' classes!
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 5
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 13
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 19
    keyframes{4} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 13
    keyframeIndex = [ 2, 2, 2, 2];
    keyframePositions = [ 5, 13, 19, 33];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.70, 0.7];
    templateLength = [38];
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    
     case 'walkBackwards2StepsLstart'
    %Category: walkBackwards2StepsLstart
    %Template length: 38
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 7
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 15
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 32
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 7, 15, 32, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [38];


    
 	 case 'walkBackwards2StepsRstart'
    %Category: walkBackwards2StepsRstart
    %Template length: 55
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 18
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 30
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 42
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 18, 30, 42, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [55];



    case 'walk4StepsRstart'
    %Category: walk4StepsRstart
    %Template length: 83
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 10
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 35
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 35
    keyframes{4} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 35
    keyframes{5} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 70
    keyframeIndex = [ 2, 2, 2, 2, 2, ];
    keyframePositions = [ 10, 20, 35, 53, 70, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.8, 0.8, 0.70, ];
    templateLength = [83];

    case 'walkLeft2Steps'

    %Category: walkLeft2Steps
    %Template length: 80
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 35
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; ]; % Index: 1 Position: 60
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 68
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 35, 60, 68, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.90, ];
    templateLength = [80];

    case 'walkLeft2StepsMirrored'

    %Category: walkLeft2Steps
    %Template length: 80
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 35
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; ]; % Index: 1 Position: 60
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 68
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 35, 60, 68, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.90, ];
    templateLength = [80];    
    
    keyframes = mirrorKeyframes(keyframes, keyframeIndex);

    
     case 'walkLeftCircle2StepsLstart'
    %Category: walkLeftCircle2StepsLstart
    %Template length: 32
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 13
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 19
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 23
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 5, 15, 23, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [32];

    case 'walkLeftCircle2StepsRstart'
    %Category: walkLeftCircle2StepsRstart
    %Template length: 33
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 5
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 15
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 15
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 5, 15, 26, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [33];



    
    case 'walkLeftCircle4StepsRstart'
    %Category: walkLeftCircle4StepsRstart
    %Template length: 82
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 23
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 34
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 1 Position: 34

    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5]; % Index: 3 Position: 15

    keyframes{5} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 23
    keyframes{6} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 1 Position: 34
    keyframeIndex = [ 2, 2, 2, 3, 2, 2, ];
    keyframePositions = [ 23, 34, 41, 41, 55, 76 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.60, 1.0, 0.7, 0.8];
    templateLength = [82];


    case 'walkOnPlace2StepsLStart'
    %Category: walkOnPlace2StepsLStart
    %Template length: 39
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 1 Position: 21
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 5
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 5
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 21
    keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 23
    keyframeIndex = [ 2, 3, 3, 2, 3, ];
    keyframePositions = [ 4, 5, 9, 21, 23, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.90, 0.9, 0.90, ];
    templateLength = [39];
    % extrem schlechte Klasse, keine gemeinsamen Einsen

	 case 'walkRightCircle2StepsLstart'
    %Category: walkRightCircle2StepsLstart
    %Template length: 35
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 7
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 12
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 12
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 5, 12, 23 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [35];


	 case 'walkRightCircle2StepsRstart'
    %Category: walkRightCircle2StepsRstart
    %Template length: 34
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 1.0; 0.0; ]; % Index: 2 Position: 21
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 1 Position: 21
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 25
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 5, 15, 25, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [34];

    
    
    case 'walkRightCircle4StepsRstart'
    %Category: walkRightCircle4StepsRstart
    %Template length: 84
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 13
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 24
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 32
    keyframes{4} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 32
    keyframes{5} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 32
    keyframes{6} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 1 Position: 32
    keyframes{7} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 32
    keyframeIndex = [ 2, 2, 2, 2, 2, 2, 2 ];
    keyframePositions = [ 13, 24, 32, 43, 55, 60, 80 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.60, 0.80, 0.5, 0.6, 0.4,0.8];
    templateLength = [84];

 	 case 'walkRightCrossFront2Steps'
    %Category: walkRightCrossFront2Steps
    %Template length: 75
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 35
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 39
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 1.0; 0.0; ]; % Index: 2 Position: 48
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 35, 39, 48, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [75];


    
     case 'walkRightCrossFront2StepsMirrored'
    %Category: walkRightCrossFront2Steps
    %Template length: 75
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 35
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 39
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 1.0; 0.0; ]; % Index: 2 Position: 48
    keyframeIndex = [ 2, 2, 2, ];
    keyframePositions = [ 35, 39, 48, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = [75];

    keyframes = mirrorKeyframes(keyframes, keyframeIndex);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMBINED CLASSES %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
	 case 'walk2StepsLstart_walk2StepsRstart'
    %Category: walk2StepsLstart_walk2StepsRstart
    %Template length: 37
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 13
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 2 Position: 17
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 20
    keyframeIndex = [ 3, 2, 3, ];
    keyframePositions = [ 13, 17, 21, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [37];

	 case 'grabFloorR_grabHighR_grabLowR_grabMiddleR'
%Category: grabFloorR_grabHighR_grabLowR_grabMiddleR
%Template length: 68
keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 6
keyframes{2} = [ 1.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 1.0; 0.5; ]; % Index: 1 Position: 14
keyframes{3} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; ]; % Index: 2 Position: 52
keyframeIndex = [ 3, 1, 2, ];
keyframePositions = [ 6, 14, 52, ];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.80, 0.80, ];
templateLength = [68];

	 case 'hopBothLegs1hops_jumpDown'
%Category: hopBothLegs1hops_jumpDown
%Template length: 34
keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 11
keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 13
keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 18
keyframeIndex = [ 3, 2, 2, ];
keyframePositions = [ 11, 13, 18, ];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.80, 0.80, ];
templateLength = [34];



	 case 'jogLeftCircle4StepsRstart_jogRightCircle4StepsRstart'
%Category: jogLeftCircle4StepsRstart_jogRightCircle4StepsRstart
%Template length: 59
keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 20
keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 29
keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 40
keyframes{4} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 53
keyframeIndex = [ 2, 2, 2, 2 ];
keyframePositions = [ 20, 29, 40, 53, ];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.80, 0.80, 0.8 ];
templateLength = [59];

	 case 'walk4StepsRstart_walkLeftCircle4StepsRstart_walkRightCircle4StepsRstart'
%Category: walk4StepsRstart_walkLeftCircle4StepsRstart_walkRightCircle4StepsRstart
%Template length: 84
keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 2 Position: 35
keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 35
keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 35
keyframes{4} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 72
keyframeIndex = [ 2, 2, 2, 2, ];
keyframePositions = [ 14, 35, 55, 72, ];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.80, 0.70, 0.8];
templateLength = [84];

	 case 'shuffle2StepsLStart_sneak2StepsLStart_walk2StepsLstart'
%Category: shuffle2StepsLStart_sneak2StepsLStart_walk2StepsLstart
%Template length: 49
keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 5
keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 2 Position: 15
keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 2 Position: 35
keyframes{4} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 43
keyframeIndex = [ 2, 2, 2, 2, ];
keyframePositions = [ 5, 15, 35, 43, ];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.70, 0.60, 0.5 ];
templateLength = [49];

	 case 'shuffle2StepsRStart_sneak2StepsRStart_walk2StepsRstart'
%Category: shuffle2StepsRStart_sneak2StepsRStart_walk2StepsRstart
%Template length: 49
keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 2 Position: 12
keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 23
keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 31
keyframes{4} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 2 Position: 31
keyframeIndex = [ 2, 2, 2, 2 ];
keyframePositions = [ 12, 23, 31, 41];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.90, 0.50, 0.5];
templateLength = [49];

	 case 'kickLFront1Reps_kickLSide1Reps'
%Category: kickLFront1Reps_kickLSide1Reps
%Template length: 55
keyframes{1} = [ 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; 0.5; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 16
keyframes{2} = [ 0.5; 0.5; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 0.5; 0.5; 0.5; 1.0; ]; % Index: 2 Position: 20
keyframes{3} = [ 0.5; 0.5; 0.0; 1.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 2 Position: 23
keyframes{4} = [ 0.5; 0.5; 0.0; 1.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 2 Position: 23
keyframeIndex = [ 2, 2, 2, 2];
keyframePositions = [ 16, 20, 23, 28];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.80, 0.80, 0.8 ];
templateLength = [55];


	 case 'kickRFront1Reps_kickRSide1Reps'
%Category: kickLFront1Reps_kickLSide1Reps
%Template length: 55
% this is a mirroed version of the keyframes for the class
% kickLFront1Reps_kickLSide1Reps!
keyframes{1} = [ 0.5; 0 ;  0.5;  0;  0;  1;  0;  0.5;  0.5;  0.5;  1;  0; ]; % Index: 2 Position: 16
keyframes{2} = [ 0.5 ; 0.5;  1;  0 ; 0.5 ; 1 ; 0;  0 ; 0.5 ; 0.5;  1;  0.5 ]; % Index: 2 Position: 20
keyframes{3} = [0.5;  0.5;  1;  0;  0.5 ; 0.5 ; 0;  0;  0 ; 0.5;  1;  0 ]; % Index: 2 Position: 23
keyframes{4} = [0.5;  0.5;  1 ; 0;  0.5 ; 0.5;  0;  0;  0.5;  0;  1 ; 0 ]; % Index: 2 Position: 23
keyframeIndex = [ 2, 2, 2, 2];
keyframePositions = [ 16, 20, 23, 28];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.80, 0.80, 0.8 ];
templateLength = [55];

	 case 'punchLFront1Reps_punchLSide1Reps'
%Category: punchLFront1Reps_punchLSide1Reps
%Template length: 46
keyframes{1} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.5; 0.5; 1.0; 0.0; 0.5; 0.5; 1.0; 0.5; 1.0; ]; % Index: 1 Position: 20
keyframes{2} = [ 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 0.0; 1.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 1 Position: 31
keyframes{3} = [ 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.5; 0.0; 0.5; 1.0; ]; % Index: 1 Position: 38
keyframeIndex = [ 1, 1, 1, ];
keyframePositions = [ 20, 31, 38, ];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.50, 0.60, ];
templateLength = [46];

	 case 'punchRFront1Reps_punchRSide1Reps'
%Category: punchRFront1Reps_punchRSide1Reps
%Template length: 48
keyframes{1} =  [ 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 1 Position: 12
keyframes{2} = [ 0.5; 0.5; 0.5; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.5; 0.5; 1.0; 0.5; ]; % Index: 1 Position: 20
keyframes{3} = [ 0.5; 0.5; 0.5; 0.5; 1.0; 0.0; 0.5; 0.5; 0.0; 0.5; 1.0; 0.5; 1.0; 0.5; ]; % Index: 1 Position: 20
keyframes{4} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 1.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.5; 0.5; ]; % Index: 1 Position: 20
keyframeIndex = [ 1, 1, 1, 1 ];
keyframePositions = [ 15, 20, 22, 40];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.80, 0.80, 0.8];
templateLength = [48];

	 case 'rotateArmsBothBackward1Reps_rotateArmsBothForward1Reps'
%Category: rotateArmsBothBackward1Reps_rotateArmsBothForward1Reps
%Template length: 29
keyframes{1} = [ 0.5; 0.5; 0.5; 0.5; 1.0; 1.0; 0.0; 0.0; 0.5; 0.5; 1.0; 1.0; 1.0; 1.0; ]; % Index: 1 Position: 5
keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 2 Position: 7
keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 1.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 12
keyframes{4} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5;]; % Index: 3 Position: 7
keyframes{5} = [ 0.5; 0.5; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 18
keyframeIndex = [ 1, 2, 1, 3, 1, ];
keyframePositions = [ 7, 7, 12, 12 18, ];
keyframeDistances = diff(keyframePositions);
stiffness = [ 1.0, 0.60, 1.0, 0.80, ];
templateLength = [29];



	 case 'standUpLieFloor_standUpSitChair_standUpSitFloor'
%Category: standUpLieFloor_standUpSitChair_standUpSitFloor
%Template length: 99
keyframes{1} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 59
keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 3 Position: 81
keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 82
keyframeIndex = [ 2, 3, 1, ];
keyframePositions = [ 59, 81, 82, ];
keyframeDistances = diff(keyframePositions);
stiffness = [ 0.70, 0.90, ];
templateLength = [99];



    otherwise
        error('Manual keyframes for this class aren''t defined yet.');
        
end

checkKeyframes(keyframeFeatureSet, keyframes, keyframeIndex, keyframePositions, stiffness);
end

function keyframes = mirrorKeyframes(keyframes, keyframeIndex)
    perm = cell(1,3);
    perm{1} = [2 1 4 3 6 5 8 7 9 10 12 11 14 13];
    perm{2} = [2 1 4 3 5 7 6 8 9 10 12 11];
    perm{3} = [2 1 4 3 5 6 8 7 10 9 11 12 13 14];
    
    for k=1:length(keyframes)
        keyframes{k} = keyframes{k}(perm{keyframeIndex(k)});
        
    end
    
    
end