function [difference, diffPerFeature] = feature_comparison_featureCurves( filename1, filename2, constBoneLengths )

scalingFactorAMC2C3D = 2.54;

if nargin < 1   % demo mode ;)
    filename1 = 'C:\Mocap\HDM05\HDM05_cut_c3d_dipl\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_004_120.C3D';
    filename2 = 'C:\Mocap\HDM05\HDM05_cut_amc_dipl\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_004_120.AMC';
    constBoneLengths = true
end

if constBoneLengths
    skelFitMethod = 'ATS';
else
    skelFitMethod = [];
end

fileInfo1 = filename2info(filename1);
fileInfo2 = filename2info(filename2);
sf1 = 1;
sf2 = 1;

if strcmpi(fileInfo1.filetype, 'ASF/AMC')
    [skel1, mot1] = readMocap([fileInfo1.amcpath fileInfo1.asfname], filename1);
    sf1 = scalingFactorAMC2C3D;
elseif strcmpi(fileInfo1.filetype, 'C3D')
    [skel1, mot1] = readMocap(filename1, [], true, skelFitMethod);
else
    error('File format could not be detected.');
end

if strcmpi(fileInfo2.filetype, 'ASF/AMC')
    [skel2, mot2] = readMocap([fileInfo2.amcpath fileInfo2.asfname], filename2);
    sf2 = scalingFactorAMC2C3D;
elseif strcmpi(fileInfo2.filetype, 'C3D')
    [skel2, mot2] = readMocap(filename2, [], true, skelFitMethod);
else
    error('File format could not be detected.');
end

for featureNr=1:39
%     disp(['Feature ' num2str(featureNr)]);
    funName = ['getRealFeature' num2str(featureNr)];
    
    [scale, dataReal1, thresh1a, thresh1b] = feval(funName, mot1);
    [scale, dataReal2, thresh2a, thresh2b] = feval(funName, mot2);
    
    if ~scale
        sf1=1; sf2=1;
    end
    maxYVal = max(max(sf1*dataReal1), max(sf2*dataReal2));
    minYVal = min(min(sf1*dataReal1), min(sf2*dataReal2));
    
    scalingFactor = max( (sf1*thresh1a + sf1*thresh1b + sf2*thresh2a + sf2*thresh2b) / 4, (maxYVal - minYVal));
%     diffPerFeature(featureNr,1) = std(sf1*dataReal1 - sf2*dataReal2) / (maxYVal - minYVal);
    diffPerFeature(featureNr,1) = std(sf1*dataReal1 - sf2*dataReal2) / scalingFactor;
%     diffPerFeature(featureNr,1) = max(abs(sf1*dataReal1 - sf2*dataReal2)) / scalingFactor;
end

difference = mean(diffPerFeature);