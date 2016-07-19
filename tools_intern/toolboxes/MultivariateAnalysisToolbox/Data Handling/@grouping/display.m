function display(gr)

% DISPLAY displays class content.
% -----------
% display(gr)
% -----------
% Description: display method for the grouping class.
% Input:       {gr} grouping instance(s).

% © Liran Carmel
% Classification: Display functions
% Last revision date: 03-Dec-2004

% display title
disp(' ');
disp([inputname(1),' = '])
disp(' ');

% use different displays when {gr} is scalar and when it is not
if isscalar(gr)        % {gr} is scalar
    % discriminate between empty instance and nonempty one
    if ~gr.no_hierarchies
        disp('   Empty grouping instance')
    else
        % display name of grouping
        disp(sprintf('%s (grouping)',gr.name));
        % display information on composition
        no_samples = nosamples(gr);
        no_knowns = noknowns(gr);
        str = sprintf('%d hierarchies; %d/%d known',...
            gr.no_hierarchies,no_knowns,no_samples);
        str = sprintf('%s samples (%.2f%% unknowns)',str,...
            100*(no_samples-no_knowns)/no_samples);
        disptext(sprintf('COMPOSITION: %s',str),80,3,6);
        % display hierarchies information
        for level = 1:gr.no_hierarchies
            if gr.is_consistent(level)
                msg = 'consistent';
            else
                msg = 'inconsistent';        
            end
            disptext(sprintf('HIERARCHY #%d (%s): %d groups',level,msg,...
                gr.no_groups(level)),80,6,8);
        end
        % display description
        if ~isempty(gr.description)
            disptext(sprintf('DESCRIPTION: %s',gr.description),80,3,6);
        end
        % display source
        if ~isempty(gr.source)
            disptext(sprintf('SOURCE: %s',gr.source),80,3,6);
        end
    end
else                % {gr} is a multiplicity of instances
    for ii = 1:length(gr)
        str = sprintf('matlab: %s(%d)',inputname(1),ii);
        str = sprintf('(<a href="%s">%d</a>)',str,ii);
        if ~gr(ii).no_hierarchies       % default instance
            str = sprintf('%s Empty grouping instance',str);
        else                        % non-default instance
            % display name of grouping
            str = sprintf('%s %s (grouping)',str,gr(ii).name);
            % display hierarchy level and number of samples
            no_samples = nosamples(gr(ii));
            no_knowns = noknowns(gr(ii));
            str = sprintf('%s: %d hierarchies; %d/%d known',...
                str,gr(ii).no_hierarchies,no_knowns,no_samples);
            str = sprintf('%s samples (%.2f%% unknowns)',str,...
                100*(no_samples-no_knowns)/no_samples);
        end
        disp(str)
    end
end
disp(' ');