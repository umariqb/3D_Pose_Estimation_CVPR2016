function r = randnp(varargin)

% RANDNP draws random variables from a p-dimensional normal distribution.
% ---------------------------------
% r = randnp(no_samp, dim, mu, sig)
% ---------------------------------
% Description: draws random variables from a p-dimensional normal distribution.
% Input:       {no_samp} the number of random variables to draw.
%              {dim} the dimension of the space.
%              <{mu}> the distribution mean {dim}-vector (def = 0).
%              <{sig}> the distribution covariance {dim}-by-{dim} matrix (def = I).
% Output:      {r} is the resulting {dim}-by-{no_samp} matrix.

% © Liran Carmel
% Classification: Random numbers
% Last revision date: 15-Jul-2004

% parse input
[no_samp dim mu sig] = parse_input(varargin{:});

% initialize 
r = zeros(dim,no_samp);

% find principal axes and directions
[p_direct p_axes] = eig(sig);
p_axes = diag(p_axes);
if any(p_axes < 0)
   error('Covariance matrix is not positive definite.');
elseif any(p_axes == 0)
   warning('Covariance matrix is positive semi-definite.');
else
   p_axes = sqrt(p_axes);
end

% draw centered unrotated samples
for ii = 1:dim
   r(ii,:) = p_axes(ii)*randn(1,no_samp);
end

% rotate and translate the data
r = mu*ones(1,no_samp) + p_direct'*r;

% #########################################################################
function [no_samp, dim, mu, sig] = parse_input(varargin)

% PARSE_INPUT parses input line.
% --------------------------------------------
% [no_samp dim mu sig] = parse_input(varargin)
% --------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {no_samp} number of requested random variables.
%              {dim} the dimension of the space.
%              {mu} the distribution mean vector.
%              {sig} the distribution covariance matrix.

% check number of input arguments
error(nargchk(2,4,nargin));

% first two parameters are fixed
no_samp = varargin{1};
error(chkvar(no_samp,'integer',{'scalar',{'greaterthan',0}},...
    {mfilename,'',1}));
dim = varargin{2};
error(chkvar(dim,'integer',{'scalar',{'greaterthan',0}},...
    {mfilename,'',2}));

% defaults
mu = zeros(dim,1);
sig = eye(dim);

% loop on other arguments
for ii = 3:nargin
   argt = varargin{ii};
   if any(size(argt) == 1)		% mu
      mu = argt;
      error(chkvar(mu,'numerical',{'vector',{'length',dim}},...
          {mfilename,'',ii}));
   else
      sig = argt;
      error(chkvar(sig,'numerical',{{'size',[dim dim]},'symm'},...
          {mfilename,'',ii}));
   end
end