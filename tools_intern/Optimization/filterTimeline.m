function filteredTimeline=filterTimeline(timeline,varargin)

switch nargin
    case 1
        windowsize  = 2;
        type        = 'box';
    case 2
        windowsize  = varargin{1};
        type        = 'box';
    case 3
        windowsize  = varargin{1};
        type        = varargin{2};
    otherwise
        error('Wrong number of argins!');
end

frames  = size(timeline,2);
signals = size(timeline,1);
C       = zeros(signals,frames+windowsize*2);

switch type
    case 'box'  % box filter
        kernel = ones(1,windowsize*2+1);
    case 'bin'  % binomial filter
        kernel  = pascal(windowsize*2+1,1);
        kernel  = abs(kernel(end,:));
    otherwise
        error('Unknown filter type!');
end

for w=0:windowsize*2
    C = C + [zeros(signals,w),kernel(w+1)*timeline,zeros(signals,windowsize*2-w)];
end
Z = repmat(...
    [cumsum(kernel(1:end-1))...
    sum(kernel)*ones(1,frames-windowsize*2)...
    fliplr(cumsum(kernel(1:end-1)))],...
    signals,1);
C = C./Z;
filteredTimeline = C(:,windowsize+1:end-windowsize);