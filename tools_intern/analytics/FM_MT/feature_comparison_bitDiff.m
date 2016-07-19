function [difference, diffPerFeature] = feature_comparison_bitDiff(file1, file2, showResults)

if nargin < 4
    showResults = false;
end

if nargin < 1   % demo mode ;)
    file1 = 'D:\Uni\HDM05\HDM05_cut_c3d\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_004_120.C3D';
    file2 = 'D:\Uni\HDM05\HDM05_cut_amc\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_004_120.AMC';
    showResults = true;
end

constBoneLengths = true;

load('features_spec');
range = [70:83 58:69 84:96];
fspec = features_spec(range);

[features1,fs,trC3D,tfC3D] = features_extract_single_file(file1, fspec, false, constBoneLengths);
[features2,fs,trAMC,tfAMC] = features_extract_single_file(file2, fspec, false, constBoneLengths);

nFrames1 = length(features1{1});
nFrames2 = length(features2{1});

if nFrames1 ~= nFrames2
    error('Files differ in length!');
end

if showResults
    figure;
    imagesc(cell2mat(features1));
    colormap('gray');
    title(file1,'Interpreter', 'none');
    
    figure;
    imagesc(cell2mat(features2));
    colormap('gray');
    title(file2,'Interpreter', 'none');
end    

diff = cell2mat(features1) - cell2mat(features2);

if showResults
    figure;
    imagesc(diff);
    colormap('gray');
    colorbar;
end

diffPerFeature = sum(abs(diff),2)/size(diff,2);
difference = sum(sum(abs(diff)))/size(diff,1)/size(diff,2);

if showResults
    disp([num2str(100*difference) '% of values are different']);
end