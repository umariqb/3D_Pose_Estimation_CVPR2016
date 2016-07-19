function ds = plus(ds,operand)

% PLUS adds samplesets, variables and groupings to a dataset.
% ----------------------
% ds = plus(ds, operand)
% ----------------------
% Description: adds samplesets, variables and groupings to a dataset.
% Input:       {ds} dataset instance.
%              {operand} vector of samplesets, variables, groupings or
%                   other datasets.
% Output:      {ds} enlarged dataset instance.

% © Liran Carmel
% Classification: Operators
% Last revision date: 01-Dec-2004

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(ds,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(operand,{'sampleset','variable','grouping','dataset'},...
    'vector',{mfilename,inputname(2),2}));

% switch according to the operand type
if isa(operand,'sampleset')
    ds = set(ds,'samplesets',[ds.samplesets operand],...
        'no_samplesets',ds.no_samplesets + length(operand));
elseif isa(operand,'variable')
    % update no_variables
    no_vars = ds.no_variables;
    for jj = 1:length(operand)
        vr = instance(operand,num2str(jj));
        switch vr.level
            case 'nominal'
                no_vars = no_vars + [1 0 0 0 1];
            case 'ordinal'
                no_vars = no_vars + [0 1 0 0 1];
            case 'numerical'
                no_vars = no_vars + [0 0 1 0 1];
            case 'unknown'
                no_vars = no_vars + [0 0 0 1 1];
        end
    end
    % substitute new variables
    which_var = novariables(ds);
    ds.variables = [ds.variables operand];
    ds.no_variables = no_vars;
    % update var2sampset field
    which_var = (which_var+1):novariables(ds);
    v2s = guessvar2sampset(ds,which_var);
    ds.var2sampset = [ds.var2sampset v2s];
elseif isa(operand,'grouping')
    % update groupings
    which_grp = ds.no_groupings;
    ds.groupings = [ds.groupings operand];
    ds.no_groupings = length(ds.groupings);
    % update grp2sampset field
    which_grp = (which_grp+1):ds.no_groupings;
    g2s = guessgrp2sampset(ds,which_grp);
    ds.grp2sampset = [ds.grp2sampset g2s];
else
    % verify a single dataset
    error(chkvar(operand,{},'scalar',{mfilename,inputname(2),2}));
    % update variables
    no_vars = ds.no_variables;
    for jj = 1:novariables(operand)
        vr = instance(operand.variables,num2str(jj));
        switch vr.level
            case 'nominal'
                no_vars = no_vars + [1 0 0 0 1];
            case 'ordinal'
                no_vars = no_vars + [0 1 0 0 1];
            case 'numerical'
                no_vars = no_vars + [0 0 1 0 1];
            case 'unknown'
                no_vars = no_vars + [0 0 0 1 1];
        end
    end
    ds.variables = [ds.variables operand.variables];
    ds.no_variables = no_vars;
    % update groupings
    ds.groupings = [ds.groupings operand.groupings];
    ds.no_groupings = length(ds.groupings);
    % update samplesets and fields 'var2sampset', 'grp2sampset'. Some of
    % the samplesets of {operand} are novel, and some can be matched to
    % samplesets of {ds}
    no_ss = nosamplesets(ds);
    ss = samplesets(operand);
    v2s = operand.var2sampset;
    g2s = operand.grp2sampset;
    ss_novel = [];              % list of novel samplesets
    map = zeros(1,length(ss));  % map {operand} samplesets into their new IDs in {ds}
    for ii = 1:length(ss)
        % instantiate
        ssii = instance(ss,num2str(ii));
        % check matching
        idx = find(ds.samplesets == ssii);
        if isempty(idx) % {ssii} is novel
            no_ss = no_ss + 1;
            ss_novel = [ss_novel ssii];
            map(ii) = no_ss;
        else    % {ssii} is not novel
            map(ii) = idx;
        end
    end
    ds.samplesets = [ds.samplesets ss_novel];
    ds.no_samplesets = no_ss;
    ds.var2sampset = [ds.var2sampset substitute(v2s,1:length(ss),map)];
    ds.grp2sampset = [ds.grp2sampset substitute(g2s,1:length(ss),map)];
end