function vsm = fillin(vsm,varargin)

% FILLIN fills missing data.
% ------------------------------------
% vsm = fillin(vsm, algorithm, params)
% ------------------------------------
% Description: fills missing data.
% Input:       {vsm} VSMATRIX instance.
%              {algorithm, params} is a pair of the algorithm name and its
%                   parameters. can be either
%                   1. 'mean' - fills in the mean of the variable. No
%                       additional parameter are needed.
%                   2. 'median' - fills in the median of the variable. No
%                       additional parameter are needed.
% Output:      {vsm} filled VSMATRIX.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 10-Oct-2005

% fill-in missing data
vr = fillin(vsm.variables,varargin{:});

% resubstitute in the vsmatrix
vsm = set(vsm,'variables',vr);