function [keyframes, keyframePositions, keyframeIndex, keyframeDistances, stiffness, templateLength] = manualKeyframes(categoryName)
%keyframes can be defined for every class.
keyframes = cell(0, 0);
keyframeFeatureSet = {'AK_upper', 'AK_lower', 'AK_mix'}; %the feature sets to which the keyframes belong
%for every class there exists a vector which indicates which keyframe
%belongs to which keyframeFeatureSet.

categoryName = concatStringsInCell(categoryName);

%Category: cartwheelLHandStart1Reps
%Template length: 106

switch (categoryName)
    case 'cartwheelLHandStart1Reps'
    keyframes{1} = [ 1.0; 1.0; 0.5; 1.0; 0.0; 1.0; 0.0; 1.0; 0.5; 0.0; 1.0; 1.0; 1.0; ]; % Index: 3 Position: 44
    keyframes{2} = [ 1.0; 1.0; 0.0; 1.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 3 Position: 57
    keyframes{3} = [ 1.0; 1.0; 0.5; 0.5; 0.0; 0.0; 1.0; 1.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 3 Position: 64
    keyframeIndex = [ 3, 3, 3, ];
    keyframePositions = [ 44, 57, 64, ];
    keyframeDistances =  diff(keyframePositions);
    stiffness = [ 0.70, 0.70, ];
    templateLength = 106;


    case  'clap1Reps'
    %Category: clap1Reps
    %Template length: 11
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 3
    keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; ]; % Index: 1 Position: 3
    keyframes{3} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 4
    keyframes{4} = [ 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 4
    keyframes{5} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 3
    keyframeIndex = [ 3, 2, 1, 1, 3];
    keyframePositions = [ 3, 3, 3, 4, 9];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.0, 0.90, 0.9];
    templateLength = [11];


    case 'clapAboveHead1Reps'
    %Category: clapAboveHead1Reps
    %Template length: 11
    keyframes{1} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 3
    keyframes{2} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 3
    keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 1.0; 0.5; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 4
    keyframes{4} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 9
    keyframes{5} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 11
    keyframeIndex = [ 3, 2, 1, 3, 3];
    keyframePositions = [ 3, 3, 4, 9, 11];
    keyframeDistances =  diff(keyframePositions);
    stiffness = [ 0.80, 0.8, 0.80, 0.8];
    templateLength = [23];

    case 'depositFloorR'
    %Category: depositFloorR
    %Template length: 73
    keyframes{1} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 27
    keyframes{2} = [ 1.0; 0.5; 1.0; 1.0; 1.0; 0.5; 1.0; 0.5; 0.0; 0.5; 1.0; 0.0; 0.5; ]; % Index: 3 Position: 31
    keyframes{3} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 31
    keyframes{4} = [ 1.0; 0.5; 1.0; 1.0; 1.0; 0.5; 1.0; 0.5; 0.0; 0.5; 1.0; 0.0; 0.5; ]; % Index: 3 Position: 36
    keyframes{5} = [ 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5]; % Index: 2 Position: 36
    keyframeIndex = [ 2, 3, 2, 3, 1 ];
    keyframePositions = [ 27, 31, 31, 39, 42 ];
    keyframeDistances =  diff(keyframePositions);
    stiffness = [ 0.50, 0.8, 0.20, 0.5 ];
    templateLength = [73];


    case 'depositHighR'
        %Category: depositHighR
    %Template length: 73
    keyframes{1} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 10
    keyframes{2} = [ 1.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 14
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 30

    keyframes{4} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 30
    keyframes{5} = [ 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 54


    keyframes{6} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 54
    keyframes{7} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 70
    keyframeIndex = [ 3, 1, 3, 2, 1,  1, 3];
    keyframePositions = [ 10, 14, 30, 30, 30, 54, 65 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.7, 0.50, 0.7, 0.7, 0.60 0.5];
    templateLength = [69];

    case 'elbowToKnee1RepsLelbowStart'
    %Category: elbowToKnee1RepsLelbowStart
    %Template length: 38
    keyframes{1} = [ 0.5; 1.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 12
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
    keyframes{2} = [ 1.0; 0.5; 0.5; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 11
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
    keyframes{1} = [ 1.0; 0.5; 1.0; 1.0; 1.0; 0.5; 1.0; 0.5; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 3 Position: 21
    keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 36

    keyframes{3} = [ 1.0; 0.5; 1.0; 1.0; 1.0; 0.5; 1.0; 0.5; 0.0; 0.5; 1.0; 0.0; 1.0; ]; % Index: 3 Position: 36

    keyframes{4} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 36

    keyframes{5} = [ 1.0; 0.5; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.0; 0.5; 1.0; 0.0; 1.0; ]; % Index: 3 Position: 44
    keyframes{6} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 25
    keyframes{7} = [ 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 14


    keyframeIndex = [ 3, 2, 3, 2, 3, 2, 1];
    keyframePositions = [ 21, 21, 36, 36, 44, 44, 44];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.40, 1.0, 0.40, 1.0, 1.0];
    templateLength = [61];

    case 'grabHighR'
    %Category: grabHighR
    %Template length: 69
    idx=17;
    keyframes{1} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5;]; % Index: 1 Position: 5
    keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 33
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 12
    keyframes{4} = [ 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 33
    keyframes{5} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 33
    keyframes{6} = [ 0.0; 0.5; 1.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; ]; % Index: 2 Position: 45
    keyframeIndex = [ 2, 3, 1, 1, 3, 1, ];
    keyframePositions = [ 5, 5, 12, 33, 33, 41, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.4, 0.50,  1.0, 0.50, ];
    templateLength = [69];

    case 'grabLowR'
    %Category: grabLowR
    %Template length: 72
    idx=18;
    keyframes{1} = [ 1.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 20
    keyframes{2} = [ 1.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 22
    keyframes{3} = [ 1.0; 0.5; 1.0; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; ]; % Index: 3 Position: 33
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 51
    keyframeIndex = [ 1, 1, 3, 1, ];
    keyframePositions = [ 20, 22, 35, 51, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.7, 0.70, ];
    templateLength = [72];

    case 'grabMiddleR'
    %Category: grabMiddleR
    %Template length: 56
    idx=19;
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.5; ]; % Index: 2 Position: 22
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 41
    keyframes{3} = [ 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 22
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 41


    % keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 7
    % keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 33
    % keyframes{3} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 41
    keyframeIndex = [ 1, 3, 1, 3];
    keyframePositions = [ 10, 10, 20, 43 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.80, 0.8 ];
    templateLength = [56];

    case 'hopBothLegs1hops'

    %Category: hopBothLegs1hops
    %Template length: 24
    idx=21;
    keyframes{1} = [ 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 24

    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 10
    keyframes{3} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 15
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 17
    keyframes{5} = [ 0.5; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 24
    %keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 24

    keyframeIndex = [ 3, 2, 1, 2, 3];
    keyframePositions = [ 5, 10, 15, 19, 24];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.8, 0.80, 0.50, 0.6];
    templateLength = [24];

    case 'hopLLeg1hops'
    %Category: hopLLeg1hops
    %Template length: 19
    idx=24;
    keyframes{1} = [ 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 1 Position: 6
    keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 7
    keyframes{3} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.5; ]; % Index: 1 Position: 17
    keyframeIndex = [ 2, 1, 2, ];
    keyframePositions = [ 6, 7, 17, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, ];
    templateLength = [19];

    case 'hopRLeg1hops'
    %Category: hopRLeg1hops
    %Template length: 18
    keyframes{1} = [ 0.5; 0.5; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 5
    keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 10
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.5; 1.0; ]; % Index: 1 Position: 13
    keyframes{4} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 5
    keyframeIndex = [ 3, 1, 2, 3];
    keyframePositions = [ 5, 10, 14, 14 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.50, 1.0];
    templateLength = [18];

    case 'jogLeftCircle4StepsRstart'
    %Category: jogLeftCircle4StepsRstart
    %Template length: 63
    idx=30;
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
    idx=38;
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
    idx=41;
    keyframes{1} = [ 1.0; 1.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 16
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 16
    keyframes{3} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 3 Position: 22
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
    idx=42;
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 8
    keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 1.0; 0.0; 0.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 11
    % keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 1.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 15
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 15
    keyframeIndex = [ 1, 1, 1, ];
    keyframePositions = [ 8, 11, 25, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.50, ];
    templateLength = [35];
    
    case 'kickLFront1Reps'
    %Category: kickLFront1Reps
    %Template length: 55
    idx=44;
    keyframes{1} = [ 0.5; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 10
    keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 10

    keyframes{3} = [ 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 0.5; 0.5; 0.5; 1.0; ]; % Index: 1 Position: 18
    keyframes{4} = [ 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 1.0; ]; % Index: 1 Position: 20
    keyframes{5} = [ 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 25
    keyframeIndex = [ 3, 2, 2, 2, 2, ];
    keyframePositions = [ 10, 10, 20, 22, 27, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.6, 0.80, 0.80, ];
    templateLength = [55];
    
    case 'kickLSide1Reps'

    %Category: kickLSide1Reps 
    %Template length: 55
    idx=46;
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 1.0; ]; % Index: 1 Position: 19
    keyframes{2} = [ 0.5; 0.5; 0.0; 1.0; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; 0.5; 1.0; ]; % Index: 1 Position: 22
    keyframes{3} = [ 0.5; 0.5; 0.0; 1.0; 1.0; 0.0; 0.5; 0.0; 1.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 29
    keyframes{4} = [ 1.0; 0.5; 0.5; 1.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 1.0; 0.5; ]; % Index: 3 Position: 29
    keyframeIndex = [ 2, 2, 2, 3];
    keyframePositions = [ 19, 22, 29, 29];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.80, 1.0 ];
    templateLength = [55];
    % Hinweis: Durch den 4. Keyframe werden 3 Sidekick-Bewegungen
    % herausgefiltert (3 von Meinard). Diese stellen sich bei der Durchsicht
    % allerdings als front-kicks heraus.

    case 'kickRFront1Reps'

    %Category: kickRFront1Reps
    %Template length: 53
    idx=48;
    keyframes{1} = [ 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 1 Position: 19
    keyframes{2} = [ 0.0; 0.5; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 1 Position: 22
    keyframes{3} = [ 0.5; 0.5; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 22


    keyframes{4} = [ 0.0; 0.5; 1.0; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 32
    keyframes{5} = [ 0.5; 0.5; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 29
    keyframeIndex = [ 2, 2, 3, 2, 3];
    keyframePositions = [ 19, 22, 26, 32, 32];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.6, 0.7, 1.0 ];
    templateLength = [53];


    case 'kickRSide1Reps'
    %Category: kickRSide1Reps
    %Template length: 51
    idx=50;
    keyframes{1} = [ 0.5; 0.0; 0.5; 0.0; 0.5; 1.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; ]; % Index: 1 Position: 18
    keyframes{2} = [ 0.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 18

    keyframes{3} = [ 0.5; 0.5; 1.0; 0.0; 0.5; 1.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 31
    keyframes{4} = [ 0.5; 0.0; 0.5; 0.0; 0.5; 1.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 33
    keyframeIndex = [ 2, 3, 2, 2, ];
    keyframePositions = [ 18, 18, 31, 33, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.80, 0.80, ];
    templateLength = [51];

% Bemerkung: KickSide1Reps_009 ist extrem kurz und enthält kaum Daten.

    case 'lieDownFloor'
    %Category: lieDownFloor
    %Template length: 170
    keyframes{1} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 1.0; ]; % Index: 3 Position: 31
    keyframes{2} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; ]; % Index: 3 Position: 75
    keyframes{3} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 0.0; ]; % Index: 3 Position: 132
    keyframeIndex = [ 3, 3, 3, ];
    keyframePositions = [ 31, 70, 112, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.50, ];
    templateLength = [170];
    %perfekt match!

    case 'punchLFront1Reps'
    %Category: punchLFront1Reps
    %Template length: 49
    keyframes{1} = [ 0.5; 1.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; 0.0; 0.5; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 20
    keyframes{2} = [ 0.5; 1.0; 0.0; 0.5; 0.0; 1.0; 0.5; 0.5; 0.0; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 24
    keyframes{3} = [ 0.0; 1.0; 0.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.5; 0.5; 0.5; 0.5; 1.0; ]; % Index: 2 Position: 26
    keyframes{4} = [ 0.5; 1.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 132
    keyframes{5} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 26

    keyframeIndex = [ 1, 1, 1, 3, 1];
    keyframePositions = [ 20, 24, 26, 30, 40];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.80, 0.5, 0.6];
    templateLength = [49];
    %Sehr schwierige Klasse: Extrem unterschiedlich im lower-Bereich.
    
    case 'punchLSide1Reps'

    %Category: punchLSide1Reps
    %Template length: 42
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.5; 0.5; 1.0; 0.0; 0.5; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 19
    keyframes{2} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 23

    keyframes{3} = [ 0.5; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; ]; % Index: 3 Position: 23
    keyframes{4} = [ 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 0.0; 1.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 29
    keyframes{5} = [ 0.5; 1.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 1.0; 0.5; ]; % Index: 3 Position: 23
    keyframes{6} = [ 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 1.0; 0.0; 0.5; 0.5; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 29
    keyframeIndex = [ 1, 3, 3, 1, 3, 1 ];
    keyframePositions = [ 19, 19, 25, 29, 29, 37];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.50, 0.30, 1.0, 0.5];
    templateLength = [42];
    %extrem schwierige Klasse
    

    case 'punchRFront1Reps'
    %Category: punchRFront1Reps
    %Template length: 55
    keyframes{1} = [ 1.0; 0.5; 0.5; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.5; 0.5; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 25
    keyframes{2} = [ 1.0; 0.5; 0.5; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.5; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 27
    keyframes{3} = [ 1.0; 0.5; 0.5; 0.0; 1.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 27
    keyframes{4} = [ 1.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 23

    keyframes{5} = [ 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 1.0; 0.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 36
    keyframes{6} = [ 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; ]; % Index: 3 Position: 23
    keyframeIndex = [ 1, 1, 1, 3, 1, 3];
    keyframePositions = [ 24, 27, 30, 30, 36, 36];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.6, 1.0, 0.50, 1.0];
    templateLength = [55];
    

    case 'punchRSide1Reps'

    %Category: punchRSide1Reps
    %Template length: 42
    keyframes{1} = [ 0.5; 0.0; 0.5; 0.5; 1.0; 0.0; 1.0; 0.5; 0.0; 0.0; 1.0; 0.5; 1.0; 0.5; ]; % Index: 2 Position: 15
    keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; ]; % Index: 1 Position: 31
    keyframes{3} = [ 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 17
    keyframes{4} = [ 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; ]; % Index: 3 Position: 24
    keyframes{5} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 24
    keyframes{6} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 0.5; 1.0; 0.5; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 15
    keyframeIndex = [ 1, 2, 3, 3, 3, 1];
    keyframePositions = [ 15, 15, 17, 21, 30, 30];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.50, 0.50, 0.5, 1.0];
    templateLength = [42];
    %extrem schwierige Klasse.
    %Eventuell ist es sinnvoll, die Anfrage in mehrere Anfragen zu splitten.

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
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 1 Position: 31
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 12
    keyframes{4} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; ]; % Index: 3 Position: 24

    keyframes{5} = [ 1.0; 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; ]; % Index: 2 Position: 12

    keyframes{6} = [ 1.0; 1.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 19
    keyframeIndex = [ 1, 2, 1, 3, 1, 1, ];
    keyframePositions = [ 5, 6, 12, 12, 15, 19, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.5, 0.50, 1.0, 0.6, 0.50, ];
    templateLength = [31];

    case 'rotateArmsLBackward1Reps'
    %Category: rotateArmsLBackward1Reps
    %Template length: 30
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 4
    keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 31
    keyframes{3} = [ 0.0; 0.0; 0.0; 1.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.5; 1.0; ]; % Index: 2 Position: 10
    keyframes{4} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 27
    keyframeIndex = [ 1, 2, 1, 1, ];
    keyframePositions = [ 4, 4, 10, 27, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.60, 0.40, ];
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

    case 'runOnPlaceStartFloor2StepsRStart'
    %Category: runOnPlaceStartFloor2StepsRStart
    %Template length: 22
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 14
    keyframes{2} = [ 0.5; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 4
    keyframes{3} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.5; 0.0; 1.0; 1.0; ]; % Index: 1 Position: 14
    keyframes{4} = [ 0.5; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.5; 1.0; ]; % Index: 1 Position: 17
    keyframes{5} = [ 0.5; 0.5; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 4

    keyframeIndex = [ 2, 3, 2, 2, 3];
    keyframePositions = [ 4, 4, 14, 17, 17];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.80, 0.80, 1.0];
    templateLength = [22];

    case 'shuffle2StepsRStart'

    %Category: shuffle2StepsRStart
    %Template length: 61
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 1 Position: 14
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 11
    keyframes{3} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 21

    keyframes{4} = [ 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5]; % Index: 3 Position: 11

    keyframes{5} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 40
    keyframes{6} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 11
    keyframes{7} = [ 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0]; % Index: 3 Position: 11
    keyframes{8} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; 0.5; ]; % Index: 2 Position: 11

    keyframeIndex = [ 2, 1, 2, 3, 2, 2, 3, 1 ];
    keyframePositions = [ 14, 14, 21, 32, 40, 49, 49, 49];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.60, 0.80, 0.8, 0.8, 1.0, 1.0];
    templateLength = [61];
    %HDM_dg_shuffle2StepsRStart_005_120.amc.MAT ist eine 4stepsRstart Bewegung!

    case 'sitDownChair'
    %Category: sitDownChair
    %Template length: 84
    idx=82;
    keyframes{1} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5]; % Index: 3 Position: 11
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 34
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 42
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 56
    keyframes{5} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.0]; % Index: 3 Position: 11
    keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 34

    keyframeIndex = [ 3, 2, 2, 2, 3, 2];
    keyframePositions = [ 22, 34, 42, 56, 56, 65];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.9, 1.00, 0.90, 1.0, 0.6];
    templateLength = [84];

    case 'sitDownFloor'

    %Category: sitDownFloor
    %Template length: 106
    keyframes{1} = [ 0.5; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 1.0; ]; % Index: 3 Position: 30
    keyframes{2} = [ 0.5; 0.5; 0.0; 0.0; 0.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 42

    keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; 0.5; 0.0; ]; % Index: 3 Position: 78

    keyframes{4} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.0; 1.0; 0.5; 0.0; 0.0; 1.0; 0.5; 0.0; ]; % Index: 3 Position: 93
    keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 2 Position: 11
    keyframeIndex = [ 3, 2, 3, 3, 1 ];
    keyframePositions = [ 30, 30, 50, 63, 63 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.00, 0.40, 0.4, 1.0];
    templateLength = [106];


    case 'sitDownKneelTieShoes'
    %Category: sitDownKneelTieShoes
    %Template length: 165
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 56
    keyframes{2} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 1.0; 1.0; 0.0; 0.5; 1.0; 0.0; 0.5; ]; % Index: 3 Position: 62
    keyframes{3} = [ 1.0; 1.0; 0.5; 1.0; 0.5; 0.5; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.0; ]; % Index: 3 Position: 85
    keyframeIndex = [ 2, 3, 3, ];
    keyframePositions = [ 56, 62, 85, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.00, 1.00, ];
    templateLength = [165];
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
    idx=86;
    keyframes{1} = [ 0.5; 0.5; 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.5; ]; % Index: 3 Position: 10
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
    idx=88;
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
    keyframes{1} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 1.0; ]; % Index: 3 Position: 15
    keyframes{2} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 0.0; ]; % Index: 3 Position: 25
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.5; 1.0; ]; % Index: 3 Position: 30
    keyframes{4} = [ 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; ]; % Index: 2 Position: 20

    keyframeIndex = [ 3, 3, 3, 1];
    keyframePositions = [ 15, 25, 30, 32];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.70, 0.5];
    templateLength = [47];
    %perfekt match

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

    case 'staircaseUp3Rstart'
    %Category: staircaseUp3Rstart
    %Template length: 78
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 11
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 18
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 18
    keyframes{4} = [ 0.0; 0.0; 0.0; 1.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 30
    keyframes{5} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 1 Position: 41
    keyframeIndex = [ 2, 2, 2, 3, 2, ];
    keyframePositions = [ 11, 18, 30, 32, 35, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.5, 0.5, 0.30, ];
    templateLength = [78];

    case 'standUpLieFloor'
    %Category: standUpLieFloor
    %Template length: 134
    keyframes{1} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 0.0; ]; % Index: 3 Position: 15
    keyframes{2} = [ 0.5; 0.5; 0.5; 0.5; 0.0; 1.0; 1.0; 1.0; 0.0; 0.5; 1.0; 1.0; 0.0; ]; % Index: 3 Position: 33
    keyframes{3} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 1.0; ]; % Index: 3 Position: 110
    keyframeIndex = [ 3, 3, 3, ];
    keyframePositions = [ 20, 33, 100, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.50, 0.70, ];
    templateLength = [134];
    %perfekt match

    case 'standUpSitChair'
    %Category: standUpSitChair
    %Template length: 72
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 9
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 9
    keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 0.5; 0.5; 0.0; 0.0; 1.0; 0.0; 0.5; ]; % Index: 3 Position: 39
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 9
    keyframes{5} = [ 0.0; 0.5; 1.0; 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 58
    keyframeIndex = [ 2, 2, 3, 2, 3];
    keyframePositions = [ 9, 15, 39, 39, 47];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.7, 1.00, 0.5];
    templateLength = [72];

    case 'standUpSitFloor'
    %Category: standUpSitFloor
    %Template length: 96

    keyframes{1} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.0; 1.0; 1.0; 0.5; 0.0; 1.0; 0.5; 0.0; ]; % Index: 3 Position: 18
    keyframes{2} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 65
    keyframes{3} = [ 0.5; 0.5; 1.0; 1.0; 0.5; 0.0; 1.0; 1.0; 0.5; 0.0; 1.0; 0.5; 0.0; ]; % Index: 3 Position: 18

    keyframes{4} = [ 0.5; 0.5; 1.0; 1.0; 1.0; 0.0; 1.0; 1.0; 0.5; 0.0; 1.0; 0.5; 0.5; ]; % Index: 3 Position: 40
    keyframes{5} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 65

    keyframes{6} = [ 1.0; 1.0; 1.0; 1.0; 0.5; 0.5; 0.5; 0.5; 0.0; 0.0; 1.0; 0.5; 0.5; ]; % Index: 3 Position: 70

    keyframeIndex = [ 3, 2, 3, 3, 2, 3, ];
    keyframePositions = [ 18, 18, 30,40, 55, 60, ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 0.7, 0.30, 0.5, 0.50, ];
    templateLength = [96];


    case 'standUpSitTable'
    %Category: standUpSitTable
    %Template length: 60
    idx=100;
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
    idx=101;
    keyframes{1} = [ 0.5; 0.5; 0.0; 0.5; 1.0; 1.0; 0.5; 0.5; 0.0; 0.5; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 18
    keyframes{2} = [ 0.5; 0.0; 0.5; 0.5; 1.0; 1.0; 0.5; 0.5; 0.0; 0.0; 1.0; 1.0; 1.0; 1.0; ]; % Index: 2 Position: 22
    keyframes{3} = [ 1.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 27
    keyframes{4} = [ 0.5; 0.5; 1.0; 1.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 22
    keyframes{5} = [ 1.0; 1.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 27
    keyframeIndex = [ 1, 1, 3, 1, 3];
    keyframePositions = [ 18, 22, 27, 40, 40];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.00, 0.50, 0.6, 1.0];
    templateLength = [95];

    case 'turnLeft'
    %Category: turnLeft
    %Template length: 48
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 20
    keyframes{2} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 29
    keyframes{3} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.5; 0.0; ]; % Index: 1 Position: 65

    keyframes{4} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 20

    keyframes{5} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 29
    keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 44
    keyframes{7} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 1 Position: 65
    keyframeIndex = [ 1, 3, 2, 1, 3, 3, 2];
    keyframePositions = [ 20, 20, 20, 24, 29, 44, 44];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.0, 0.7, 0.80, 0.80, 1.0 ];
    templateLength = [48];

    case 'turnRight'
    %Category: turnRight
    %Template length: 49
    keyframes{1} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; 0.0; 0.5; ]; % Index: 1 Position: 43
    keyframes{2} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 20
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 22

    keyframes{4} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; ]; % Index: 1 Position: 43
    keyframes{5} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.5; ]; % Index: 2 Position: 20
    keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 22

    keyframes{7} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 22

    keyframes{8} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; ]; % Index: 1 Position: 43
    keyframes{9} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 3 Position: 22

    keyframeIndex =     [ 2, 1, 3, 2,   1,  3, 3, 2, 3];
    keyframePositions = [ 8, 8, 8, 22, 22, 22, 30, 43, 43 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 1.0, 1.0, 0.8, 1.00, 1.00, 0.8, 0.8, 1.0 ];
    templateLength = [49];
    % dg_turnRight_022 ist eine TurnLeft - Bewegung!!
    % Klasse extrem schlecht, keine gemeinsamen einsen!

    case 'walk2StepsLstart'
    %Category: walk2StepsLstart
    %Template length: 41
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 6
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 15
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 15
    keyframes{4} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 26
    keyframes{5} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 26
    keyframes{6} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 15
    keyframeIndex = [ 2, 2, 3, 2, 2, 3];
    keyframePositions = [ 6, 15, 15, 26, 35, 35];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.90, 1.0, 0.90, 0.8, 1.0 ];
    templateLength = [41];
    % high confusion with other 'walking' classes!

    case 'walk2StepsRstart'
    %Category: walk2StepsRstart
    %Template length: 39
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 5
    keyframes{2} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 5
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 25
    keyframes{4} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 34
    keyframes{5} = [ 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 0.0; 0.0; 0.5; 1.0; ]; % Index: 2 Position: 20
    keyframeIndex = [ 2, 2, 2, 2, 1  ];
    keyframePositions = [ 5, 17, 25, 34, 34];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.80, 0.7, 0.70, 1.0];
    templateLength = [39];
    % high confusion with other 'walking' classes!

    case 'walkBackwards2StepsRstart'
    %Category: walkBackwards2StepsRstart
    %Template length: 56
    keyframes{1} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.0; 1.0; 0.0; ]; % Index: 1 Position: 18
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 30
    keyframes{3} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 15
    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 37
    keyframes{5} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; ]; % Index: 1 Position: 37
    keyframeIndex = [ 2, 2, 3, 2, 2, ];
    keyframePositions = [ 18, 30, 30, 37, 44 ];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.90, 1.0, 0.90, 0.8 ];
    templateLength = [56];
    %perfekt match

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

    case 'walkLeftCircle4StepsRstart'
    %Category: walkLeftCircle4StepsRstart
    %Template length: 82
    keyframes{1} = [ 0.0; 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 23
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 34
    keyframes{3} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 0.5; 1.0; 0.0; ]; % Index: 1 Position: 34

    keyframes{4} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; ]; % Index: 3 Position: 15

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
    %Template length: 83
    keyframes{1} = [ 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.5; ]; % Index: 3 Position: 10
    keyframes{2} = [ 1.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0; 1.0; ]; % Index: 1 Position: 44
    keyframes{3} = [ 0.5; 0.0; 0.0; 0.0; 0.0; 0.5; 0.0; 0.0; 0.0; 1.0; 1.0; 0.0; ]; % Index: 1 Position: 57
    keyframeIndex = [ 3, 2, 2];
    keyframePositions = [ 14, 44, 57];
    keyframeDistances = diff(keyframePositions);
    stiffness = [ 0.70, 0.80];
    templateLength = [83];
    

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