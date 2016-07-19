function w = gausswin2(L, a)
%GAUSSWIN Gaussian window.
%   GAUSSWIN(N) returns an N-point Gaussian window.
%
%   GAUSSWIN(N, ALPHA) returns the ALPHA-valued N-point Gaussian
%   window.  ALPHA is defined as the reciprocal of the standard
%   deviation and is a measure of the width of its Fourier Transform.
%   As ALPHA increases, the width of the window will decrease. If omitted,
%   ALPHA is 2.5.
%
%   EXAMPLE:
%      N = 32;
%      wvtool(gausswin(N));
%
%
%   See also CHEBWIN, KAISER, TUKEYWIN, WINDOW.

%   Reference:
%     [1] fredric j. harris [sic], On the Use of Windows for Harmonic
%         Analysis with the Discrete Fourier Transform, Proceedings of
%         the IEEE, Vol. 66, No. 1, January 1978

%   Author(s): P. Costa
%   Copyright 1988-2005 The MathWorks, Inc.
%   $Revision: 1.14.4.4 $  $Date: 2007/12/14 15:04:55 $

error(nargchk(1,2,nargin,'struct'));

% Default value for Alpha
if nargin < 2 || isempty(a),
    a = 2.5;
end

% Check for valid window length (i.e., N < 0)
if L==1
    w=1;
    return
end
% [L,w,trivialwin] = check_order(L);
% if trivialwin, return, end;

% Compute window according to [1]
N = L-1;
n = (0:N)'-N/2;
w = exp(-(1/2)*(a*n/(N/2)).^2);




% [EOF]
