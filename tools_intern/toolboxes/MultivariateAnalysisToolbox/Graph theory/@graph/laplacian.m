function L = laplacian(gr)

% LAPLACIAN computes the Laplacian of a graph.
% -----------------
% L = laplacian(gr)
% -----------------
% Description: computes the Laplacian of a graph.
% Input:       {gr} instance of the GRAPH class.
% Output:      {L} Laplacian.

% © Liran Carmel
% Classification: Computations
% Last revision date: 02-Sep-2004

% parse input
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));

% get weight matrix, zero its diagonal, and create a Laplacian
wgt = gr.weights;
wgt = wgt - diag(diag(wgt));
L = diag(sum(wgt,1)) - wgt;