function [ output_args ] = showRealFeatureValues( filename1, filename2, featureNr )

scalingFactorAMC2C3D = 2.54;

if nargin < 1   % demo mode ;)
    filename1 = 'D:\Uni\HDM05\HDM05_cut_c3d\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_004_120.C3D';
    filename2 = 'D:\Uni\HDM05\HDM05_cut_amc\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_004_120.AMC';
    featureNr = 1;
end

fileInfo1 = filename2info(filename1);
fileInfo2 = filename2info(filename2);
sf1 = 1;
sf2 = 1;

if strcmpi(fileInfo1.filetype, 'ASF/AMC')
    [skel1, mot1] = readMocap([fileInfo1.amcpath fileInfo1.asfname], filename1);
    sf1 = scalingFactorAMC2C3D;
elseif strcmpi(fileInfo1.filetype, 'C3D')
    [skel1, mot1] = readMocap(filename1);
else
    error('File format could not be detected.');
end

if strcmpi(fileInfo2.filetype, 'ASF/AMC')
    [skel2, mot2] = readMocapLCS([fileInfo2.amcpath fileInfo2.asfname], filename2);
    sf2 = scalingFactorAMC2C3D;
elseif strcmpi(fileInfo2.filetype, 'C3D')
    [skel2, mot2] = readMocapLCS(filename2, [], true);
else
    error('File format could not be detected.');
end

fig = figure;
set(fig, 'Name', fileInfo1.amcname);
hold on;

funName = ['getRealFeature' num2str(featureNr)];

[scale, dataReal1, thresh1a, thresh1b, dataBool1] = feval(funName, mot1);
[scale, dataReal2, thresh2a, thresh2b, dataBool2] = feval(funName, mot2);

if ~scale
    sf1=1; sf2=1;
end

% [dataBool1, dataReal1, thresh1a, thresh1b] = getRealFeature1(mot1);
% [dataBool2, dataReal2, thresh2a, thresh2b] = getRealFeature1(mot2);

maxYVal = max(max(sf1*dataReal1), max(sf2*dataReal2));
minYVal = min(min(sf1*dataReal1), min(sf2*dataReal2));

plot(sf1 * dataReal1, 'b');
plot(sf2 * dataReal2, 'r');
plot(0.2*((maxYVal-minYVal)*dataBool1)+minYVal*ones(length(dataBool1),1)', 'b');
plot(0.2*((maxYVal-minYVal)*dataBool2)+minYVal*ones(length(dataBool2),1)', 'r');
% plot(0.2*maxYVal*dataBool2, 'r');
plot(sf1 * thresh1a * ones(length(dataReal1),1), 'b:');
plot(sf2 * thresh2a * ones(length(dataReal2),1), 'r--');
plot(sf1 * thresh1b * ones(length(dataReal1),1), 'b:');
plot(sf2 * thresh2b * ones(length(dataReal2),1), 'r--');

% axis tight;
legendText1 = fileInfo1.filetype;
legendText2 = fileInfo2.filetype;

l=legend(upper(strrep(lower(legendText1), 'c3d', 'lcs')), upper(strrep(lower(legendText2), 'c3d', 'lcs')));
%     title({fileInfo1.amcname, fileInfo2.amcname}, 'Interpreter', 'none');
