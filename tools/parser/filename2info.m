function [info,OK] = filename2info(amcfullpath)
info = struct('amcname','',...
              'asfname','',...
              'amcpath','',...
              'filetype','ASF/AMC',...
              'skeletonSource','',...
              'skeletonID','',...
              'motionCategory','',...
              'motionDescription','',...
              'samplingRate',0);

n = strfind(amcfullpath, filesep);
if (isempty(n))
    info.amcpath = '';
    info.amcname = amcfullpath;
else
    n = n(end);
    info.amcpath = amcfullpath(1:n);
    info.amcname = amcfullpath(n+1:end);
end

OK = true;
p = strfind(info.amcname,'_');
if (length(p)~=4)
    disp(['**** Filename "' info.amcname '" doesn''t conform with MoCaDa standard! (filename2info b)']);
    OK = false;
    return;
end

n = strfind(info.amcname,'.');
if (length(n)<=0) % no period in amc filename? weird... there should at least be a ".amc"!!
    disp(['**** Filename "' info.amcname '" doesn''t have a file extension!']);
    OK = false;
    return;
%    n = length(info.amcname+1);
else
    n = n(end);
end

info.skeletonSource = info.amcname(1:p(1)-1);
info.skeletonID = info.amcname(p(1)+1:p(2)-1);
info.motionCategory = info.amcname(p(2)+1:p(3)-1);
info.motionDescription = info.amcname(p(3)+1:p(4)-1);
[info.samplingRate,OK] = str2num(info.amcname(p(4)+1:n-1));
if (~OK)
    disp(['**** Couldn''t deduce sampling rate from filename "' info.amcname '"!']);
end

if (strcmpi(info.amcname(n(end)+1:end),'BVH'))
    info.asfname = info.amcname;
    info.filetype = 'BVH';
elseif (strcmpi(info.amcname(n(end)+1:end),'C3D'))
    info.asfname = info.amcname;
    info.filetype = 'C3D';
else
    info.asfname = [info.skeletonSource '_' info.skeletonID '.asf'];
end
