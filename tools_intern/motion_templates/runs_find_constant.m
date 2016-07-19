function [runs,runs_start,runs_length] = runs_find_constant(v)
% [runs,runs_start,runs_length] = runs_find_constant(v)
%
% Finds runs of constant value within a sequence.
%
% INPUT:
% v ............ a double vector
%
% OUTPUT:
% runs ......... values of runs
% runs_start ... start indices of runs within v: runs=v(runs_start)
% runs_length .. lengths of runs

runs_start = [1 find(diff(v)~=0)+1];
runs = v(runs_start);
runs_length = diff([runs_start length(v)+1]);