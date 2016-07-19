function display(vsm)

% DISPLAY displays class content.
% ------------
% display(vsm)
% ------------
% Description: display method for the vsmatrix class.
% Input:       {vsm} vsmatrix instance(s).

% © Liran Carmel
% Classification: Display functions
% Last revision date: 21-Jul-2006

% constant indentations
PRIMARY_IDENT = 4;
SECONDARY_IDENT = 7;
WIDTH = 80;

% display title
disp(' ');
disp([inputname(1),' = '])
disp(' ');

% use different displays when {vsm} is scalar and when it is not
if isscalar(vsm)
    if isempty(vsm) || ~nosamples(vsm)  % default instance
        disp('   Empty matrix')
    else   % non-default instance
        % display name of vsmatrix
        disp(sprintf('%s (vsmatrix)',get(vsm,'name')));
        % display information on samples, variables and groupings
        cmd = sprintf('matlab: %s.variables',inputname(1));
        if novariables(vsm) == 1
            hypertext = 'variable';
        else
            hypertext = 'variables';
        end
        str = sprintf('%sCOMPOSITION: %d <a href="%s">%s</a>',...
            blanks(PRIMARY_IDENT),novariables(vsm),cmd,hypertext);
        cmd = sprintf('matlab: %s.sampleset',inputname(1));
        str = sprintf('%s x %d <a href="%s">samples</a>',...
            str,nosamples(vsm),cmd);
        if nogroupings(vsm) == 1
            hypertext = 'grouping';
        else
            hypertext = 'groupings';
        end
        cmd = sprintf('matlab: %s.groupings',inputname(1));
        str = sprintf('%s (%d <a href="%s">%s</a>)',...
            str,nogroupings(vsm),cmd,hypertext);
        disp(str);
        % add description
        if ~isempty(get(vsm,'description'))
            disptext(sprintf('DESCRIPTION: %s',get(vsm,'description')),...
                WIDTH,PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % add source
        if ~isempty(get(vsm,'source'))
            disptext(sprintf('SOURCE: %s',get(vsm,'source')),WIDTH,...
                PRIMARY_IDENT,SECONDARY_IDENT);
        end
    end
else    % if a vector of matrices should be displayed
    for ii = 1:length(vsm)
        str = sprintf('(%d)',ii);
        if novariables(vsm(ii))*nosamples(vsm(ii)) == 0   % default instance
            str = sprintf('%s Empty matrix',str);
        else                                 % non-default instance
            % display name of vsmatrix
            str = sprintf('%s %s (vsmatrix)',str,get(vsm(ii),'name'));
            % display rows and columns information
            str = sprintf('%s: %d variables x %d samples',...
                str,novariables(vsm(ii)),nosamples(vsm(ii)));
            if nogroupings(vsm) == 1
                hypertext = 'grouping';
            else
                hypertext = 'groupings';
            end
            str = sprintf('%s (%d %s)',str,nogroupings(vsm(ii)),hypertext);
        end
        disp(str);
    end
end
disp(' ');