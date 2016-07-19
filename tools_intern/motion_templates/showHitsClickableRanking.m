function showHitsClickableRanking(hits,varargin)

global VARS_GLOBAL;

DB = [];
feature_set = '';
feature_set_ranges = [];
downsampling_fac = 1;
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
VARS_GLOBAL = setfield(VARS_GLOBAL,['DB_segments_' feature_set_name],DB);

h=figure;
set(h,'position',[0 450 1275 229]);
hold on;
set(gcf,'name',['Top ' num2str(length(hits)) ' hits, sorted by ascending cost, feature_set=' feature_set_name '.'])

[h,I] = sort([hits.cost]');

dy = h(end)-h(1);
ylow = h(1)-0.1*dy;
yhigh = h(end)+0.1*dy;

for k=1:length(hits)
    x = [k-0.5 k+0.5];
    y = hits(I(k)).cost*ones(1,length(x));
    line([k+0.5 k+0.5],[ylow yhigh],'color',[0 0.5 0]);
    plot(x,y,'buttondownfcn',{@animateOnClick,...
                              hits(I(k)).file_name,...
                              hits(I(k)).frame_first_matched*downsampling_fac-(downsampling_fac-1),...
                              hits(I(k)).frame_last_matched*downsampling_fac-(downsampling_fac-1),...
                              hits(I(k)).frame_first_matched_all,...
                              hits(I(k)).frame_last_matched_all,...
                              feature_set,...
                              feature_set_ranges...
                      });
end

if (ylow==yhigh)
    yhigh = yhigh+0.5;
end
set(gca,'ylim',[ylow yhigh],'xlim',[0.5 max(1,length(hits)+0.5)]);
axis ij;