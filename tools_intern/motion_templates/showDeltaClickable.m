function showDeltaClickable(delta,varargin)
   
global VARS_GLOBAL;

DB = [];
downsampling_fac = [];
feature_set = '';
feature_set_ranges = [];
if (nargin>4)
    downsampling_fac = varargin{4};
end
if (nargin>3)
    feature_set_ranges = varargin{3};
end
if (nargin>2)
    feature_set = varargin{2};
end
if (nargin>1)
    DB = varargin{1};
end

if (iscell(feature_set))
    f = '';
    for k=1:length(feature_set)
        f = [f '_' feature_set{k}];
    end
    feature_set_name = f;
else
    feature_set_name = feature_set;
    feature_set = {feature_set};
end
if (~iscell(feature_set_ranges))
    feature_set_ranges = {feature_set_ranges};
end
VARS_GLOBAL = setfield(VARS_GLOBAL,['DB_' feature_set_name],DB);

h=figure;
set(h,'position',[0 161 1275 229]);
hold on;
set(gcf,'name',['Cost function Delta, feature_set=' feature_set_name]);

m = max(delta);
    
if (isempty(DB))
    plot(delta);
    set(gca,'ylim',[0 m],'xlim',[1 length(delta)]);
else
    files_frame_end = DB.files_frame_end;
    files_frame_start = DB.files_frame_start;
    for k=1:length(files_frame_end)
        frame_start = files_frame_start(k);
        frame_end = files_frame_end(k);
        
        line([files_frame_end(k) files_frame_end(k)],[0 m],'color','r');
        if (isempty(downsampling_fac))
            plot(frame_start:frame_end,delta(frame_start:frame_end),'buttondownfcn',{@animateOnClick, DB.files_name{k}});
        else
            plot(frame_start:frame_end,delta(frame_start:frame_end),'buttondownfcn',{@animateOnClick,...
                                                                                     DB.files_name{k},...
                                                                                     1,...
                                                                                     (frame_end-frame_start+1)*downsampling_fac-(downsampling_fac-1),...
                                                                                     frame_start,...
                                                                                     frame_end,...
                                                                                     feature_set,...
                                                                                     feature_set_ranges...
                                                                                     });
        end
        %    labels_x(k) = frame_start + 5;
        %    [info,OK] = filename2info([VARS_GLOBAL.dir_root filenames{k}]);
        %    labels_text{k} = [info.skeletonID '_' info.motionDescription];
        
    end
    
    set(gca,'ylim',[0 m],'xlim',[1 length(delta)]);
    %text(labels_x,labels_y,labels_text,'interpreter','none');
end