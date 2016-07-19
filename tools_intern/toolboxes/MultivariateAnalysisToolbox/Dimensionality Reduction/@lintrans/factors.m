function vecs = factors(lt, list)

% FACTORS retrieves the factors of the linear transformation.
% ------------------------
% vecs = factors(lt, list)
% ------------------------
% Description: retrieves the factors of the linear transformation.
% Input:       {lt} LINTRANS instance.
%              <{list}> indicates which factors to take. If absent, all
%                   factors are taken.
% Output:      {vecs} factors arranged columnwise.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 04-Feb-2005

% parse input arguments
error(chkvar(lt,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    list = 1:nofactors(lt);
else
    error(chkvar(list,'integer',...
        {'vector',{'greaterthan',0},{'eqlower',nofactors(lt)}},...
        {mfilename,inputname(2),2}));
end

% retrieve factors
vecs = get(lt,'u');
vecs = vecs(:,list);