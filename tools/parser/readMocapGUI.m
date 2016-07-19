function [skel, mot] = readMocapGUI(noCaching)
% [skel, mot] = readMocapGUI(noCaching)

if nargin < 1
    noCaching = false;
end

global VARS_GLOBAL;

oldPath = cd;

try
    defaultPath = VARS_GLOBAL.readMocapGUILastDir;
catch
    try
        defaultPath = VARS_GLOBAL.DBPATH;
    catch
        defaultPath = cd;
    end
end

% cd(defaultPath);

[datafile,datapath] = uigetfile('*.c3d; *.amc', 'Choose data file');

if datafile ~= 0
    
    VARS_GLOBAL.readMocapGUILastDir = datapath;
    
    idx = findstr(datafile,'.');
    ext = upper(datafile(idx(end):end));
    
    if strcmp(ext, '.C3D')
        [skel, mot] = readMocap([datapath,datafile], [], noCaching);
    elseif strcmp(ext, '.AMC')
        asfFiles = dir([datapath '\*.ASF']);
        if isempty(asfFiles)
            cd(datapath);
            [asfFile, asfPath] = uigetfile('*.asf', 'Choose ASF file');
        else
            asfPath = datapath;
            asfFile = [datafile(1:6) '.ASF'];
            if ~exist(asfFile,'file')
                [asfFile, asfPath] = uigetfile('*.asf', 'Choose ASF file');
            end
        end
        [skel, mot] = readMocap([datapath,asfFile], [datapath,datafile], [], true, true, true, noCaching);
    end
end

cd(oldPath);