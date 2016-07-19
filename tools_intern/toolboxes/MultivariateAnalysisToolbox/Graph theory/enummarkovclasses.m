function enumdagcodes(code,un,s,func)

% ENUMDAGCODES enumerates all DAG codes for a fixed number of nodes.
% -------------------------------
% enumdagcodes(code, un, s, func)
% -------------------------------
% Description: code is the cell array A_1, ..., A_{n-1}. This function
%              assumes that A_1, ..., A_{s-1} are already constructed and
%              that un=union_{i=1}^{s-1} A_i. Then, it enumerates all (A_s,
%              ..., A_{n-1}) such that (A_1, ..., A_{n-1}) is a DAG code.
%              To enumerate all DAGs with n vertices, simply use
%              ENUMDAGCODES(cell(1,n-1),[],1,func). 
%              Taken from Steinsky B. (2003) Soft. Computing 7: 350-356,
%              Algorithm 5.
% Input:       {code} explained in Description.
%              {un} explained in Description.
%              {s} explained in Description.
%              <{func}> each computed code is sent to a function whose
%                   handle is {func}. If missing, the code is simply
%                   displayed on screen.

% © Liran Carmel
% Classification: Computations
% Last revision date: 20-Mar-2008

% parse input
if nargin < 4
    func = @dispdagcode;
end

% initialize
n = length(code) + 1;
cardUn = length(un);
if cardUn == s
    return;
end

% main loop
if s < n
    for ii = 0:(2^cardUn-1)
        X = un(lexrank2subset(ii,length(un)));
        for kk = 0:(n-cardUn-1)
            for jj = 0:(nchoosek(n-cardUn,kk)-1)
                tmpS = allbut(un,n);
                tmpS = tmpS(lexrank2ksubset(jj,kk,length(tmpS)));
                code{s} = union(X,tmpS);
%                fprintf('\ts=%d; |un|=%d; ii=%d; kk=%d; jj=%d\n',s,cardUn,ii,kk,jj);
                enumdagcodes(code,union(un,code{s}),s+1,func);
            end
        end
    end
else
    func(code);
end