function [assignment, naming] = group(list)

% GROUP turns a list into assignment vector and naming cell array.
% ---------------------------------
% [assignment naming] = group(list)
% ---------------------------------
% Description: takes a list of names associated with samples, and compiles
%              the corresponding assignment vector and naming cell array.
% Input:       {list} cell array of any data type, as long as each cell
%                   contains a scalar element.
% Output:      {assignment} assignment vector.
%              {naming} naming cell array.
% Comment:     low-level function -> no input verification.

% © Liran Carmel
% Classification: Friends of grouping
% Last revision date: 09-Dec-2004

% get number of samples
no_samples = length(list);

% initialize
naming = [];
assignment = zeros(1,no_samples);

% discriminate between character list and numerical list
if isa(list{1},'char')  % character list
    not_assigned = 1:no_samples;    % entries not yet assigned
    gid = 0;                        % current group ID
    while ~isempty(not_assigned)
        % assign new group name and ID
        naming = [naming list(not_assigned(1))];
        gid = gid + 1;
        % find all entries that has that name, and assign to them {gid}.
        assignment(strcmp(list,list{not_assigned(1)})) = gid;
        % update {not_assigned}
        not_assigned = find(~assignment);
    end
else                    % numerical list
    not_assigned = 1:no_samples;    % entries not yet assigned
    gid = 0;                        % current group ID
    % turn list into a vector array
    list = cell2mat(list);
    % perform the task
    while ~isempty(not_assigned)
        % assign new group name and ID
        naming = [naming {num2str(list(not_assigned(1)))}];
        gid = gid + 1;
        % find all entries that has that name, and assign to them {gid}.
        assignment(list==list(not_assigned(1))) = gid;
        % update {not_assigned}
        not_assigned = find(~assignment);
    end
end

