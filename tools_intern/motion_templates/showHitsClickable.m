function showHitsClickable(hits,varargin)
   
global VARS_GLOBAL;

DB = [];
DB_length = 0;
feature_set = '';
feature_set_ranges = [];
downsampling_fac = 1;
if (nargin>5)
    DB_length = varargin{5};
end
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
set(h,'position',[0 450 1275 229]);
hold on;

maxx = -inf;
maxy = -inf;
minx = inf;
miny = inf;
num_hits = length(hits);
labels_pos = zeros(2,num_hits);
labels_numdigits = floor(log10(num_hits+1))+1;
format = ['%' num2str(labels_numdigits) 'd'];
labels_text = char(zeros(num_hits,labels_numdigits));
for k=1:num_hits
    x = hits(k).frame_first_matched_all:hits(k).frame_last_matched_all;
    y = k*ones(1,length(x));
    maxx = max(maxx,max(x));
    maxy = max(maxy,max(y));
    minx = min(minx,min(x));
    miny = min(miny,min(y));
    labels_pos(1,k) = x(1);
    labels_pos(2,k) = y(1);
    labels_text(k,:) = sprintf(format,k);
    plot(x,y,'buttondownfcn',{@animateOnClick,...
                              hits(k).file_name,...
                              hits(k).frame_first_matched*downsampling_fac-(downsampling_fac-1),...
                              hits(k).frame_last_matched*downsampling_fac-(downsampling_fac-1),...
                              hits(k).frame_first_matched_all,...
                              hits(k).frame_last_matched_all,...
                              feature_set,...
                              feature_set_ranges...
                              });
end
text(labels_pos(1,:),labels_pos(2,:),labels_text);
miny = miny-1;
maxy = maxy+1;
if (DB_length>0)
    maxx = DB_length;
end
if (minx<maxx)
    set(gca,'ylim',[miny maxy],'xlim',[minx maxx]);
end
axis ij;