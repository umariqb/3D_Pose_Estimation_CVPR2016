function showsummary(gr,h_level)

% SHOWSUMMARY displays basic information on the groups.
% ------------------------
% showsummary(gr, h_level)
% ------------------------
% Description: displays basic information on the groups.
% Input:       {gr} grouping instance.
%              <{h_level}> hierarchy level (def=1).

% © Liran Carmel
% Classification: Display functions
% Last revision date: 04-Jul-2004

% parse input line
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    h_level = 1;
else
    error(chkvar(h_level,'integer',...
        {'scalar',{'eqlower',nohierarchies(gr)},{'greaterthan',0}},...
        {mfilename,inputname(2),2}));
end

% calculate column width
gs = groupsize(gr,h_level);
w_gcn = max(floor(log10(nogroups(gr,h_level))) + 3, 5);
w_gid = max(floor(log10(max(gr.gcn2gid{h_level}))) + 3, 5);
w_gs = max(floor(log10(max(gs))) + 3,6);

% display titles
l_spc = floor((w_gcn-3)/2);    % length of spaces before GCN
str1 = sprintf('%sGCN',char(32*ones(1,l_spc)));
str2 = sprintf('%s---',char(32*ones(1,l_spc)));
l_spc = w_gcn - 3 - l_spc + floor((w_gid-3)/2); % length of spaces between GCN and GID
str1 = sprintf('%s%sGID',str1,char(32*ones(1,l_spc)));
str2 = sprintf('%s%s---',str2,char(32*ones(1,l_spc)));
l_spc = w_gid - 3 - floor((w_gid-3)/2) + floor((w_gs-3)/2); % length of spaces between GID and SIZE
str1 = sprintf('%s%sSIZE',str1,char(32*ones(1,l_spc)));
str2 = sprintf('%s%s----',str2,char(32*ones(1,l_spc)));
l_spc = w_gs - 3 - floor((w_gs-3)/2);   % length of spaces between SIZE and NAME
str1 = sprintf('%s%sNAME',str1,char(32*ones(1,l_spc)));
str2 = sprintf('%s%s----',str2,char(32*ones(1,l_spc)));
disp(str1)
disp(str2)

% display lines
for ii = 1:nogroups(gr,h_level)
    gid = gr.gcn2gid{h_level}(ii);
    r_gcn = w_gcn - floor(log10(ii)) - 2;   % spaces to the right of GCN column
    r_gid = w_gid - floor(log10(gid)) - 2;  % spaces to the right of GID column
    r_gs = w_gs - floor(log10(gs(ii))) - 2; % spaces to the right of SIZE column
    str = sprintf(' %d%s %d%s %d%s %s',ii,char(32*ones(1,r_gcn)),...
        gid,char(32*ones(1,r_gid)),gs(ii),char(32*ones(1,r_gs)),...
        gr.naming{h_level}{ii});
    disp(str)
end