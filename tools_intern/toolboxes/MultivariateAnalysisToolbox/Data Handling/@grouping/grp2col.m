function [col, g_col] = grp2col(gr,h_level)

% GRP2COL generates group-dependent color indices.
% ----------------------------------
% [col g_col] = grp2col(gr, h_level)
% ----------------------------------
% Description: generates group-dependent color indices.
% Input:       {gr} grouping instance.
%              <{h_level}> hierarchy level (def=1).
% Output:      {col} vector of color indices (of samples).
%              {g_col} vector of color indices (of groups).

% © Liran Carmel
% Classification: Coloring and colormaps
% Last revision date: 14-Jun-2004

% parse input line
error(nargchk(1,2,nargin));
if ~gr.no_hierarchies
    error('%s: %s is an empty grouping instance',mfilename,inputname(1));
end
if nargin == 1
    h_level = 1;
else
    error(chkvar(h_level,'integer',{'scalar',{'eqlower',gr.no_hierarchies}},...
        {mfilename,inputname(2),2}));
end

% find colors vector
nog = gr.no_groups(h_level);
if nog == 1
   delta = 1;
else
   delta = 1 / (nog - 1);
end
col = delta * (gr.assignment(h_level,:) - 1);
g_col = delta * (0:nog-1);