function showDeltaClickableSegments(delta,varargin)
   
global VARS_GLOBAL;

DB_cut = [];
downsampling_fac = [];
feature_set = '';
feature_set_ranges = [];
segments = [];
if (nargin>6)
    downsampling_fac = varargin{6};
end
if (nargin>5)
    feature_set_ranges = varargin{5};
end
if (nargin>4)
    feature_set = varargin{4};
end
if (nargin>3)
    segments = varargin{3};
end
if (nargin>2)
    segments_cut = varargin{2};
end
if (nargin>1)
    DB_cut = varargin{1};
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
VARS_GLOBAL = setfield(VARS_GLOBAL,['DB_segments_' feature_set_name],DB_cut);

h=figure;
set(h,'position',[0 161 1275 229]);
hold on;
set(gcf,'name',['Cost function Delta, feature_set=' feature_set_name]);

m = max(delta);
    
if (isempty(DB_cut))
    plot(delta);
    set(gca,'ylim',[0 m],'xlim',[1 length(delta)]);
else
    DB_cut_files_frame_start = DB_cut.files_frame_start;
    DB_cut_files_frame_end = DB_cut.files_frame_end;
    num_segments_total = size(segments,2);
    file = segments_cut(1,1);
    file_frame_start = DB_cut_files_frame_start(file);
    file_frame_end = DB_cut_files_frame_end(file);
    for k=1:num_segments_total
        segment_frame_start = file_frame_start+segments_cut(2,k)-1;
        segment_frame_end = file_frame_start+segments_cut(3,k)-1;
        
        if (isempty(downsampling_fac))
            plot(segment_frame_start:segment_frame_end,delta(segment_frame_start:segment_frame_end),'buttondownfcn',{@animateOnClickSegments, DB_cut.files_name{file}});
        else
            plot(segment_frame_start:segment_frame_end,delta(segment_frame_start:segment_frame_end),'buttondownfcn',{@animateOnClickSegments,...
                    DB_cut.files_name{file},...
                    segments(2,k)*downsampling_fac-(downsampling_fac-1),...
                    segments(3,k)*downsampling_fac-(downsampling_fac-1),...
                    segment_frame_start,...
                    segment_frame_end,...
                    feature_set,...
                    feature_set_ranges...
                });
        end
        
        if (k<num_segments_total && file~=segments_cut(1,k+1)) % not at end of segment list, end of file
            line([file_frame_end file_frame_end],[0 m],'color','r');
            file = segments_cut(1,k+1);
            file_frame_start = DB_cut_files_frame_start(file);
            file_frame_end = DB_cut_files_frame_end(file);
        elseif (k<num_segments_total) % end of segment, not at end of file, not and end of segment list
            line([segment_frame_end segment_frame_end],[0 m],'color','k');
        end
    end
    
    set(gca,'ylim',[0 m],'xlim',[1 length(delta)]);
    %text(labels_x,labels_y,labels_text,'interpreter','none');
end