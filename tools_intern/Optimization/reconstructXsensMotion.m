function recmot=reconstructXsensMotion(Tensor,skel,mot,varargin)

switch nargin
    case 3
        consideredJoints=mot.animated';
    case 4
        consideredJoints=varargin{1};
    otherwise
        error('Wrong number of input arguments!');
end

X0 = cell(1,Tensor.numNaturalModes);
for i=1:Tensor.numNaturalModes
    X0{i} = ones(1,Tensor.dimNaturalModes(i))/Tensor.dimNaturalModes(i);
end

fprintf('Computing average accelerations out of Tensor...\n');
[s,m] = constructMotion(Tensor,X0,skel);
m=addAccToMot(m);
fprintf('...done.\n');

mot = changeFrameRate(skel,mot,m.samplingRate);

fprintf('\nFinding subsequence of captured motion...\n');
XsensData   = mot.jointAccelerations{consideredJoints};
refData     = m.jointAccelerations{consideredJoints};

[xx,start] = cutXsensData(XsensData,refData);
mot=cutMotion(mot,start,start+m.nframes-1);

% fprintf('...done. Start frame: %i, end frame: %i\n',startOS,endOS);

% Warpen der aufgenommenen Bewegung
% fprintf('\nWarping the captured motion...\n');
% [D,w]   = pointCloudDTW(m,mot,'a',mot.animated',0);
% mot     = warpMotion(w,s,mot);
% fprintf('...done.\n');

fprintf('\nComputing coefficients for reconstructing the captured motion...\n');
set=defaultSet;
set.regardedJoints=consideredJoints;
res = reconstructMotion(Tensor,skel,mot,'set',set);
fprintf('...done.\n');

recmot      = res.motRec;
% recmot      = warpMotion(fliplr(w),skel,recmot);
end

function [Xsens_cut,start] = cutXsensData(XsensData,refdata)

    XsensNorm = normOfColumns(XsensData);
    refNorm = normOfColumns(refdata);
    
    mindist = inf;
    for i=1:length(XsensNorm)-length(refNorm)+1
        dist = sum(abs(XsensNorm(i:i+length(refNorm)-1)-refNorm));
        if dist<mindist 
            mindist=dist;
            start=i;
        end
    end
    Xsens_cut = XsensData(:,start:start+length(refNorm)-1);
    plot(XsensNorm(:,start:start+length(refNorm)-1));
    hold all;
    plot(refNorm);
    drawnow();
end
