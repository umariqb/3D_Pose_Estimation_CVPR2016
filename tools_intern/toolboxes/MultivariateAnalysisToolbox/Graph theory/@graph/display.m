function display(gr)

% DISPLAY displays class content.
% -----------
% display(gr)
% -----------
% Description: display method for the GRAPH class.
% Input:       {gr} graph instance(s).

% © Liran Carmel
% Classification: Display functions
% Last revision date: 09-Aug-2005

% constant indentations
PRIMARY_IDENT = 4;
SECONDARY_IDENT = 7;
WIDTH = 80;

% display title
disp(' ');
disp([inputname(1),' = '])
disp(' ');

% use different displays when {gr} is scalar and when it is not
if isscalar(gr)
    if isempty(gr) || ~gr.no_nodes   % default instance
        str = sprintf('   Empty %s',gr.type);
        disp(str)
    else                            % non-default instance
        % display name of graph, which is the base for future alignment
        str = sprintf('%s (%s): %d nodes, %d edges',gr.name,gr.type,...
            gr.no_nodes,gr.no_edges);
        disp(str)
        % display description
        if ~isempty(gr.description)
            disptext(sprintf('DESCRIPTION: %s',gr.description),WIDTH,...
                PRIMARY_IDENT,SECONDARY_IDENT);
        end
        % display source
        if ~isempty(gr.source)
            disptext(sprintf('SOURCE: %s',gr.source),WIDTH,...
                PRIMARY_IDENT,SECONDARY_IDENT);
        end 
    end
else    % if a vector of graphs should be displayed
    for ii = 1:length(gr)
        str = sprintf('matlab: %s(%d)',inputname(1),ii);
        str = sprintf('(<a href="%s">%d</a>)',str,ii);
        if ~gr(ii).no_nodes         % default instance
            str = sprintf('%s Empty graph instance',str);
        else                        % non-default instance
            % display name of graph
            str = sprintf('%s %s (%s): %d nodes, %d edges',str,...
                gr(ii).name,gr(ii).type,gr(ii).no_nodes,gr(ii).no_edges);
        end
        disp(str)
    end
end
disp(' ');