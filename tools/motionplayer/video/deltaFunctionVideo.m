addpath('H:\unix-home\MyDocuments\motionretrieval\tools_intern\multilayer_annotation')
%% generate delta curves for hopLeft and hopRight
feature_set = {'AK_upper', 'AK_lower', 'AK_mix_avr'};

DB_concat = DB_index_load('HDM05_CMU_EG08_tiny', feature_set, 4);
document = 100;
docStart = DB_concat.files_frame_start(document);
docEnd = DB_concat.files_frame_end(document);

docLength = 520; %length in frames, 30 Hz.

features = DB_concat.features(:, docStart:docStart+docLength-1);


trainingDB = 'HDM05_EG08_cut_amc_training';
basedir_templates = fullfile(trainingDB, '_templates','');

parameter.outputHits = 0;
parameter.outputC = 0;
parameter.outputD = 0;
parameter.outputDelta = 1;
parameter.outputClassificationDelta = 1;
parameter.match_numMax = 2000;

parameter.hit_threshold = 0.13;
parameter.thresh_quantize_mt = 0.05;

parameter.match_endExclusionForward = 0;
parameter.match_endExclusionBackward = 0.5;
parameter.match_startExclusionForward = 0.5;
parameter.match_startExclusionBackward = 0;

motionClass = 'hopLLeg1hops';
[temp,temp,temp,deltaHopL, cDeltaHopL] = motionClass_to_Delta(motionClass, features, basedir_templates, feature_set, parameter);
motionClass = 'hopRLeg1hops';
[temp,temp,temp,deltaHopR, cDeltaHopR] = motionClass_to_Delta(motionClass, features, basedir_templates, feature_set, parameter);

%% generate video for the 
load('C:\abaak\HDM05\HDM05_CMU_EG08_tiny\tr\HDM_tr_01-05_01_120.amc.MAT')

mot = cropMot(mot, 1:(docLength*4));
cameraFilename = 'camera_HDM_tr_01-05_01_excerpt';
% at first generate the camera file
% motionplayer('skel', {skel}, 'mot', {mot});
% delete(findobj(gcf, 'type', 'uipanel'));
% set(gcf, 'position', [1700, 200, 800, 300]);
% cameratoolbar;
% saveCamera(gca, removeUnderscore([cameraFilename '.m']))
clear parameter;
takeFilename = 'HDM_tr_01-05_01_120_excerpt';
parameter.filename = takeFilename;
parameter.fps = 30;
parameter.compression = 'ffds';
parameter.quality = 100;
parameter.position = [300,300];
parameter.size = [800, 300];
parameter.motDownsampling = 4;
parameter.cameraFcn = cameraFilename;
avi1=motionplayerVideo(skel, mot, parameter);

%% now generate the delta figure.
maxValue = 0.32;
max_thresh = 0.13;
figure;
set(gcf, 'position', [300,300,800, 300]);
subplot(3,1,1);
plot(deltaHopR, 'k-');
l=line([1, length(deltaHopR)], [max_thresh, max_thresh], 'color', 'red', 'linestyle', '--');
set(gca, 'xlim', [1, length(deltaHopR)]);
set(gca, 'ylim', [0, maxValue]);

subplot(3,1,2);
plot(deltaHopL, 'k-');
l=line([1, length(deltaHopR)], [max_thresh, max_thresh], 'color', 'red', 'linestyle', '--');
set(gca, 'xlim', [1, length(deltaHopR)]);
set(gca, 'ylim', [0, maxValue]);

%% now generate a video from it.
deltaFunctionsFilename = 'deltaFunctions_HDM_tr_01-05_01_120';
aviobj = avifile(deltaFunctionsFilename, ...
    'compression',  parameter.compression, ...
    'quality',parameter.quality,...
    'fps',parameter.fps);

for f=1:docLength
    subplot(3,1,1);
    lineHandle(1) = line([f, f], [0.0, maxValue], 'Color', [0,1,1]);
    subplot(3,1,2);
    lineHandle(2) = line([f, f], [0.0, maxValue], 'Color', [0,1,1]);

    frame = getframe(gcf);
    aviobj = addframe(aviobj,frame);
    delete(lineHandle);
    
end
close(gcf);
aviobj=close(aviobj);

%% now add the deltaMin and do the video again

subplot(3,1,3);
plot(min(deltaHopL, deltaHopR), 'k-');
l=line([1, length(deltaHopR)], [max_thresh, max_thresh], 'color', 'red', 'linestyle', '--');
set(gca, 'xlim', [1, length(deltaHopR)]);
set(gca, 'ylim', [0, maxValue]);


deltaFunctionsMinFilename = 'deltaFunctionsMin_HDM_tr_01-05_01_120';
aviobj = avifile(deltaFunctionsMinFilename, ...
    'compression',  parameter.compression, ...
    'quality',parameter.quality,...
    'fps',parameter.fps);

for f=1:docLength
    subplot(3,1,1);
    lineHandle(1) = line([f, f], [0.0, maxValue], 'Color', [0,1,1]);
    subplot(3,1,2);
    lineHandle(2) = line([f, f], [0.0, maxValue], 'Color', [0,1,1]);
    subplot(3,1,3);
    lineHandle(3) = line([f, f], [0.0, maxValue], 'Color', [0,1,1]);

    frame = getframe(gcf);
    aviobj = addframe(aviobj,frame);
    delete(lineHandle);
    
end
close(gcf);
aviobj=close(aviobj);

%%  combine the videos


concatVideos_spatial({[takeFilename '.avi'], [deltaFunctionsFilename '.avi']},[takeFilename '_with_' deltaFunctionsFilename],'v');

% pad 12 seconds front for audio
padAviFrontBack([takeFilename '_with_' deltaFunctionsFilename '.avi'], 360, 0, [takeFilename '_with_' deltaFunctionsFilename '_padded']);


concatVideos_spatial({[takeFilename '.avi'], [deltaFunctionsMinFilename '.avi']},[takeFilename '_with_' deltaFunctionsMinFilename],'v');

