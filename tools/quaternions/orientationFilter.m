function b = orientationFilter(a)
% b = orientationFilter(a)
% Constructs a filter for orientation data filtering from a standard 
% symmetric convolution filter.
%
% Input:        symmetric row vector, odd length, sum = 1
% Output:       corresponding orientation filter
%
% Reference:    J. Lee and S. Shin: General Construction of Time-Domain Filters for Orientation Data,
%               Trans. IEEE Vis. and Comp. Graph., 2002


if (size(a,1)~=1)
    error('Filter must be a row vector!');
end

if (abs(sum(a)-1)>1000*eps)
    error('Sum of filter coefficients must be 1!');
end

if (mod(length(a),2)==1)
    k = (length(a)-1)/2;
    if (abs(sum(a(1:k) - fliplr(a(k+2:2*k+1))))>1000*eps)
        error('Filter must be symmetric!');
    end
else
    error('Filter length must be odd!');
end

b = zeros(1,2*k);
for m = 1:k
    b(m) = -sum(a(1:m));
end
for m = k+1:2*k
    b(m) = sum(a(m+1:2*k+1));
end