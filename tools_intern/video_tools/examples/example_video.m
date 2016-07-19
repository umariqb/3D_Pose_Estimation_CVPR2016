[skel,mot]=readmocapd(38);

global VARS_GLOBAL_ANIM
VARS_GLOBAL_ANIM.video_compression = 'div4';
VARS_GLOBAL_ANIM.figure_position = [10 100 512 384];
VARS_GLOBAL_ANIM.figure_camera_file = 'test_camera';

%saveCamera(gca,'test_camera.m'); % einmalig ausführen, um gegenwärtigen view zu speichern

% falls während des renderns abgebrochen wird:
% AVI-file ist noch offen, der muss dann von hand geschlossen werden: clear mex

% skel,mot,videofile,num_repeats,time_stretch_factor,downsampling_fac,range,draw_labels,fps
animateVideo(skel,mot,'test.avi',1,1,1,[],0,30);