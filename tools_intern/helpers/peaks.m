function P = peaks(varargin)
% returns:              column vector of peak positions
%
% args: W               signal to be searched for (positive) peaks
%
%       dir             +1 for forward peak searching, -1 for backward peak
%                       searching, 0 for bidirectional search. default is dir == 0.
%
%       abs_thresh      absolute threshold signal, i.e. only peaks 
%                       satisfying W(i)>=abs_thresh(i) will be reported.
%                       abs_thresh must have the same number of samples as W.
%                       a sensible choice for this parameter would be a global or local
%                       average or median of the signal W.
%                       if omitted, half the median of W will be used.
%
%       rel_thresh      relative threshold signal. only peak positions i with an
%                       uninterrupted positive ascent before position i of at least 
%                       rel_thresh(i) and a possibly interrupted (see parameter descent_thresh)
%                       descent of at least rel_thresh(i) will be reported.
%                       rel_thresh must have the same number of samples as W.
%                       a sensible choice would be some measure related to the
%                       global or local variance of the signal W.
%                       if omitted, half the standard deviation of W will be used.
%
%       descent_thresh  descent threshold. during peak candidate verfication, if a slope change 
%                       from negative to positive slope occurs at sample i BEFORE the descent has 
%                       exceeded rel_thresh(i), and if descent_thresh(i) has not been exceeded yet, 
%                       the current peak candidate will be dropped. 
%                       this situation corresponds to a secondary peak
%                       occuring shortly after the current candidate peak (which might lead
%                       to a higher peak value)!
%                       
%                       the value descent_thresh(i) must not be larger than rel_thresh(i).
%
%                       descent_thresh must have the same number of samples as W.
%                       a sensible choice would be some measure related to the
%                       global or local variance of the signal W.
%                       if omitted, 0.5*rel_thresh will be used.
%
%       tmin            index of start sample. peak search will begin at W(tmin).
%
%       tmax            index of end sample. peak search will end at W(tmax).
%
if nargin <= 0 || nargin > 7
    error('Wrong number of arguments.');
end
if nargin >= 7
    tmax = varargin{7};
end
if nargin >= 6
    tmin = varargin{6};
end
if nargin >= 5
    descent_thresh = varargin{5};
end
if nargin >= 4
   rel_thresh = varargin{4};
end
if nargin >= 3
   abs_thresh = varargin{3};
end
if nargin >= 2
   dir = varargin{2};
   if dir ~= 1 & dir ~= -1 & dir ~= 0
        error('Direction has to be either 0, +1, or -1.');
   end
end
if nargin >= 1
    W = varargin{1};
    if (size(W,1)~=1 && size(W,2)~=1)
        error('Input argument 1 has to be a vector.');
    end
end

switch nargin % set default values
    case 1
        dir = 0;
        abs_thresh = repmat(0.5*median(W),length(W),1);
        rel_thresh = 0.5*repmat(sqrt(var(W)),length(W),1);
        descent_thresh = 0.5*rel_thresh;
        tmin = 1;
        tmax = length(W);
    case 2
        abs_thresh = repmat(0.5*median(W),length(W),1);
        rel_thresh = 0.5*repmat(sqrt(var(W)),length(W),1);
        descent_thresh = 0.5*rel_thresh;
        tmin = 1;
        tmax = length(W);
    case 3
        rel_thresh = 0.5*repmat(sqrt(var(W)),length(W),1);
        descent_thresh = 0.5*rel_thresh;
        tmin = 1;
        tmax = length(W);
    case 4
        descent_thresh = 0.5*rel_thresh;
        tmin = 1;
        tmax = length(W);
    case 5
        tmin = 1;
        tmax = length(W);
    case 6
        tmax = length(W);
end

if (dir == 0) % bidirectional peak search
    Pforward =  peaks(W,1,abs_thresh,rel_thresh,descent_thresh,tmin,tmax);
    Pbackward = peaks(W,-1,abs_thresh,rel_thresh,descent_thresh,tmin,tmax);
    P = union(Pforward,Pbackward);
    return;
end
    
dyold = 0;
dy = 0;
rise = 0;               % current amount of ascent during a rising portion of the signal W
riseold = 0;            % accumulated amount of ascent from the last rising portion of W
descent = 0;            % current amount of descent (<0) during a falling portion of the signal W
searching_peak = true;
candidate = 1;
P = [];
switch dir
    case 1
        range = [tmin:tmax-1];
    case -1
        range = [tmax:-1:tmin+1];
end

%%%%%%%%%%%%% DEBUG
%figure(4); hold off; plot(W); hold on; 
%%%%%%%%%%%%% DEBUG

for i=range
    dy = W(i+dir) - W(i);
    if (dy > 0)
        rise = rise + dy;
    elseif (dy < 0)
        descent = descent + dy;
    end
    
    if (dyold > 0)
        if (dy < 0) % slope change positive->negative
            if (rise >= rel_thresh(i) && searching_peak == true)
%%%%%%%%%%%%% DEBUG
%    plot(i,W(i),'red o'); drawnow;
%%%%%%%%%%%%% DEBUG
                candidate = i;
                searching_peak = false;
            end
            riseold = rise;
            rise = 0;
        else %(dy >= 0) % rising
        end
    elseif (dyold < 0)
        if (dy < 0) % in descent
            if (descent <= -rel_thresh(candidate) && searching_peak == false)
                if (W(candidate)>=abs_thresh(candidate))
                    P = [P; candidate];     % verified candidate as true peak
                end
                searching_peak = true;
            end
        elseif (dy > 0) % slope change negative->positive
            if (searching_peak == false) % currently verifying a peak
                if (W(candidate) - W(i) <= descent_thresh(i)) 
                    rise = riseold + descent; % skip intermediary peak
                end
                if (descent <= -rel_thresh(candidate))
                    if (W(candidate)>=abs_thresh(candidate))
                        P = [P; candidate];     % verified candidate as true peak
                    end                    
                end
                searching_peak = true;
            end
            descent = 0;
        else % (dy == 0) slope change negative->stationary    
            if (searching_peak == false) % currently verifying a peak
                if (descent <= -rel_thresh(candidate))
                    if (W(candidate)>=abs_thresh(candidate))
                        P = [P; candidate];     % verified candidate as true peak
                    end                    
                    searching_peak = true;
                    descent = 0;
                end
            end
        end
    else % (dyold == 0) % stationary
        if (dy > 0) % slope change stationary->positive
            if (searching_peak == false) % currently verifying a peak
                if (W(candidate) - W(i) <= descent_thresh(i)) 
                    rise = riseold + descent; % skip intermediary peak
                end
                if (descent <= -rel_thresh(candidate))
                    if (W(candidate)>=abs_thresh(candidate))
                        P = [P; candidate];     % verified candidate as true peak
                    end                    
                end
                searching_peak = true;
            end
            descent = 0;
        elseif (dy < 0) % slope change stationary->negative
            if (rise >= rel_thresh(i) && searching_peak == true)
                candidate = i;
                searching_peak = false;
            end
            riseold = rise;
            rise = 0;
        end
    end
    dyold = dy;
end
