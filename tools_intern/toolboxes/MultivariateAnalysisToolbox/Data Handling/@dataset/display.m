function display(ds)

% DISPLAY displays class content.
% -----------
% display(ds)
% -----------
% Description: display method for the VARIABLE class.
% Input:       {ds} dataset instance(s).

% © Liran Carmel
% Classification: Display functions
% Last revision date: 05-Jan-2005

% constant indentations
PRIMARY_IDENT = 4;
SECONDARY_IDENT = 7;
WIDTH = 80;

% display title
disp(' ');
disp([inputname(1),' = '])
disp(' ');

% use different displays when {ds} is scalar and when it is not
if isscalar(ds)
    if ~ds.no_samplesets     % default instance
        disp('   Empty dataset instance')
    else                    % non-default instance
        % display name of dataset
        disp(sprintf('%s (dataset)',ds.name));
        % add information on samplesets
        if ds.no_samplesets == 1
            hypertext = 'sampleset';
        else
            hypertext = 'samplesets';
        end
        cmd = sprintf('matlab: %s.samplesets',inputname(1));
        str = sprintf('%sCOMPOSITION: %d <a href="%s">%s</a>',...
            blanks(PRIMARY_IDENT),ds.no_samplesets,cmd,hypertext);
        % add information on variables
        no_vars = novariables(ds);
        if no_vars == 1
            hypertext = 'variable';
        else
            hypertext = 'variables';
        end
        cmd = sprintf('matlab: %s.variables',inputname(1));
        str = sprintf('%s; %d <a href="%s">%s</a>',...
            str,no_vars,cmd,hypertext);
        % add information on groupings
        if ds.no_groupings == 1
            hypertext = 'grouping';
        else
            hypertext = 'groupings';
        end
        cmd = sprintf('matlab: %s.groupings',inputname(1));
        str = sprintf('%s; %d <a href="%s">%s</a>',...
            str,ds.no_groupings,cmd,hypertext);
        disp(str);
        % display description
        if ~isempty(ds.description)
            disptext(sprintf('DESCRIPTION: %s',ds.description),WIDTH,...
                PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % display source of variable
        if ~isempty(ds.source)
            disptext(sprintf('SOURCE: %s',ds.source),WIDTH,...
                PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % display variable statistics
        if novariables(ds)
            str = sprintf('VARIABLE STATISTICS: %d nominal',...
                ds.no_variables(1));
            str = sprintf('%s, %d ordinal, %d numerical',str,...
                ds.no_variables(2),ds.no_variables(3));
            str = sprintf('%s, %d unknown',str,ds.no_variables(4));
            disptext(str,WIDTH,PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % display matrices information
        if ds.no_matrices
            disptext(sprintf('EXTERNAL MATRICES: %d matrices',...
                ds.no_matrices),WIDTH,PRIMARY_IDENT,SECONDARY_IDENT);
        end
    end
else    % if a vector of datasets should be displayed
    for ii = 1:length(ds)
        str = sprintf('(%d)',ii);
        if ~ds(ii).no_samplesets       % default instance
            str = sprintf('%s Empty dataset instance',str);
        else                        % non-default instance
            % display name of dataset
            str = sprintf('%s %s (dataset):',str,ds(ii).name);
            % add information on variables and samples
            str = sprintf('%s: %d samplesets; %d variables; %d groupings',...
                str,ds.no_samplesets,novariables(ds),ds.no_groupings);
        end
        disp(str)
    end
end
disp(' ');