%extractVideoFrame('walk_query_video.avi','last','walk_query_lastframe.tif')
%replicateImage('walk_query_lastframe.tif', 'walk_query_lastframe.avi', 30, 5);
%transparencyOverlay('walk_query_lastframe.avi','overlay_query_features1.tif','walk_query_overlay.avi',[192 192 192],[true false]);
% replicateImage('overlay_query_features2.tif', 'overlay_query_features2.avi', 30, 2.5);
% replicateImage('overlay_query_features3.tif', 'overlay_query_features3.avi', 30, 5);
% 
%  transparencyOverlay('overlay_query_features3.avi','overlay_query_features4.tif','overlay_query_features4.avi',[192 192 192],[true false],2.5);
% 
% concatVideosSmooth_temporal({'walk_query_overlay.avi',...
%                              'overlay_query_features2.avi',...
%                              'overlay_query_features4.avi',...
%                              'walk_query_hit_video_final.avi'},...
%                             'walk_query_1.avi',...
%                              {[],...
%                               [],...
%                               [],...
%                               []},...
%                              0.25);
% concatVideos_temporal({'walk_query_video_combined_final_overlay_title.avi','walk_query_1.avi'},'walk_query_and_exact_hits.avi');

% replicateImage('overlay_query_features8.tif', 'overlay_query_features8.avi', 30, 19);
% nframes = 30*(19 - 4.5);
% fade_duration_in_frames = 15;
% blend_func = [zeros(1,30*4.5) [0:fade_duration_in_frames-1]...
%               (fade_duration_in_frames-1)*ones(1,nframes-1*fade_duration_in_frames)] / (fade_duration_in_frames-1);
%  transparencyOverlay('overlay_query_features8.avi','overlay_query_features9.tif','overlay_query_features9.avi',[192 192 192],blend_func);
% nframes = 30*(19 - 4.5 - 7.5);
% fade_duration_in_frames = 15;
% blend_func = [zeros(1,30*(4.5+7.5)) [0:fade_duration_in_frames-1]...
%               (fade_duration_in_frames-1)*ones(1,nframes-1*fade_duration_in_frames)] / (fade_duration_in_frames-1);
%  transparencyOverlay('overlay_query_features9.avi','overlay_query_features10.tif','overlay_query_features10.avi',[192 192 192],blend_func);

% replicateImage('table_indexing.tif', 'table_indexing.avi', 30, 26);

% replicateImage('emptyGray512x384.tif', 'empty.avi', 30, 125/30);
% transparencyOverlay('empty.avi','acknowledgements.tif','acknowledgements.avi',[192 192 192],[true false],0.5);

% replicateImage('DTW_prealigned.tif', 'DTW_prealigned.avi', 30, 7);
