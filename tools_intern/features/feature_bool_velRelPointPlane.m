function f = feature_bool_velRelPointPlane(mot,p1_name,p2_name,p3_name,q_name,varargin)
% function f = feature_bool_velRelPointPlane(mot,p1_name,p2_name,p3_name,q_name,varargin)
%
% optional parameters: thresh_s ....... relative to humerus length; 
%                                       global absolute threshold for area under the velocity curve 
%                                       (interpretation: distance traveled during a time window)
%                                       default: 1 humerus length
% optional parameters: thresh_v ....... relative to humerus length; 
%                                       global absolute threshold for maximum of velocity curve within a time window
%                                       default: 2 humerus lengths/sec
%                      win_len_ms ...   window length in milliseconds for smoothing of 3D trajectories
% 
% NOTES: - Last velocity value is duplicated to maintain the length of the input sequence.
%        - Choosing win_len_ms<=1000/samplingRate amounts to no averaging at all.

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lelbow')}(:,1)).^2));
thresh_s = 1;
if (nargin>5)
    thresh_s = varargin{1};
end
thresh_v = 2;
if (nargin>6)
    thresh_v = varargin{2};
end
win_len_ms = 250;
if (nargin>7)
    win_len_ms = varargin{3};
end

v = feature_velRelPointPlane(mot,p1_name,p2_name,p3_name,q_name,win_len_ms);
b = v>0;

d = diff([0 b 0]);              % zero padding to enforce ramps at beginning/end
ramps_up = find(d==1);          % positions of upward zero crossings of v
ramps_dn = find(d==-1)-1;       % positions of downward zero crossings of v; 
                                % subtract 1 to account for shift induced by zero-padding 

V = cumsum(v)*mot.frameTime; % approx. antiderivative of v. (interpretation: distance travelled since t=0)
A = V(ramps_dn) - V(ramps_up); % interpretation: distance travelled between t=ramps_up and t=ramps_down

I = zeros(1,length(ramps_up));
k = 1;
for i=1:length(ramps_up)
    if (max(v(ramps_up(i):ramps_dn(i))) >= thresh_v*humerus_length & A(i) >= thresh_s*humerus_length)
        I(k) = i;
        k = k+1;
    end
end
I = I(1:k-1);
ramps_up = ramps_up(I);
ramps_dn = ramps_dn(I);

b = zeros(1,length(b));
b(ramps_up) = 1;
b(ramps_dn) = -1;

f = cumsum(b);



