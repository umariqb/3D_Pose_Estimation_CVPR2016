function scatter(lt)

% SCATTER plots factors versus factors for all data samples
% -----------
% scatter(lt)
% -----------
% Description: scatter plot of factors versus factors.
% Input:       {lt} lintrans instance.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 18-Jan-2005

% see if it is possible to scatter-plot
if isempty(lt.scores)
    error('No scores defined for %s transformation {%s}',lt.type,...
        inputname(1));
else
    scatter(lt.scores)
end