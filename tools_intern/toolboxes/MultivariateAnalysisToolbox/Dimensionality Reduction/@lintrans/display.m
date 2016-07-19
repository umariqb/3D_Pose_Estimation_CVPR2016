function display(lt)    %#ok

% DISPLAY displays class content.
% -----------
% display(lt)
% -----------
% Description: display method for the LINTRANS class.
% Input:       {lt} LINTRANS instance(s).

% © Liran Carmel
% Classification: Display functions
% Last revision date: 18-Jan-2005

% constant indentations
PRIMARY_IDENT = 4;
SECONDARY_IDENT = 7;
WIDTH = 80;

% display title
disp(' ');
disp([inputname(1),' = '])
disp(' ');

% use different displays when {lt} is scalar and when it is not
if isscalar(lt)
    if isempty(lt) || ~nofactors(lt)  % default instance
        disp('   Empty linear transformation')
    else   % non-default instance
        % display name of LINTRANS
        disp(sprintf('Linear transformation (%s):',get(lt,'type')));
        % display information on the factors and variables
        cmd = sprintf('matlab: %s.factorset',inputname(1));
        if nofactors(lt) == 1
            hypertext = 'factor';
        else
            hypertext = 'factors';
        end
        str = sprintf('%sCOMPOSITION: %d <a href="%s">%s</a>',...
            blanks(PRIMARY_IDENT),nofactors(lt),cmd,hypertext);
        cmd = sprintf('matlab: %s.variableset',inputname(1));
        str = sprintf('%s; %d <a href="%s">variables</a>',...
            str,novariables(lt),cmd);
        disp(str);
    end
else    % if a vector of matrices should be displayed
    for ii = 1:length(lt)
        str = sprintf('(%d)',ii);
        if nofactors(lt(ii)) == 0   % default instance
            str = sprintf('%s Empty linear transformation',str);
        else                        % non-default instance
            % display name of LINTRANS
            str = sprintf('%s %s (%s):',str,lt(ii).name,lt(ii).type);
            % display factors and variables information
            str = sprintf('%s: %d factors; %d variables',...
                str,nofactors(lt),novariables(lt));
        end
        disp(str);
    end
end
disp(' ');