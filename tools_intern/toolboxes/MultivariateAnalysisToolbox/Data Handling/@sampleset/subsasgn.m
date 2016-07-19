function ss = subsasgn(ss,S,name)

% SUBSASGN basic indexing method.
% --------------------------
% ss = subsasgn(ss, S, name)
% --------------------------
% Description: Allows for the substitution of names via ().
% Input:       {ss} SAMPLESET instance.
%              {S} standard Matlab reference structure.
%              {name} to be substituted.
% Output:      {ss} the modified SAMPLESET.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 21-Oct-2005

% if {name} is a sampleset
if isa(name,'sampleset')
    switch S(1).type
        case '()'
            ss(S(1).subs{:}) = name;
        case '{}'
            error('{} indexing is undefined for SAMPLESET');
        case '.'
            error('. indexing is undefined for SAMPLESET');
    end
else
    % standard switch
    error(chkvar(ss,{},'scalar',{mfilename,'',1}));
    switch S(1).type
        case '()'
            ss.sample_names{S(1).subs{:}} = name;
        case '{}'
            error('{} indexing is undefined for SAMPLESET');
        case '.'
            error('. indexing is undefined for SAMPLESET');
    end
end