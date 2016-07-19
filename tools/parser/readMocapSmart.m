function [ skel, mot ] = readMocapSmart( fullFilename, noCaching, noScaling )
% [ skel, mot ] = readMocapSmart( fullFilename, noCaching, noScaling )
%
%
%  
%  readMocapSmart does not require specification of ASF-file 
%      and automatically performs scaling (unit conversion)
%
%               noCaching: Don't read *.MAT-file
%               noScaling: Don't scale ASF/AMC files by 2.54 (default: false)
%
%
% Units are may be in centimeter or in inches 
%     (ASF/AMC units of HDM05 files are in inches)
%     (C3D units of HDM05 files are in centimeters)
%
% noScaling = false -> scaling by factor 1/2.54 to 
%     convert inches -> centimeters (only for ASF/AMC)
% 


if nargin < 2
    noCaching = false;
end
if nargin < 3
    noScaling = false;
end

info = filename2info(fullFilename);

if strcmpi(info.filetype, 'C3D')
    [skel, mot] = readMocap(fullFilename, [], noCaching );
elseif strcmpi(info.filetype, 'ASF/AMC')
    skelFile = fullfile(info.amcpath, info.asfname);
    [skel, mot] = readMocap(skelFile, fullFilename, [], true, true, true, noCaching);
    
    if ~noScaling
        [skel, mot] = scaleSkelMot(skel, mot, 1/2.54);  % our ASF
    end
end
