function [msg, indicator_scalar, indicator_fullsize] = chkvar(var, class_list, attr_list, var_id)

% CHKVAR verifies class and attributes of a variable.
% --------------------------------------------------------------------------------------
% [msg indicator_scalar indicator_fullsize] = chkvar(var, class_list, attr_list, var_id) 
% --------------------------------------------------------------------------------------
% Description: verifies class and attributes of a variable.
% Input:       {var} any variable.
%              {class_list} cell array of allowed classes. Can be any
%                 user-defined class, Matlab class, or the keywords
%                    'numeric' - the collection of {'double', 'single',
%                                'uint8', 'int8', 'uint16', 'int16',
%                                'uint32', 'int32','logical'}.
%                    'integer' - the collection of {'uint8', 'int8',
%                                'uint16', 'int16', 'uint32', 'int32',
%                                'logical'}.
%                    'binary'  - either a logical variable or a 0/1
%                                integer.
%              {attr_list} cell array of attributes. Can be any of the
%                 following keywords
%                    'even'   - checks for even numbers.
%                    'odd'    - checks for odd numbers.
%                    'vector' - checks that the variable is a vector. A
%                               scalar is considered as a vector. An empty
%                               variable is considered as a vector. If the
%                               variable is a multidimensional array, it is
%                               still considered as vector if only one of
%                               the dimensions is larger than 1. The next
%                               item in {attr_list} may be the required
%                               length of the vector.
%                    'scalar' - checks that the variable is a scalar. An
%                               empty variable is considered a scalar. If
%                               the variable is a multidimensional array,
%                               it is still considered as scalar if all the
%                               dimensions are exactly 1.
%                    'match',list  - checks that the variable equals
%                               one the entries in {list}.
%                    'sumto',1 - check that the sum of elements along
%                               columns is 1. 
%                    'symmetric' - check that a matrix is symmetric.
%                    'length',len - checks that the variable is a vector of
%                               of a certain length.
%                    'maxlength',len - checks that the variable is a vector
%                               of maximal length {len}.
%                    'minlength',len - checks that the variable is a vector
%                               of minimal length {len}.
%                    'size',sz - checks that the variable is of a certain
%                               size.
%                    'no_rows',rows - checks that the variable has a
%                               certain number of rows.
%                    'no_cols',cols - checks that the variable has a
%                               certain number of columns.
%                    'eqlower',val - all elements are equal to or lower
%                               than {val}.
%                    'eqgreater',val - all elements are equal to or greater
%                               than {val}.
%                    'greaterthan',val - all elements are greater than
%                               {val}.
%              <{var_id}> a three-element cell array used for a formatted
%                 error message, comprising of {func_name, var_name,
%                 var_location}. {func_name} is the name of the m-file
%                 where the variable was checked, {var_name} is the name of
%                 the inspected variable, and {var_location} is the
%                 location of the variable in the input line. If
%                 {func_name} of {var_name} are irrelevant, '' can be used,
%                 and if {var_location} is irrelevant, 0 can be used.
% Output:      {msg} a formatted error message.
%              {indicator_scalar} logical scalar variable (when true/flase
%                 answer is required).
%              {indicator_fullsize} logical variable of the same size as
%                 {var}, with 1 where {var} has all the attributes and 0
%                 otherwise.

% © Liran Carmel
% Classification: Variable verification
% Last revision date: 24-Sep-2004

msg = [];
indicator_scalar = true;
indicator_fullsize = true;