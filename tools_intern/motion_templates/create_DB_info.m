global VARS_GLOBAL;

subDir=VARS_GLOBAL.DB;

 motionTemplateBatchInfo_cut_amc = forAllDirsInDirRelPaths(fullfile(VARS_GLOBAL.dir_root, subDir, ''),@getCategoryFileIndices,true,[],0.5,true);
 motionTemplateBatchInfo_cut_amc = motionTemplateBatchInfo_cut_amc(2:end);

% motionTemplateBatchInfo_cut_amc = forAllDirsInDirRelPaths(fullfile(VARS_GLOBAL.dir_root, 'HDM05_cut_amc', ''),@getCategoryFileIndices,true,[],0.5,true);
% motionTemplateBatchInfo_cut_amc = motionTemplateBatchInfo_cut_amc(2:end);
% motionTemplateBatchInfo_cut_c3d = forAllDirsInDirRelPaths(fullfile(VARS_GLOBAL.dir_root, 'HDM05_cut_c3d', ''),@getCategoryFileIndices,true,[],0.5,true);
% motionTemplateBatchInfo_cut_c3d = motionTemplateBatchInfo_cut_c3d(2:end);

% idx = [1 6 8 9 10 11 12 16 17 18 19 20 21 24 27 30 38 41 42 44 48 46 50 52 53 57 55 59 61 63 65 67 69 71 ...
%        78 79 82 83 84 85 86 92 95 96 97 98 99 100 101 102 103 104 105 106 107 108 112 114 130 118 126];
% motionTemplateBatchInfo_cut_amc_dipl = motionTemplateBatchInfo_cut_amc(idx);
% motionTemplateBatchInfo_cut_c3d_dipl = motionTemplateBatchInfo_cut_c3d(idx);
% motionTemplateBatchInfo_cut_amc_dipl = forAllDirsInDirRelPaths(fullfile(VARS_GLOBAL.dir_root, 'HDM05_cut_amc_dipl', ''),@getCategoryFileIndices,true,[],0.5,true);
% motionTemplateBatchInfo_cut_amc_dipl = motionTemplateBatchInfo_cut_amc_dipl(2:end);
% motionTemplateBatchInfo_cut_c3d_dipl = forAllDirsInDirRelPaths(fullfile(VARS_GLOBAL.dir_root, 'HDM05_cut_c3d_dipl', ''),@getCategoryFileIndices,true,[],0.5,true);
% motionTemplateBatchInfo_cut_c3d_dipl = motionTemplateBatchInfo_cut_c3d_dipl(2:end);

%  save motionTemplateBatchInfo_50 motionTemplateBatchInfo
%load motionTemplateBatchInfo_50

DB_info = struct('DB_name','','DB_path','','features_path','','DB_concat_path','','index_path','','category',{},'files',{});


DB_info(1).DB_name          = subDir;
DB_info(1).DB_path          = fullfile(subDir,'');
DB_info(1).features_path    = fullfile(subDir,'_features','');
DB_info(1).DB_concat_path   = fullfile(subDir,'_DB_concat','');
DB_info(1).index_path       = fullfile(subDir,'_indexes','');
if VARS_GLOBAL.unCut
    DB_info(1).category         = {'HDM_uncut'};
else
    DB_info(1).category         = {};
end
DB_info(1).files            = {};


% DB_info(1).DB_name = 'MediumDB';
% DB_info(1).DB_path = fullfile('cut_amc','');
% DB_info(1).features_path = fullfile('cut_amc','_features','');
% DB_info(1).DB_concat_path = fullfile('cut_amc','_DB_concat','');
% DB_info(1).index_path = fullfile('cut_amc','_indexes','');
% DB_info(1).category = {};
% DB_info(1).files = {motionTemplateBatchInfo_cut_amc.unused};

% DB_info(2).DB_name = 'Small_take';
% DB_info(2).DB_path = fullfile('take_amc','');
% DB_info(2).features_path = fullfile('take_amc','_features','');
% DB_info(2).DB_concat_path = fullfile('take_amc','_DB_concat','');
% DB_info(2).index_path = fullfile('take_amc','_indexes','');
% DB_info(2).category = {'HDM_uncut'};
% DB_info(2).files = {};


% DB_info(1).DB_name = 'HDM05_cut_amc';
% DB_info(1).DB_path = fullfile('HDM05_cut_amc','');
% DB_info(1).features_path = fullfile('HDM05_cut_amc','_features','');
% DB_info(1).DB_concat_path = fullfile('HDM05_cut_amc','_DB_concat','');
% DB_info(1).index_path = fullfile('HDM05_cut_amc','_indexes','');
% DB_info(1).category = {};
% DB_info(1).files = {motionTemplateBatchInfo_cut_amc.unused};
% 
% DB_info(2).DB_name = 'HDM05_cut_c3d';
% DB_info(2).DB_path = fullfile('HDM05_cut_c3d','');
% DB_info(2).features_path = fullfile('HDM05_cut_c3d','_features','');
% DB_info(2).DB_concat_path = fullfile('HDM05_cut_c3d','_DB_concat','');
% DB_info(2).index_path = fullfile('HDM05_cut_c3d','_indexes','');
% DB_info(2).category = {};
% DB_info(2).files = {motionTemplateBatchInfo_cut_c3d.unused};
% 
% DB_info(3).DB_name = 'HDM05_amc';
% DB_info(3).DB_path = fullfile('HDM05_amc','');
% DB_info(3).features_path = fullfile('HDM05_amc','_features','');
% DB_info(3).DB_concat_path = fullfile('HDM05_amc','_DB_concat','');
% DB_info(3).index_path = fullfile('HDM05_amc','_indexes','');
% DB_info(3).category = {'HDM_uncut'};
% DB_info(3).files = {};
% 
% DB_info(4).DB_name = 'HDM05_c3d';
% DB_info(4).DB_path = fullfile('HDM05_c3d','');
% DB_info(4).features_path = fullfile('HDM05_c3d','_features','');
% DB_info(4).DB_concat_path = fullfile('HDM05_c3d','_DB_concat','');
% DB_info(4).index_path = fullfile('HDM05_c3d','_indexes','');
% DB_info(4).category = {'HDM_uncut'};
% DB_info(4).files = {};

% DB_info(6) = DB_info(1);
% DB_info(6).DB_name = 'HDM05_cut_amc_all';
% DB_info(6).features_path = fullfile('HDM05_cut_amc_all','_features','');
% DB_info(6).DB_concat_path = fullfile('HDM05_cut_amc_all','_DB_concat','');
% DB_info(6).index_path = fullfile('HDM05_cut_amc_all','_indexes','');
% DB_info(6).files = {};
% 
% DB_info(7) = DB_info(2);
% DB_info(7).DB_name = 'HDM05_cut_c3d_all';
% DB_info(7).features_path = fullfile('HDM05_cut_c3d_all','_features','');
% DB_info(7).DB_concat_path = fullfile('HDM05_cut_c3d_all','_DB_concat','');
% DB_info(7).index_path = fullfile('HDM05_cut_c3d_all','_indexes','');
% DB_info(7).files = {};
% 
% DB_info(8).DB_name = 'TestDB_c3d';
% DB_info(8).DB_path = fullfile('TestDB_c3d','');
% DB_info(8).features_path = fullfile('TestDB_c3d','_features','');
% DB_info(8).DB_concat_path = fullfile('TestDB_c3d','_DB_concat','');
% DB_info(8).index_path = fullfile('TestDB_c3d','_indexes','');
% DB_info(8).category = {};
% DB_info(8).files = {};
% 
% DB_info(9).DB_name = 'TestDB_amc';
% DB_info(9).DB_path = fullfile('TestDB_amc','');
% DB_info(9).features_path = fullfile('TestDB_amc','_features','');
% DB_info(9).DB_concat_path = fullfile('TestDB_amc','_DB_concat','');
% DB_info(9).index_path = fullfile('TestDB_amc','_indexes','');
% DB_info(9).category = {};
% DB_info(9).files = {};
% 
% DB_info(10).DB_name = 'HDM05_cut_amc_dipl';
% DB_info(10).DB_path = fullfile('HDM05_cut_amc_dipl','');
% DB_info(10).features_path = fullfile('HDM05_cut_amc_dipl','_features','');
% DB_info(10).DB_concat_path = fullfile('HDM05_cut_amc_dipl','_DB_concat','');
% DB_info(10).index_path = fullfile('HDM05_cut_amc_dipl','_indexes','');
% DB_info(10).category = {};
% DB_info(10).files = {motionTemplateBatchInfo_cut_amc_dipl.unused};
% 
% DB_info(11).DB_name = 'HDM05_cut_c3d_dipl';
% DB_info(11).DB_path = fullfile('HDM05_cut_c3d_dipl','');
% DB_info(11).features_path = fullfile('HDM05_cut_c3d_dipl','_features','');
% DB_info(11).DB_concat_path = fullfile('HDM05_cut_c3d_dipl','_DB_concat','');
% DB_info(11).index_path = fullfile('HDM05_cut_c3d_dipl','_indexes','');
% DB_info(11).category = {};
% DB_info(11).files = {motionTemplateBatchInfo_cut_c3d_dipl.unused};

save DB_info DB_info
