function display(ssm)

% DISPLAY displays class content.
% ------------
% display(ssm)
% ------------
% Description: display method for the SSMATRIX class.
% Input:       {ssm} variable instance(s).

% © Liran Carmel
% Classification: Display functions
% Last revision date: 12-Jan-2005

% constant indentations
PRIMARY_IDENT = 4;
SECONDARY_IDENT = 7;
WIDTH = 80;

% display title
disp(' ');
disp([inputname(1),' = '])
disp(' ');

% use different displays when {ssm} is scalar and when it is not
if isscalar(ssm)
    if isempty(ssm) || isempty(get(ssm,'matrix'))       % default instance
        disp('   Empty ssmatrix instance')
    else                                                % non-default instance
        % display name of SSMATRIX
        disp(sprintf('%s (%s matrix):',get(ssm,'name'),get(ssm,'type')));
        % display rows and columns information
        str = sprintf('COMPOSITION: %d %s x %d %s',get(ssm,'no_rows'),...
            get(ssm,'row_type'),get(ssm,'no_cols'),get(ssm,'col_type'));
        disptext(str,WIDTH,PRIMARY_IDENT,SECONDARY_IDENT);
        % display modifications
        if ~isempty(get(ssm,'modifications'))
            str = 'MODIFICATIONS: raw';
            for ii = 1:length(ssm.modifications)
                str = sprintf('%s -> %s',str,ssm.modifications(ii).name);
            end
            disptext(str,WIDTH,PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % display description
        if ~isempty(get(ssm,'description'))
            disptext(sprintf('DESCRIPTION: %s',get(ssm,'description')),...
                WIDTH,PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % display source
        if ~isempty(get(ssm,'source'))
            disptext(sprintf('SOURCE: %s',get(ssm,'source')),WIDTH,...
                PRIMARY_IDENT,SECONDARY_IDENT);
        end
    end
else    % if a vector of matrices should be displayed
    for ii = 1:length(ssm)
        str = sprintf('(%d)',ii);
        if isempty(ssm(ii).matrix)              % default instance
            str = sprintf('%s Empty matrix',str);
        else                                 % non-default instance
            % display name of matrix
            if ~isempty(ssm(ii).name)
                str = sprintf('%s %s:',str,ssm(ii).name);
            end
            % display modifications
            if ~isempty(ssm(ii).modifications)
                modif = '(modified) ';
            else
                modif = [];
            end
            % display rows and columns information
            str = sprintf('%s %s matrix %s (%d %s x %d %s)',str,ssm.type,...
                modif,ssm.no_rows,ssm.row_type,ssm.no_cols,ssm.col_type);
        end
        disp(str)
    end
end
disp(' ');