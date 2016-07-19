function generateVideo(skels,mots,docName)

% generate the animated take
% filename = mots{1}.filename;
% info = filename2info(filename);

% docName = info.amcname(1:end-4);

% docName='FatGraphJoggen1';

if mots{1}.samplingRate == 120
    downsampling = 4;
else
    downsampling = 1;
end

compression = 'none';
quality = 100;
fps = 30;

figureSize = [400, 600];

if ~exist(['video_' docName '.avi'], 'file') % generate the new video
    cameraFilename = 'camera';
    if ~exist([cameraFilename '.m'], 'file')
        error(['If you want me to generate the video, you first have to generate the camera file ' [cameraFilename '.m'] '!']);
    end
    
    % at first generate the camera file
    % motionplayer('skel', {skel}, 'mot', {mot});
    % delete(findobj(gcf, 'type', 'uipanel'));
    % set(gcf, 'position', [1700, 200, 800, 250]);
    % saveCamera(gca, [cameraFilename '.m'])

    parameter.filename = ['video_' docName];
    parameter.fps = fps;
    parameter.compression = compression;
    parameter.quality = quality;
    parameter.position = [300,300];
    parameter.size = figureSize;
    parameter.motDownsampling = downsampling;
    parameter.cameraFcn = cameraFilename;
    avi1=motionplayerVideo(skels, mots, parameter);
end


% now generate the animation of the annotation image, only coarse annotation.
% addpath('./take_CMU_01_jumping_01forwardMultiple+_120.amc');

% load Variables.mat



% % frames = 1:downsampling:mot.nframes;
% % 
% % aviobj = avifile(['intro_annotation_' docName], ...
% %     'compression',  'none', ...
% %     'quality',quality,...
% %     'fps',fps);
% % 
% % %     'compression',  compression, ...
% % 
% % parameter.position = [100, 100, 800, 350];
% % parameter.drawFineAnnotations = 0;
% % 
% % for f=1:length(frames);
% %     parameter.highlightFrame = f;
% %     plotMultiLayerResult2Fig_forVideo(annotation,h4File, parameter)
% %     frame = getframe(gcf);
% %     
% %     aviobj = addframe(aviobj,frame);
% %     close all hidden;
% %     
% % end
% % 
% % aviobj=close(aviobj);


% % % now generate the animation of the annotation image, now with fine annotation.
% % aviobj = avifile(['intro_annotationFine_' docName], ...
% %     'compression',  'none', ...
% %     'quality',quality,...
% %     'fps',fps);
% % 
% % %     'compression',  compression, ...
% % 
% % parameter.position = [100, 100, 800, 350];
% % parameter.drawFineAnnotations = 1;
% % 
% % for f=1:length(frames);
% %     parameter.highlightFrame = f;
% %     plotMultiLayerResult2Fig_forVideo(annotation,h4File, parameter)
% %     frame = getframe(gcf);
% %     
% %     aviobj = addframe(aviobj,frame);
% %     close all hidden;
% %     
% % end

% aviobj=close(aviobj);



% VARS_GLOBAL_ANIM.video_compression = 'ffds';
% concatVideos_spatial({['intro_' docName '.avi'], ['intro_annotation_' docName '.avi']},['intro_annotationComparison_coarse'],'v');
% concatVideos_spatial({['intro_' docName '.avi'], ['intro_annotationFine_' docName '.avi']},['intro_annotationComparison_fine'],'v');

