function [ output_args ] = precision_recall_allClasses2( info, m, n, recompute, tau1, tau2)

if nargin < 1
    load HDM_Training_DB_info;
end
    
if nargin < 4
%     recompute = true;
    recompute = false;
end

if nargin < 5
    tau1 = 0.02;
    tau2 = 1;
end

load all_motion_classes;
% motion_classes = {'grabLowR', 'sitDownTable'};

resultsAMC = [];
resultsC3D = [];

if recompute
    load retrieval_results_HDM05_cut_amc_HDM05_cut_amc_100
    resultsAMC = results;
    
    load retrieval_results_HDM05_cut_c3d_HDM05_cut_c3d_100
    resultsC3D = results;
    clear results;
end


if nargin < 2
    precision_recall_diagram2(DB_info, motion_classes, resultsC3D, resultsAMC, recompute);
else
    precision_recall_diagram2(DB_info, motion_classes, resultsC3D, resultsAMC, recompute, m, n, tau1, tau2);
end    