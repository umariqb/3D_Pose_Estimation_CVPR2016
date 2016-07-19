function P = quatexp_rot(Q)
% P = quatexp_rot(Q)
% Implementation according to Grassia (1998)
%
% input:    Q is a 3xn array of 3-vectors
% output:   P(:,i) is the quaternionic exponential of Q(:,i)

if (size(Q,1)~=3)
    error('Input array: number of rows must be 3!');
end
n = size(Q,2);

theta = sqrt(sum(Q(:,:).^2)); % euclidean length of the vector part
zero = find(theta<eps^(1/4)); % num_zero = length(zero); % identify near-zero vector parts
nonzero = find(theta>=eps^(1/4)); % identify nonzero vector parts

vector_parts = zeros(3,n);
if ~isempty(zero>0)
    tmp = (0.5 + (1/48)*theta(zero).^2);
    vector_parts(:,zero) = tmp([1 1 1],:) .* Q(:,zero); % use first two terms of sinc taylor expansion
end
if ~isempty(nonzero>0)
    tmp = sin(0.5*theta(nonzero));
    vector_parts(:,nonzero) = tmp([1 1 1],:) .*(Q(:,nonzero)./ theta([1 1 1],nonzero));
end

real_parts = cos(0.5*theta);

P = [real_parts;vector_parts];