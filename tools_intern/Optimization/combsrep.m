function y = combsrep(v, k)
%COMBSREP Combinations with replacement.
%
% COMBSREP(V, K) where V is a vector of length N, produces a matrix with 
% (N+K-1)!/K!(N-1)! (i.e., "N+K-1 choose K") rows and K columns. Each row of 
% the result has K of the elements in the vector V. The vector V may be a 
% vector of any class. If the input is sparse, the output will be sparse. 
% 
% COMBSREP(V, K) lists all possible ways to pick K elements out of the vector 
% V, with replacement, but where the order of the K elements is irrelevant.


% Author: Peter J. Acklam
% Time-stamp: 2003-08-22 08:00:51 +0200
% E-mail: pjacklam@online.no
% URL: http://home.online.no/~pjacklam


   error(nargchk(2, 2, nargin));


   if sum(size(v) > 1) > 1
      error('First argument must be a vector.');
   end


   if any(size(k) ~= 1) | (k ~= round(k)) | (k < 0)
      error('Second argument must be a scalar.');
   end


   if k == 0
      y = zeros(0, k);
   elseif k == 1
      y = v;
   else
      v = v(:);
      y = [];
      m = length(v);
      if m == 1
         y = v(1, ones(k, 1));
      else
         for i = 1 : m
            y_recr = combsrep(v(i:end), k-1);
            s_repl = v(i);
            s_repl = s_repl(ones(size(y_recr, 1), 1), 1);
            y = [ y ; s_repl, y_recr ];
         end
      end
   end