function [x, y] = computecoordinates(dg,node_Xalg,node_Yalg,x0,y0)

% COMPUTECOORDINATES computes the coordinates of the nodes.
% ------------------------------------------------------------
% [x y] = computecoordinates(dg, node_Xalg, node_Yalg, x0, y0)
% ------------------------------------------------------------
% Description: computes the coordinates of the nodes.
% Input:       {dg} DIGRAPH instance.
%              {node_Xalg} algorithm for computing the x-coordinates.
%                   Currently available:
%                   'eigenproj' - the eigenprojection method (no mass)
%                   'eigenprojm' - the eigenprojection method (with mass)
%              {node_Yalg} algorithm for computing the y-coordinates.
%                   Currently available:
%                   'eigenproj' - the eigenprojection method (no mass)
%                   'eigenprojm' - the eigenprojection method (with mass)
%              {x0} previous coordinates (only used for algorithm
%                   'workspace').
%              {y0} previous coordinates (only used for algorithm
%                   'workspace').
% Output:      {x} x-coordinates.
%              {y} y-coordinates.

% © Liran Carmel
% Classification: Visualization
% Last revision date: 09-Jan-2008

% compute the x-coordinates
x_eigenproj = false;
x_eigenprojm = false;
switch node_Xalg
    case 'eigenproj'
        x_eigenproj = true;
        coords = eigenproj(dg,'no_masses');
        x = coords(1,:);
    case 'eigenprojm'
        x_eigenprojm = true;
        coords = eigenproj(dg,'masses');
        x = coords(1,:);
    case 'workspace'
        x = x0;
end

% compute the y-coordinates
switch node_Yalg
    case 'eigenproj'
        if x_eigenproj
            y = coords(2,:);
        else
            y = eigenproj(dg,'no_masses',2);
        end
    case 'eigenprojm'
        if x_eigenprojm
            y = coords(2,:);
        else
            y = eigenproj(dg,'masses',2);
        end
    case 'workspace'
        y = y0;
end