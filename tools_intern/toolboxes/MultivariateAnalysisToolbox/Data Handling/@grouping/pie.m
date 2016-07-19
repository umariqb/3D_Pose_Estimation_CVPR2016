function pie(gr,h_level)

% PIE pie plot of the group sizes.
% ----------------
% pie(gr, h_level)
% ----------------
% Description: pie plot of the group sizes.
% Input:       {gr} grouping instance.
%              <{h_level}> hierarchy level (default = 1).

% © Liran Carmel
% Classification: Visualization
% Last revision date: 14-Jun-2004

% parse input line
error(nargchk(1,2,nargin));
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
if nargin < 2
    h_level = 1;
end
error(chkvar(h_level,'integer',{'scalar',{'eqlower',nohierarchies(gr)}},...
    {mfilename,'',2}));

% vector of groups size and group names
gs = groupsize(gr,h_level);
nam = gr.naming{h_level};

% modify names
perc = 100*unit(gs,1);
for ii = 1:length(nam)
    nam{ii} = sprintf('%s (%.2f%%)',nam{ii},perc(ii));
end

% pie plot
pie(gs,nam)
no_samp = size(gr.assignment,2) - nounknowns(gr,h_level);
set(gcf,'name',...
    sprintf('total of %d samples in %d groups',no_samp,nogroups(gr,h_level)));