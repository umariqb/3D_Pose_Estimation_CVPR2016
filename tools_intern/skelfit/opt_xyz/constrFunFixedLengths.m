function [ c, ce ] = constrFunFixedLengths( x )

global VARS_GLOBAL_SKELFIT
frames = VARS_GLOBAL_SKELFIT.frames;
boneLengths = VARS_GLOBAL_SKELFIT.boneLengths;

c = [];
ce = [];

for i=1:length(boneLengths)
    joint1 = boneLengths{i}(1);    
    joint2 = boneLengths{i}(2);
    len = boneLengths{i}(3);
    
    len2 = x(joint1*3-2:joint1*3) - x(joint2*3-2:joint2*3);
    len2 = sqrt(dot(len2,len2));
    
    ce(i) = len2 - len;
end
