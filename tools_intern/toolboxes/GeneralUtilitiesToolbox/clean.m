function clean

% CLEAN resets the workspace.
% -----
% clean
% -----
% Description:  resets the workspace. Specifically, removes all variables,
%               classes, functions and figures.

% © Liran Carmel
% Classification: Workspace manipulations
% Last revision date: 14-Jan-2004

evalin('base','clear classes')
close all
clc