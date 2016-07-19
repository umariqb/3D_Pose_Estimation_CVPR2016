global VARS_GLOBAL
    gindex = GIndexBuild([1],{[1 2]});
%    gindex_181 = GIndexRestrictDoc(gindex,181);
%    gindex_181_coarse = GIndexRestrictFeatureSet(gindex_181,[2]);
%   gindex_182 = GIndexRestrictDoc(gindex,182);
%   gindex_182_coarse = GIndexRestrictFeatureSet(gindex_182,[1]);
    gindex_183 = GIndexRestrictDoc(gindex,183);
    gindex_183_coarse = GIndexRestrictFeatureSet(gindex_183,[1]);

close all
[skel,mot]=readMocapD(183);
range = [51:150];
range_120 = [4*51:4*150];
mot_120 = resampleMot(mot,120);
range_90 = [3*51:3*150];
mot_90 = resampleMot(mot,90);
mot = cropMot(mot,range);
mot_120 = cropMot(mot_120,range_120);
mot_90 = cropMot(mot_90,range_90);

%clearTracePoses;
%trace_poses = [1 33 43 53 63 73 83 93 100];
%showTracePoses(skel,mot,trace_poses); %color, linewidth, linestyle, marker, markersize, markeredgecolor, markerfacecolor

global VARS_GLOBAL_ANIM
VARS_GLOBAL_ANIM.animated_skeleton_Color = [0 0 0]/255;
VARS_GLOBAL_ANIM.animated_skeleton_Marker = '.';
VARS_GLOBAL_ANIM.animated_skeleton_MarkerSize = 14;
VARS_GLOBAL_ANIM.animated_point_MarkerSize = 12;
VARS_GLOBAL_ANIM.animated_skeleton_LineWidth = 4;
VARS_GLOBAL_ANIM.ground_tile_size_factor = 2;
VARS_GLOBAL_ANIM.bounding_box_border_extension = 8;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerEdgeColor = [100 100 100]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerFaceColor = [100 100 100]/255;
VARS_GLOBAL_ANIM.figure_position = [5 5 512 384];
rehash path;
VARS_GLOBAL_ANIM.figure_camera_file = 'walk_adaptive_segmentation_video_camera1';

colors =...
[255   0 0;...      % red
 0   0   255;...    % blue
 0   255 0;...      % light green
 0   255 255;...    % cyan
 0   128 0;...      % dirty green
 255 0   128;...    % pink
 128 0   0;...      % wine red
 128 255 128;...    % bright green
 128 0   255;...    % purple
 255 128 0;...      % orange
 255 255 0;...      % yellow
 192 192 192;...    % light grey
 64  128 128;...    % greenish blue
 255 128 255;...    % light pink
 128 128 0;...      % olive green
 198 255 198]/255;  % mint green
colors_num = size(colors,1);

% outfile = 'walk_adaptive_segmentation_video1.avi';
% aviobj = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',30);
% i = 0; % pointer into gindex_183.FS.frame_start
% while (i<length(gindex_183.FS.frame_start) && range(1)>gindex_183.FS.frame_start(i+1)) %fast forward to range(1) in FS.features array
%     i = i+1;
% end
% for k=1:length(range)
%     frame = k;
%     animate(skel,mot,1,1,[frame],0);
%     skel_lines = VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).skel_lines;
%     if (i<length(gindex_183.FS.frame_start) && frame+range(1)-1>=gindex_183.FS.frame_start(i+1))
%         i = i+1;
%     end
%     feature = gindex_183.FS.features(i);
%     for j=1:length(skel_lines{1})
%         h = skel_lines{1};
%         set(h{j},'color',colors(mod(feature-1,colors_num)+1,:));
%     end
%     showTrajectoriesSegments_GIndex(183,gindex_183,{'lfingers','rfingers','headtop','lankle','rankle'},[range(1):range(k)],1.75,'.-',15);
%     % doc_id,gindex,trajname,range,linewidth,linestyle,markersize,markeredgecolor,colors
%     frame = getframe(gcf);
%     if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
%		frame.cdata = flipdim(frame.cdata,1);
%	  end
%     aviobj = addframe(aviobj,frame);
%     delete(get(gcf,'children'));
% end
% aviobj = close(aviobj);
% disp(['Wrote output video file ' outfile '.']);

close;
outfile = 'walk_adaptive_segmentation_video1_slomo.avi';
aviobj = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',30);
i = 0; % pointer into gindex_183.FS.frame_start
while (i<length(gindex_183.FS.frame_start) && range(1)>gindex_183.FS.frame_start(i+1)) %fast forward to range(1) in FS.features array
    i = i+1;
end
for k=1:length(range_90)
    frame = floor(k/3)+1;
    animate(skel,mot_90,1,1,[k],0);
    skel_lines = VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).skel_lines;
    if (i<length(gindex_183.FS.frame_start) && frame+range(1)-1>=gindex_183.FS.frame_start(i+1))
        i = i+1;
    end
    feature = gindex_183.FS.features(i);
    for j=1:length(skel_lines{1})
        h = skel_lines{1};
        set(h{j},'color',colors(mod(feature-1,colors_num)+1,:),'markeredgecolor',colors(mod(feature-1,colors_num)+1,:),'markerfacecolor',colors(mod(feature-1,colors_num)+1,:));
    end
    showTrajectoriesSegments_GIndex(183,gindex_183,{'lfingers','rfingers','headtop','lankle','rankle'},[range(1):range(frame)],1.75,'.-',15);
    % doc_id,gindex,trajname,range,linewidth,linestyle,markersize,markeredgecolor,colors
    frame = getframe(gcf);
	if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
		frame.cdata = flipdim(frame.cdata,1);
	end
    aviobj = addframe(aviobj,frame);
    delete(get(gcf,'children'));
end
aviobj = close(aviobj);
disp(['Wrote output video file ' outfile '.']);

% VARS_GLOBAL_ANIM.figure_position = [5 5 512 190];
% rehash path;
% VARS_GLOBAL_ANIM.figure_camera_file = 'walk_adaptive_segmentation_video_camera1b';
% 
% close;
% outfile = 'walk_adaptive_segmentation_video1_small_slomo.avi';
% aviobj = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',30);
% i = 0; % pointer into gindex_183.FS.frame_start
% while (i<length(gindex_183.FS.frame_start) && range(1)>gindex_183.FS.frame_start(i+1)) %fast forward to range(1) in FS.features array
%     i = i+1;
% end
% for k=1:length(range_120)
%     frame = floor(k/4)+1;
%     animate(skel,mot_120,1,1,[k],0);
%     skel_lines = VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).skel_lines;
%     if (i<length(gindex_183.FS.frame_start) && frame+range(1)-1>=gindex_183.FS.frame_start(i+1))
%         i = i+1;
%     end
%     feature = gindex_183.FS.features(i);
%     for j=1:length(skel_lines{1})
%         h = skel_lines{1};
%         set(h{j},'color',colors(mod(feature-1,colors_num)+1,:),'markeredgecolor',colors(mod(feature-1,colors_num)+1,:),'markerfacecolor',colors(mod(feature-1,colors_num)+1,:));
%     end
%     showTrajectoriesSegments_GIndex(183,gindex_183,{'lfingers','rfingers','headtop','lankle','rankle'},[range(1):range(frame)],1.75,'.-',15);
%     % doc_id,gindex,trajname,range,linewidth,linestyle,markersize,markeredgecolor,colors
%     frame = getframe(gcf);
%     if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
%		frame.cdata = flipdim(frame.cdata,1);
%	  end
%     aviobj = addframe(aviobj,frame);
%     delete(get(gcf,'children'));
% end
% aviobj = close(aviobj);
% disp(['Wrote output video file ' outfile '.']);


% sustainVideoFrames(outfile,'walk_adaptive_segmentation_video1_small_slomo_sustained.avi',[397],[23])
% padVideo('walk_adaptive_segmentation_video1_small_slomo_sustained.avi','walk_adaptive_segmentation_video1_small_padded.avi',[192 192 192],4,'b');
% concatVideosSmooth_temporal({'title_adaptive_segmentation.avi','walk_adaptive_segmentation_video1_slomo_sustained.avi'},'walk_adaptive_segmentation_video1_slomo_sustained_title.avi',{'emptyGray512x384.tif'},0.25);