% function newStream = diff5point(stream,samplingRate,varargin)
% 5-point derivation
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function newStream = diff5point(stream,samplingRate,varargin)

switch nargin
    case 2
        weights = [1 -8 0 8 -1];
        divisor = 12/samplingRate;
    case 3
        if varargin{1}==1
            weights = [1 -8 0 8 -1];
            divisor = 12/samplingRate;
        elseif varargin{1}==2;
            weights = [-1 16 -30 16 -1];
            divisor = 12/samplingRate^2;
        else
            error('Not implemented yet!');
        end
    otherwise
        error('Wrong number of argins');
end
        

newStream     = zeros(size(stream));

% padding
stream = [  3*stream(:,1)-2*stream(:,2),...
            2*stream(:,1)-stream(:,2),...
            stream,...
            2*stream(:,end)-stream(:,end-1),...
            3*stream(:,end)-2*stream(:,end-1)];

for i = 3:size(newStream,2)+2
    newStream(:,i-2) = ...
              weights(1) * stream(:,i-2) ...
            + weights(2) * stream(:,i-1) ...
            + weights(3) * stream(:,i)   ...
            + weights(4) * stream(:,i+1) ...
            + weights(5) * stream(:,i+2);
end

newStream = newStream / divisor;