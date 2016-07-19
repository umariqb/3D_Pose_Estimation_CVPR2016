function mnmx = computeminmax(vr)

% COMPUTEMINMAX calculates sample min and max values.
% ------------------------
% mnmx = computeminmax(vr)
% ------------------------
% Description: recomputes the minimal and maximal values of the variable on
%              the given samples.
% Input:       {vr} instance of the variable class.
% Output:      {mnmx} minimal and maximal sample values.

% © Liran Carmel
% Classification: Update functions
% Last revision date: 24-Jun-2004

mnmx = minmax(nanless(vr));