test = false;

load features_spec;
%load fspec_BK_kinEnergy.mat;
%%%%%%% AK lower
range = [58:69];
fspec_AK_lower = features_spec(range);

%%%%%%% AK upper
range = [70:83];
fspec_AK_upper = features_spec(range);

%%%%%%% AK mix
range = [84:96];
fspec_AK_mix = features_spec(range);


fspec_AK_mix_avr = fspec_AK_mix;
fspec_AK_mix_avr(14) = fspec_AK_mix(13);
fspec_AK_mix_avr(14).name = 'feature_bool_rootHighAngVel_robust';

fspec = cell(3,2);
fspec{1,1} = fspec_AK_lower;          fspec{1,2} = 'AK_lower';
fspec{2,1} = fspec_AK_upper;          fspec{2,2} = 'AK_upper';
fspec{3,1} = fspec_AK_mix;            fspec{3,2} = 'AK_mix';
fspec{4,1} = fspec_AK_mix_avr;        fspec{4,2} = 'AK_mix_avr'; 


% range=[1:11];
% fspec_BK_kinEnergy=features_spec(range);
% fspec = cell(1,2);
% fspec{1,1} = fspec_BK_kinEnergy;          fspec{1,2} = 'BK_kinEnergy';

% write_features_txt(fspec_BD_upper,'07_fspec_BD_upper.txt');

global VARS_GLOBAL;

% dirName = 'HDM05_cut_c3d';
% dirName = 'HDM05_cut_amc';
% dirName = 'HDM05_amc';
%dirName = 'cut_amc';

dirName = VARS_GLOBAL.DB;

oldPath = cd;

cd(VARS_GLOBAL.dir_root_retrieval);

if ~exist(dirName)
    mkdir(dirName);
end

cd(dirName);
if ~exist('_features')
    mkdir('_features');
    cd('_features');
    fid=fopen('skip','w');
    fclose(fid);  % create skip file
    cd('..');
end

cd(oldPath);


if VARS_GLOBAL.unCut
    % ... and this one for "uncut" DB (entire takes)
    y = features_extract_subdir(fullfile(VARS_GLOBAL.dir_root, dirName,''),fspec,fullfile(VARS_GLOBAL.dir_root_retrieval, dirName,'_features',''),'HDM_uncut',true);
else
    % use this line for "cut" database ...
    y = forAllDirsInDir(fullfile(VARS_GLOBAL.dir_root, dirName,''),@features_extract_subdir,true,{},fspec,fullfile(VARS_GLOBAL.dir_root_retrieval, dirName, '_features',''));    
end

% motionTemplatePrecomputeBatch

% jjack
%y = forAllDirsInDir(fullfile(VARS_GLOBAL.dir_root,'HDM\Training\jumpingJack1Reps',''),@features_extract_subdir,true,{},fspec,fullfile(VARS_GLOBAL.dir_root,'HDM','Training','_features',''));

%info=forallfiles_filename2info_hdm_training('S:\data_MoCap\MoCaDaDB\HDM\Training');
%save HDM_Training_DB_info info
