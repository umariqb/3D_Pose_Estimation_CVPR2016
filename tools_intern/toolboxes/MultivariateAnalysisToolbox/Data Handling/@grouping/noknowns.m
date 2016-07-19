function no_knowns = noknowns(gr,varargin)

% NOKNOWNS finds the number of samples whos grouping is known.
% ---------------------------------
% no_knowns = noknowns(gr, h_level)
% ---------------------------------
% Description: finds the number of samples whos grouping is known.
% Input:       {gr} a group instance.
%              <{h_level}> hierarchy level.
% Output:      {no_knowns} number of known samples.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 09-Sep-2004

% calculate number of knowns
no_knowns = nosamples(gr) - nounknowns(gr,varargin{:});