function skel_lines = createSkeletonLines(skel_ind,current_frame,varargin)

global VARS_GLOBAL_ANIM

if (~iscell(skel_ind))
    skel = VARS_GLOBAL_ANIM.skel(skel_ind);
    mot = VARS_GLOBAL_ANIM.mot(skel_ind);
else
    skel = skel_ind{1};
    mot = skel_ind{2};
end

color = VARS_GLOBAL_ANIM.animated_skeleton_Color;
linewidth = VARS_GLOBAL_ANIM.animated_skeleton_LineWidth;
linestyle = VARS_GLOBAL_ANIM.animated_skeleton_LineStyle;
marker = VARS_GLOBAL_ANIM.animated_skeleton_Marker;
markersize = VARS_GLOBAL_ANIM.animated_skeleton_MarkerSize;
markeredgecolor = VARS_GLOBAL_ANIM.animated_skeleton_MarkerEdgeColor;
markerfacecolor = VARS_GLOBAL_ANIM.animated_skeleton_MarkerFaceColor;
% color, linewidth, linestyle, marker, markersize, markeredgecolor, markerfacecolor
if (nargin>8)
    markerfacecolor = varargin{9-2};
end
if (nargin>7)
    markeredgecolor = varargin{8-2};
end
if (nargin>6)
    markersize = varargin{7-2};
end
if (nargin>5)
    marker = varargin{6-2};
end
if (nargin>4)
    linestyle = varargin{5-2};
end
if (nargin>3)
    linewidth = varargin{4-2};
end
if (nargin>2)
    color = varargin{3-2};
end

%%%%%%%%%%% clear skel_lines if necessary
npaths = size(skel.paths,1);

skel_lines = cell(npaths,1);

for k = 1:npaths
    path = skel.paths{k};
    nlines = length(path)-1;
    px = zeros(2,1); py = zeros(2,1); pz = zeros(2,1);
    px(1) = mot.jointTrajectories{path(1)}(1,current_frame); 
    py(1) = mot.jointTrajectories{path(1)}(2,current_frame); 
    pz(1) = mot.jointTrajectories{path(1)}(3,current_frame);
    for j = 2:nlines % path number
        px(2) = mot.jointTrajectories{path(j)}(1,current_frame); 
        py(2) = mot.jointTrajectories{path(j)}(2,current_frame); 
        pz(2) = mot.jointTrajectories{path(j)}(3,current_frame);
        skel_lines{k}(j-1) = line(px,py,pz,'Color',color,'LineWidth',linewidth,'linestyle',linestyle,'Parent',gca,'marker',marker,'markersize',markersize,'markeredgecolor',markeredgecolor,'markerfacecolor',markerfacecolor);
        px(1) = px(2);
        py(1) = py(2);
        pz(1) = pz(2);
    end
    px(2) = mot.jointTrajectories{path(nlines+1)}(1,current_frame); 
    py(2) = mot.jointTrajectories{path(nlines+1)}(2,current_frame); 
    pz(2) = mot.jointTrajectories{path(nlines+1)}(3,current_frame);
    skel_lines{k}(nlines) = line(px,py,pz,'Color',color,'LineWidth',linewidth,'linestyle',linestyle,'Parent',gca,'marker',marker,'markersize',markersize,'markeredgecolor',markeredgecolor,'markerfacecolor',markerfacecolor);
end
