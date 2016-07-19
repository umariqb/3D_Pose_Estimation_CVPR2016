function dg = chowliu(I,nodenames)

% CHOWLIU applies the Chow-Liu algorithm.
% --------------------------
% dg = chowliu(I, nodenames)
% --------------------------
% Description: Builds a second-order dependence tree best describing a
%              data. Uses the Chow-Liu algorithm.
% Input:       {I} description of the pairwise mutual information between
%                  variables. Can be represented in two forms:
%                  (1) matrix of size {no_variables}-by-{no_variables}.
%                  (2) vector of length 0.5*n*(n-1), with the pairwise
%                      mutual information given as
%                      I_{12}, ..., I_{1n}, I_{23}, ..., I_{(n-1)n}.
%                  The second form should be preferred for very large
%                  number of variables.
%              <{nodenames}> names of nodes in the tree. By default, it is
%                  'node #1','node #2',...
% Output:      {dg} a DIGRAPH object describing the tree whose branches
%                  maximize the sum of mutual entropies (see the paper by
%                  Chow & Liu, 1968).

% © Liran Carmel
% Last revision date: 29-Nov-2007

% always work in the vector form of {I}
if isvector(I)
    no_nodes = 0.5*(1 + sqrt(1 + 8*length(I)));
else
    no_nodes = size(I,1);
    I = squareform(I);
end

% defaults
if nargin == 1
    nodenames = cell(1,no_nodes);
    for ii = 1:no_nodes
        nodenames{ii} = sprintf('node #%d',ii);
    end
end

% initialize
node = 1:no_nodes;
a1 = no_nodes - 1;
k = 1;

% initialize matrices needed to initialize a DIGRAPH object
W = zeros(no_nodes);
THD = zeros(no_nodes);

% main loop
while k < no_nodes
    % find {imax,jmax} that maximize I_{ij}
    [mx idx] = max(I);
    imax = ceil( 0.5*(1 + 2*a1 - sqrt( (1 + 2*a1)^2 - 8*idx) ) );
    jmax = idx - (imax-1)*a1 + 0.5*(imax-1)*(imax-2) + imax;
    % set a branch
    if node(imax) < node(jmax)
        % populate Weights
        W(imax,jmax) = mx;
        W(jmax,imax) = mx;
        THD(imax,jmax) = -1;
        THD(jmax,imax) = 1;
        % print branch
        fprintf(1,'%s (%d) --> %s (%d)\n',...
            nodenames{imax},imax,nodenames{jmax},jmax);
        % rewire the vector NODES
        node(node==node(imax)) = node(jmax);
        k = k + 1;
    end
    % set I_{imax,jmax} to zero
    I(idx) = 0;
end

% build a DIGRAPH object
dg = digraph('weights',W,'thd',THD);
dg = set(dg,'node_name',nodenames,'node_mass',sum(W,2));