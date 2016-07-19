function indicator = isconsistent(gr,h_level)

% ISCONSISTENT query about the consistency of the GROUPING instance.
% -------------------------------------
% indicator = isconsistent(gr, h_level)
% -------------------------------------
% Description: returns the consistency status of the a GROUPING instance.
% Input:       {gr} a group instance.
%              <{h_level}> where to check for consistency. If [] or
%                   'all', all hierarchies are taken (def = 'all').
% Output:      {indicator} binary variable of size {h_level}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% parse input line
error(nargchk(1,2,nargin));
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    h_level = 'all';
end
if (ischar(h_level) && strcmp(h_level,'all')) || isempty(h_level)
    h_level = 1:gr.no_hierarchies;
end

indicator = gr.is_consistent(h_level);