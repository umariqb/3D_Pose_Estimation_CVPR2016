function varargout = animateSimultaneous(hits,varargin)

global VARS_GLOBAL


num_repeats = 1;
speed = 1;
range = [];
chkr_width = 4;
mutual_dist = [3 3];
video_file = '';
downsampling_factor = 4;
sampling_rate = 30;
alpha = -pi;
str = '';

if (nargin>10)
    str = varargin{10};
end
if (nargin>9)
    alpha = varargin{9};
end
if (nargin>8)
    sampling_rate = varargin{8};
end
if (nargin>7)
    downsampling_factor = varargin{7};
end
if (nargin>6)
    video_file = varargin{6};
end
if (nargin>5)
    mutual_dist = varargin{5};
end
if (nargin>4)
    chkr_width = varargin{4};
end
if (nargin>3)
    range = varargin{3};
end
if (nargin>2)
    speed = varargin{2};
end
if (nargin>1)
    num_repeats = varargin{1};
end

if (iscell(hits))
    cs = hits{1};
    cm = hits{2};
else
    cs = emptySkeleton;
    cm = emptyMotion;
end

range_all = false;
if (iscell(range))
    % do nothing, use the cell-array-specified ranges
elseif (isempty(range))
    range_all = true;
    range = cell(length(hits),1);
else % single range vector, nonempty
    range_vec = range;
    range = cell(length(hits),1);
    for k=1:length(range)
        range{k} = range_vec;
    end
end

if (~iscell(hits))
    if (~range_all)
       for k=1:length(hits)
%            range{k} = C_intersect_presorted([hits(k).frame_start:hits(k).frame_end],range{k});
            range{k} = C_intersect_presorted([hits(k).frame_first_matched:hits(k).frame_last_matched],range{k});
        end
    else
       for k=1:length(hits)
            range{k} = [hits(k).frame_first_matched:hits(k).frame_last_matched];
        end
    end
    cs = emptySkeleton;
    cm = emptyMotion;
	%file_ids = cell2mat({hits.file_id});
	bb = [inf -inf inf -inf inf -inf]';
	for k=1:length(hits)
        amcfullpath = [VARS_GLOBAL.dir_root hits(k).file_name];
        [info,OK] = filename2info(amcfullpath);

        [cs(k),mot] = readMocap([info.amcpath info.asfname], amcfullpath, [1 inf]);
        mot=cropMot(mot,range{k});
        %mot = integerDownsampleMot(mot,round(mot.samplingRate/sampling_rate));
        [cs(k),mot] = normalizeSkelMot(cs(k),mot);
%        mot.rootTranslation([1 3],:) = zeros(2,mot.nframes);
%        mot.jointTrajectories = forwardKinematicsQuat(cs(k),mot);
%        mot.boundingBox = computeBoundingBox(mot);
        
        range{k}=1:mot.nframes;
%        range{k}=range{k}-range{k}(1)+1;
        
        mot = moveMotToXZ(mot,[0;0]); % center first frame of motion at origin
%        alpha = -pi; % angle between front vector and x axis in radians
%        rand(1,1)*pi/2
        x0 = -10;
        z0 = round(length(hits)/chkr_width)/2-1;
        if (~isempty(alpha))
            mot = rotateMotY(cs(k),mot,[cos(alpha);sin(alpha)],'lshoulder','rshoulder'); % orientate front vector
        end
%         x = mod(k-1,chkr_width);
%         z = fix((k-1)/chkr_width);
%         mot = rotateMotY(cs(k),mot,[x0-x;z0-z]); % orientate front vector so that everyone faces a fixed point [x0;z0]
%        mot.boundingBox = computeBoundingBox(mot);
        cm(k) = mot;
%        if (k<14)
        %        end
	end
    x_ofs = mutual_dist(1);
  	z_ofs = mutual_dist(2);

	for k=1:length(cm)
%        offset_xz = (k-1)*[5;0;5]; % skeletons placed along diagonal
        x = mod(k-1,chkr_width);
        z = fix((k-1)/chkr_width);
        offset_xz = [x*x_ofs;0;z*z_ofs]; %  skeletons placed in checkerboard formation
        if (mod(z,2)==0) % "indent" every other columns by x_ofs/2
             offset_xz(1) = offset_xz(1) + x_ofs/2;
        end
%        text(offset_xz(1)-3,0.15,offset_xz(3)-2,num2str(k));
%        if (mod(z,2)==0) % "indent" every other row by z_ofs
%            offset_xz(1) = offset_xz(1) + z_ofs;
%        end
%         if (k>=8 & mod(k,2)==0 & mod(k,4)==2)
%             offset_xz(1) = offset_xz(1) + z_ofs*0.4;
%         end
        for j=1:length(cm(k).jointTrajectories)
            cm(k).jointTrajectories{j} = cm(k).jointTrajectories{j} + repmat(offset_xz,1,size(cm(k).jointTrajectories{j},2));
            cm(k).boundingBox = computeBoundingBox(cm(k));
        end

%         showTrajectory(cm(k),'lankle','green.',4)
%         showTrajectory(cm(k),'rankle','blue.',4)

	end
end	

% for k=1:length(range) % insert this in GHitAnimate.m, line 114
%    if (k~=4)
%       range{k} = [range{k}(1)];
%    end
% end

if (isempty(video_file))
    animate(cs,cm,num_repeats,speed,range,zeros(length(cm),1));
else
    animateVideo(cs,cm,video_file,num_repeats,speed,downsampling_factor,range,zeros(length(cm),1),sampling_rate,str);
end    

if (nargout>0)
    varargout{1} = cs;
end
if (nargout>1)
    varargout{2} = cm;
end