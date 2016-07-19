function  diff = checkBoneLengths( boneLengths, X )

for i=1:length(boneLengths)
    idx1 = boneLengths{i}(1);
    idx2 = boneLengths{i}(2);
    len = boneLengths{i}(3);
    
    len2 = X(3*idx1-2:3*idx1,:) - X(3*idx2-2:3*idx2,:);
    len2 = sqrt(dot(len2,len2));
    
    diff(i) = abs(len2-len);
end