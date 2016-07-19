function idx = randindex(list)

% RANDINDEX randomly picks one from a group of indices.
% ---------------------
% idx = randindex(list)
% ---------------------
% Description: randomly picks one from a group of indices.
% Input:       {list} list of indices.
% Output:      {idx} one of the list.

% © Liran Carmel
% Classification: Random numbers
% Last revision date: 18-Apr-2007

% pick a random number in the range [0,1)
rnd = rand(1);
while rnd == 1
    rnd = rand(1);
end

% pick a random index
rnd = 1 + floor(length(list) * rnd);

% return the index
idx = list(rnd);