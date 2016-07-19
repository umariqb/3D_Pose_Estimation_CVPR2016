% function newStream = diff5point(stream,samplingRate,varargin)
% 5-point derivation
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function newStream = diff5point2(stream,samplingRate,varargin)

% defaults
options.padding      = true;
options.derivative   = 1; 
options.side         = 'center';

nrOfFrames = size(stream,2);

if nargin>2
    options = mergeOptions(varargin{1},options);
end

if options.padding
    newStream = zeros(size(stream));
else
    newStream = zeros(size(stream,1),nrOfFrames-4);
end

prepadding  = [];
postpadding = [];
switch options.side
    case 'left'
        left = 4;
        right = 0;
        if options.padding
            prepadding  = interp1(1:nrOfFrames,stream',-3:0,'linear','extrap')';
            postpadding = [];
        end
        switch options.derivative
            case 1
                weights = [3 -16 36 -48 25];
                divisor = 12/samplingRate;
            case 2
                weights = -[-11 56 -114 104 -35];
                divisor = 12/samplingRate^2;
            otherwise
                error('Not yet implemented!');
        end
    case 'right'
        left = 0;
        right = 4;
        if options.padding
            prepadding  = [];
            postpadding = interp1(1:nrOfFrames,stream',nrOfFrames+1:nrOfFrames+4,'linear','extrap')';
        end
        switch options.derivative
            case 1
                weights = [-25 48 -36 16 -3];
                divisor = 12/samplingRate;
            case 2
                weights = [35 -104 114 -56 11];
                divisor = 12/samplingRate^2;
            otherwise
                error('Not yet implemented!');
        end
    case 'center'
        left = 2;
        right = 2;
        if options.padding
            prepadding  = interp1(1:nrOfFrames,stream',-1:0,'linear','extrap')';
            postpadding = interp1(1:nrOfFrames,stream',nrOfFrames+1:nrOfFrames+2,'linear','extrap')';
        end
        switch options.derivative
            case 1
                weights = [1 -8 0 8 -1];
                divisor = 12/samplingRate;
            case 2
                weights = [-1 16 -30 16 -1];
                divisor = 12/samplingRate^2;
            otherwise
                error('Not yet implemented!');
        end
end

if size(stream,1)==1
    prepadding = prepadding';
    postpadding = postpadding';
end

stream  = [prepadding stream postpadding];

for i = left+1:size(stream,2)-right
    newStream(:,i-left) = stream(:,i-left:i+right) * weights';
end

newStream = newStream / divisor;