function [res,norm] = normalizeColumns(A,varargin)

switch nargin
   case 1
      delnan = false;
   case 2
      delnan = varargin{1};
   otherwise
      error('Wrong num of args!');
end

norm    = sqrt(sum((A.^2),1));
res     = A./norm(ones(1,size(A,1)),:);

if delnan
   res(isnan(res))=0;
end