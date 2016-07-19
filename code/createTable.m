function H_createTable
% load('D:\Work\Databases\HumanEva\resHumanEva_orhto_hdm_regfit_2.mat')
load('D:\Work\Databases\HumanEva\resHumanEva_orhto_cmu_regfit_2.mat')
for s = 1:6
    for kn = 1:4
        mn = res{s,1}.er.er3DPose.minMaxMeanK(kn,1);
        sd = res{s,1}.er.er3DPose.minMaxMeanK(kn,2);
        data{kn,s} = [num2str(mn) ' + ' num2str(sd)];
%         data(kn,s) = data{kn,s};
    end
end
cellstr(data{1,1})
t = cell2table(data)


T = table(cell2mat(cellstr(data{1,1})),cell2mat(cellstr(data{1,1})),cell2mat(cellstr(data{1,1})), ...
  cell2mat(cellstr(data{1,1})),cell2mat(cellstr(data{1,1})),cell2mat(cellstr(data{1,1})), ...
    'VariableNames',{'S1_walk' 'S2_walk' 'S3_walk' 'S1_jog' 'S2_jog' 'S3_jog'});


T = table(data{:,1},data{:,2},data{:,3},data{:,4},data{:,5},data{:,6}, ...
    'VariableNames',{'S1_walk' 'S2_walk' 'S3_walk' 'S1_jog' 'S2_jog' 'S3_jog'});

T = table(res{1,1}.er.er3DPose.minMaxMeanK,res{2,1}.er.er3DPose.minMaxMeanK,res{3,1}.er.er3DPose.minMaxMeanK, ...
    res{4,1}.er.er3DPose.minMaxMeanK,res{5,1}.er.er3DPose.minMaxMeanK,res{6,1}.er.er3DPose.minMaxMeanK, ...
    'VariableNames',{'S1_walk' 'S2_walk' 'S3_walk' 'S1_jog' 'S2_jog' 'S3_jog'});

for s = 1:6
   T(2:end,s) 
end
end