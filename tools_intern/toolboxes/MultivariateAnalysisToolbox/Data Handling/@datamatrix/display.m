function display(dm)

% DISPLAY displays class content.
% -----------
% display(dm)
% -----------
% Description: display method for the DATAMATRIX class.
% Input:       {dm} datamatrix instance(s).

% © Liran Carmel
% Classification: Display functions
% Last revision date: 04-Jan-2005

% constant indentations
PRIMARY_IDENT = 4;
SECONDARY_IDENT = 7;
WIDTH = 80;

% display title
disp(' ');
disp([inputname(1),' = '])
disp(' ');

% use different displays when {dm} is scalar and when it is not
if isscalar(dm)
    if isempty(dm) || dm.no_rows*dm.no_cols == 0     % default instance
        disp('   Empty matrix')
    else   % non-default instance
        % display name and type of datamatrix
        disp(sprintf('%s: %s matrix',dm.name,dm.type));
        % display rows and columns information
        str = sprintf('COMPOSITION: %d %s x %d %s',dm.no_rows,...
            dm.row_type,dm.no_cols,dm.col_type);
        disptext(str,WIDTH,PRIMARY_IDENT,SECONDARY_IDENT);
        % add description
        if ~isempty(dm.description)
            disptext(sprintf('DESCRIPTION: %s',dm.description),WIDTH,...
                PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % add source
        if ~isempty(dm.source)
            disptext(sprintf('SOURCE: %s',dm.source),WIDTH,...
                PRIMARY_IDENT,SECONDARY_IDENT);
        end
    end
else    % if a vector of matrices should be displayed
    for ii = 1:length(dm)
        str = sprintf('(%d)',ii);
        if ~dm(ii).no_rows*dm(ii).no_cols == 0   % default instance
            str = sprintf('%s Empty matrix',str);
        else                                 % non-default instance
            % display name of matrix
            if ~isempty(dm(ii).name)
                str = sprintf('%s %s:',str,dm(ii).name);
            end
            % display rows and columns information
            str = sprintf('%s %s matrix (%d %s x %d %s)',str,dm.type,...
                dm.no_rows,dm.row_type,dm.no_cols,dm.col_type);
        end
        disp(str)
    end
end
disp(' ');