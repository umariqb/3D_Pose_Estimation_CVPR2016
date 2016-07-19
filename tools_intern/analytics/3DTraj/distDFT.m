function diff = distDFT( mot1, mot2 )

joints = getAllJointNames;

len = min(mot1.nframes, mot2.nframes);
halfLen = floor(len/2);

for i=1:length(joints)
    fft1 = abs(fft(mot1.jointTrajectories{trajectoryID(mot1, joints{i})}(:,1:len), [], 2));
    fft2 = abs(fft(mot2.jointTrajectories{trajectoryID(mot2, joints{i})}(:,1:len), [], 2));

    alpha1 = 2.0;
    alpha2 = 0.2;
    weightVector = [alpha1:(alpha2-alpha1)/(halfLen-1):alpha2];
    
    weightedDiff = abs(sum(fft1(:,1:halfLen)-fft2(:,1:halfLen))) .* weightVector;
    diff(i,:) = sum(weightedDiff);
%     diff(i,:) = sum(sum(abs((fft1-fft2))));
end

% figure;
% plot(diff(1,:));