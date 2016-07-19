function feature = feature_bool_footSimLowVel(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures absolute velocities of ltoes/rankle and rtoes/lankle.
% Good candidates for simultaneous floor contacts of lfoot and rfoot.
%
% Feature value 0: Velocity is high
% Feature value 1: Velocity is low
%
% Parameters:
% p ...... GLOBAL threshold for decision whether a velocity is "greater than zero", 
%          relative to maximum velocity.
% wlen ... Window length for windowed minimum computation. Absolute velocities are
%          processed with a sliding window minimum operation in order to stabilize
%          co-occurrences of left/right heel and right/left toe floor contacts.

if (nargin<=1)
    p = 0.1;
    wlen = ceil(mot.samplingRate / 20);
elseif (nargin==2)
    p = varargin{1};
    wlen = ceil(mot.samplingRate / 20);
else
    p = varargin{1};
    wlen = varargin{2};
end

velAbs_ltoes = feature_velAbsPoint(mot,'ltoes',0);
velAbs_lankle = feature_velAbsPoint(mot,'lankle',0);
velAbs_rtoes = feature_velAbsPoint(mot,'rtoes',0);
velAbs_rankle = feature_velAbsPoint(mot,'rankle',0);

m11 = windowMin(velAbs_ltoes,wlen);
m12 = windowMin(velAbs_rankle,wlen);
m21 = windowMin(velAbs_rtoes,wlen);
m22 = windowMin(velAbs_lankle,wlen);
zr = zeros(1,mot.nframes);
x11 = zr; x11(find(m11 <= p*max(m11))) = 1;
x12 = zr; x12(find(m12 <= p*max(m12))) = 1;
x21 = zr; x21(find(m21 <= p*max(m21))) = 1;
x22 = zr; x22(find(m22 <= p*max(m22))) = 1;

feature = or(and(x11,x12), and(x21,x22));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
