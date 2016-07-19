%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name   : nn_wrapper (Nearest Neighbor Toolbox Wrapper)
% Version: 0.9
% Author : Thomas Helten
%
% Description: Provides functions and classes for nearest neighbor searches
%   using the ANN-library.
%
% Usage: nn_wrapper(<command>,<arg1>,<arg2>,...);
%
% Commands: commands are provided as strings
%
%      new: creates a new object.
%       <arg1> string describing the type of  the object to create. Valid
%       types are 'Sample', 'SampleSet', 'Trajectory' and 'TrajectorySet'.
%       <arg2>...<argn> arguments passed to constructors.
%
%     call: calls a method of an object.
%
%
%   delete: deletes an object and frees its memory.
%      <arg1> uint32 id of object to delete
%
%    clean: deletes all objects.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%