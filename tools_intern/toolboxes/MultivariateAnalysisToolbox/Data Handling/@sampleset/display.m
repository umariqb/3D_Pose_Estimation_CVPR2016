function display(ss)

% DISPLAY displays class content.
% -----------
% display(ss)
% -----------
% Description: display method for the sampleset class.
% Input:       {ss} sampleset instance(s).

% © Liran Carmel
% Classification: Display functions
% Last revision date: 07-Oct-2004

% display title
disp(' ');
disp([inputname(1),' = '])
disp(' ');

% use different displays when {ss} is scalar and when it is not
if isscalar(ss)        % {ss} is scalar
    % discriminate between empty instance and nonempty one
    if ~ss.no_samples
        disp('   Empty sampleset instance')
    else
        % display name of sampleset, which is the base for future alignment
        str = sprintf('%s (sampleset)',ss.name);
        indent = length(str) + 2;
        % add information on the number of samples
        disp(sprintf('%s: COMPOSITION: %d samples',str,ss.no_samples));
        % display description
        if ~isempty(ss.description)
            disptext(sprintf('DESCRIPTION: %s',ss.description),80,...
                indent,indent+3);
        end
        % display source
        if ~isempty(ss.source)
            disptext(sprintf('SOURCE: %s',ss.source),80,...
                indent,indent+3);
        end
    end
else                % {ss} is a multiplicity of instances
    for ii = 1:length(ss)
        str = sprintf('matlab: %s(%d)',inputname(1),ii);
        str = sprintf('(<a href="%s">%d</a>)',str,ii);
        if ~ss(ii).no_samples       % default instance
            str = sprintf('%s Empty sampleset instance',str);
        else                        % non-default instance
            % display name of sampleset
            str = sprintf('%s %s (sampleset):',str,ss(ii).name);
            % display number of samples
            str = sprintf('%s %d samples',str,ss(ii).no_samples);
        end
        disp(str)
    end
end
disp(' ');