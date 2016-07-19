close all;
upsampling_fac = 2.5;

[skel,mot] = readMocap(fullfile(VARS_GLOBAL.dir_root,'HDM\Uncut\tr','HDM_tr.asf'),fullfile(VARS_GLOBAL.dir_root,'HDM\Uncut\tr','HDM_tr_5-3_d_120.amc'));

%mot.rootTranslation = mot.rootTranslation + repmat([45; 0; 45],1,mot.nframes);
mot = resampleMot(mot,mot.samplingRate*upsampling_fac);
mot.samplingRate = mot.samplingRate/upsampling_fac;
mot.frameTime = mot.frameTime*upsampling_fac;

range = [5780:6100];
range1 = [ceil(upsampling_fac*range(1)):ceil(upsampling_fac*range(end))];
%range1 = [51:141];

lindgruen = [0.75 1 0.75];
cyan = [0 1 1];
mot1 = cropMot(mot,range1);

fr1 = feature_AK_bool_handRightRaisedRelSpine(mot1);
point_color_r1 = repmat(fr1',1,3).*repmat(lindgruen,mot1.nframes,1)+repmat((1-fr1)',1,3).*repmat([0 0 0],mot1.nframes,1);

VARS_GLOBAL_ANIM.video_compression = 'PNG1';

figure;
hold;
set(gcf,'renderer','opengl','doublebuffer','on');
plot(fr1,'black','linewidth',2);
set(gca,'xlim',[1 mot1.nframes],'ylim',[0 1.15],'xticklabel',[],'xtick',[],'yticklabel',[0 1],'ytick',[0 1]);

set(gcf,'position',[5 100 640 100],'color',[192 192 192]/255);
p = plot(1,fr1(1),'o','markersize',16,'markerfacecolor',point_color_r1(1,:),'markeredgecolor','black');
videofile = 'render/video_feature_rhand_raised_boolean.avi';
aviobj = avifile(videofile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',30);
for k=1:mot1.nframes
    set(p,'markerfacecolor',point_color_r1(k,:),'xdata',k,'ydata',fr1(k),'zdata',0.1);
    frame = getframe(gcf);
% 	if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
% 		frame.cdata = flipdim(frame.cdata,1);
% 	end
    aviobj = addframe(aviobj,frame);
end
aviobj = close(aviobj);
disp(['Wrote output video file ' videofile '.']);    

