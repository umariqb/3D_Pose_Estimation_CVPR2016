function display(vr)

% DISPLAY displays class content.
% -----------
% display(vr)
% -----------
% Description: display method for the VARIABLE class.
% Input:       {vr} variable instance(s).

% © Liran Carmel
% Classification: Display functions
% Last revision date: 05-May-2006

% constant indentations
PRIMARY_IDENT = 4;
SECONDARY_IDENT = 7;
WIDTH = 80;

% display title
disp(' ');
disp([inputname(1),' = '])
disp(' ');

% use different displays when {vr} is scalar and when it is not
if isscalar(vr)
    if isempty(vr) || ~vr.no_samples       % default instance
        disp('   Empty variable instance')
    else                    % non-default instance
        % display name
        fprintf(1,'%s: ',vr.name);
        % display level
        if strcmp(vr.level,'unknown')
            fprintf(1,'variable of unknown level ');
        else
            fprintf(1,'%s variable ',vr.level);
        end
        % display units
        if ~isempty(vr.units)
            fprintf(1,'[%s]',vr.units);
        end
        fprintf(1,'\n');
        % add information on samples
        str = sprintf('COMPOSITION: %d/%d known samples',...
            vr.no_samples-vr.no_missing,vr.no_samples);
        str = sprintf('%s (%.2f%% missing)',str,...
            100*vr.no_missing/vr.no_samples);
        disptext(str,WIDTH,PRIMARY_IDENT,SECONDARY_IDENT);
        % display transformation history
        if ~isempty(vr.transformations)
            str = 'TRANSFORMATIONS: raw';
            for ii = 1:length(vr.transformations)
                str = sprintf('%s -> %s',str,vr.transformations(ii).name);
            end
            disptext(str,WIDTH,PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % display description
        if ~isempty(vr.description)
            disptext(sprintf('DESCRIPTION: %s',vr.description),WIDTH,...
                PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % display source
        if ~isempty(vr.source)
            disptext(sprintf('SOURCE: %s',vr.source),WIDTH,...
                PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % add table
        DATA_WIDTH = 14;
        PROP_WIDTH = 10;
        disptext(char(173*ones(1,42)),WIDTH,PRIMARY_IDENT);
        str = sprintf('|%s|%s|%s|',fitword('property',PROP_WIDTH),...
            fitword('population',DATA_WIDTH),fitword('sample',DATA_WIDTH));
        disptext(str,WIDTH,PRIMARY_IDENT);
        disptext(char(173*ones(1,42)),WIDTH,PRIMARY_IDENT);
        % display first line
        str = sprintf('|%s|',fitword('min',PROP_WIDTH));
        entry = vr.minmax.population(1);
        if isnan(entry)
            entry = 'unknown';
        else
            entry = num2str(entry);
        end
        str = sprintf('%s%s|%s|',str,fitword(entry,DATA_WIDTH),...
            fitword(num2str(vr.minmax.sample(1)),DATA_WIDTH));
        disptext(str,WIDTH,PRIMARY_IDENT);
        % display second line
        str = sprintf('|%s|',fitword('max',PROP_WIDTH));
        entry = vr.minmax.population(2);
        if isnan(entry)
            entry = 'unknown';
        else
            entry = num2str(entry);
        end
        str = sprintf('%s%s|%s|',str,fitword(entry,DATA_WIDTH),...
            fitword(num2str(vr.minmax.sample(2)),DATA_WIDTH));
        disptext(str,WIDTH,PRIMARY_IDENT);
        % display third line
        str = sprintf('|%s|',fitword('mean',PROP_WIDTH));
        entry = vr.mean.population;
        if isnan(entry)
            entry = 'unknown';
        else
            entry = num2str(entry);
        end
        str = sprintf('%s%s|%s|',str,fitword(entry,DATA_WIDTH),...
            fitword(num2str(vr.mean.sample),DATA_WIDTH));
        disptext(str,WIDTH,PRIMARY_IDENT);      
        % display fourth line
        str = sprintf('|%s|',fitword('variance',PROP_WIDTH));
        entry = vr.variance.population;
        if isnan(entry)
            entry = 'unknown';
        else
            entry = num2str(entry);
        end
        str = sprintf('%s%s|%s|',str,fitword(entry,DATA_WIDTH),...
            fitword(num2str(vr.variance.sample),DATA_WIDTH));
        disptext(str,WIDTH,PRIMARY_IDENT);
        % finish table
        disptext(char(173*ones(1,42)),WIDTH,PRIMARY_IDENT);
    end
else    % if a vector of variables should be displayed
    for ii = 1:length(vr)
        str = sprintf('matlab: %s(%d)',inputname(1),ii);
        str = sprintf('(<a href="%s">%d</a>)',str,ii);
        if ~vr(ii).no_samples       % default instance
            str = sprintf('%s Empty variable instance',str);
        else                        % non-default instance
            % display name and level of variable
            if strcmp(vr(ii).level,'unknown')
                str = sprintf('%s %s (variable of unknown level)',...
                    str,vr(ii).name);
            else
                str = sprintf('%s %s (%s variable)',...
                    str,vr(ii).name,vr(ii).level);
            end
            % add information on samples
            str = sprintf('%s: %d/%d known samples, (%.2f%% missing)',...
                str,vr(ii).no_samples-vr(ii).no_missing,...
                vr(ii).no_samples,100*vr(ii).no_missing/vr(ii).no_samples);
        end
        disp(str)
    end
end
disp(' ');