function dump(dg,filename)

% DUMP writes a DIGRAPH to disk.
% ------------------
% dump(dg, filename)
% ------------------
% Description: writes a DIGRAPH to disk (in the current directory).
% Input:       {dg} DIGRAPH instance.
%              {filename} name of file, including extension.

% © Liran Carmel
% Classification: I/O functions
% Last revision date: 11-Jan-2008

% parse input line
error(nargchk(2,2,nargin));
[pathstr filename ext] = fileparts(filename);
filename = [filename ext];

% switch on the output format
switch ext
    case '.dig'
        dumpdig(dg,filename);
    otherwise
        error('%s: Unfamiliar output format',upper(ext(2:end)));
end

% #########################################################################
function dumpdig(dg,filename)

% DUMPDIG writes a DIGRAPH to disk in DIG format.
% ----------------------
% dumpphyl(dg, filename)
% ----------------------
% Description: writes a DIGRAPH to disk in DIG format.
% Input:       {dg} DIGRAPH instance.
%              {filename} name of file (including extension).

% initialize
no_nodes = get(dg,'no_nodes');
no_node_cfields = get(dg,'no_node_cfields');
node_cfield = get(dg,'node_cfield');
node_cfield_name = get(dg,'node_cfield_name');

% open file for writting
fid = fopen(filename,'w');

% first line - no_nodes Nodes (ID name age 'user_field_1' 'user_field_2' ...):
fprintf(fid,'%d Nodes (ID name age',no_nodes);
cfields = [];           % which fields can be displayed
cfields_type = [];      % those that can be displayed can be numerical scalars (1) or chars (2)
for ii = 1:no_node_cfields
    [msg is_sca] = chkvar(node_cfield{ii}{1},'numerical','scalar');
    if is_sca
        cfields = [cfields ii];
        cfields_type = [cfields_type 1];
        fprintf(fid,' %s',node_cfield_name{ii});
    else
        [msg is_char] = chkvar(node_cfield{ii}{1},'char','vector');
        if is_char
            cfields = [cfields ii];
            cfields_type = [cfields_type 2];
            fprintf(fid,' ''%s''',node_cfield_name{ii});
        end
    end
end
fprintf(fid,'):\n');

% node lines
node_name = get(dg,'node_name');
for ii = 1:no_nodes
    fprintf(fid,'%d: ''%s''',ii,node_name{ii});
    for jj = 1:length(cfields)
        if cfields_type(jj) == 1    % numerical scalar
            fprintf(fid,' %f',node_cfield{cfields(jj)}{ii});
        else                        % string
            fprintf(fid,' %s',node_cfield{cfields(jj)}{ii});
        end
    end
    fprintf(fid,'\n');
end

% next line - Edges (ID from to):
fprintf(fid,'\nEdges (ID from to):\n');

% edge lines
W = get(dg,'weights');
THD = get(dg,'thd');
edge_id = 0;
for node1 = 1:(no_nodes-1)
    for node2 = (node1+1):no_nodes
        if W(node1,node2)
            edge_id = edge_id + 1;
            if THD(node1,node2) >= 0
                fprintf(fid,'%d: %d %d\n',edge_id,node1,node2);
            else
                fprintf(fid,'%d: %d %d\n',edge_id,node2,node1);
            end
        end
    end
end

% close file
fclose(fid);