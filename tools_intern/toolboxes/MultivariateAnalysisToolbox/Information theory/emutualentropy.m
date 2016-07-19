function I = emutualentropy(data,alphabet)

% EMUTUALENTROPY estimates pairwise mutual entropy
% ----------------------------------
% I = emutualentropy(data, alphabet)
% ----------------------------------
% Description: computes mutual entropy for all pairs of variables.
% Input:       {data} a numeric matrix of size {variables}-by-{samples}.
%              {alphabet} a vector of alphabet upon which the variables are
%                   defined. If the alphabet is different for different
%                   variables, this should be a cell with the alphabet
%                   determined separately for each variable.
% Output:      {I} matrix of pairwise mutual entropies.

% © Liran Carmel
% Last revision date: 09-Jan-2008

% parse input
error(nargchk(2,2,nargin));

% get information
[no_variables no_samples] = size(data);

% initialize
I = zeros(no_variables);

% for speed discriminate between the case the the alphabet is common to all
% variables, and the case when it is not
if iscell(alphabet)     % different alphabets for different variables
    % estimating p_i
    pi = cell(1,no_variables);
    for v1 = 1:no_variables
        alphabetsize = length(alphabet{v1});
        pi{v1} = zeros(1,alphabetsize);
        for ii = 1:alphabetsize
            pi{v1}(ii) = sum(data(v1,:)==alphabet{v1}(ii)) / no_samples;
        end
    end
    % compute mutual information
    for v1 = 1:(no_variables-1)
        alphabetsize1 = length(alphabet{v1});
        for v2 = (v1+1):no_variables
            alphabetsize2 = length(alphabet{v2});
            for ii = 1:alphabetsize1
                for jj = 1:alphabetsize2
                    pij = sum(data(v1,:)==alphabet{v1}(ii) & ...
                        data(v2,:)==alphabet{v2}(jj)) / no_samples;
                    I(v1,v2) = I(v1,v2) + pij * ...
                        log( pij / pi{v1}(ii) / pi{v2}(jj) );
                end
            end
            I(v2,v1) = I(v1,v2);
        end
    end
else                    % same alphabet for all variables
    % get size of the alphabet
    alphabetsize = length(alphabet);
    % estimating p_i
    pi = zeros(no_variables,alphabetsize);
    for ii = 1:alphabetsize
        pi(:,ii) = sum(data==alphabet(ii),2) / no_samples;
    end
    % compute mutual information
    for v1 = 1:(no_variables-1)
        for v2 = (v1+1):no_variables
            for ii = 1:alphabetsize
                for jj = 1:alphabetsize
                    pij = sum(data(v1,:)==alphabet(ii) & ...
                        data(v2,:)==alphabet(jj)) / no_samples;
                    I(v1,v2) = I(v1,v2) + pij * ...
                        log( pij / pi(v1,ii) / pi(v2,jj) );
                end
            end
            I(v2,v1) = I(v1,v2);
        end
    end
end