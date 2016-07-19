function [y,w] = indicesFixedBits(n, bits_select, bits_vals)
% [y,w] = indicesFixedBits(n, bits_select, bits_vals)
% Returns a list of integers in y and the corresponding binary strings (padded to length n) in w generated in the following way:
% In the set of all length n binary strings, the bit positions indicated by the vector bit_select are fixed to the values in the vector bits_vals.
% The remaining bits are free to assume the values {0,1}. All integers formed in this way are returned in y and w, respectively.
% The sequence convention for the bits_select and bits_vals is as follows:
% i-th entry in bits_select corresponds to (n-i)-th least significant bit in the generated binary strings.

if (~ischar(bits_vals))
    for k = 1:length(bits_vals)
        bits_vals_string(k) = num2str(bits_vals(k));
    end
else
    bits_vals_string = bits_vals;
end

y_num = 2^(n - length(bits_select));
bits_select = n - bits_select + 1;
bits_notselect = setdiff([1:n], bits_select);

y = zeros(y_num,1);

bin_notselect_all_possibilities = dec2bin([0:y_num-1]');

w = char(zeros(y_num,n));
if (~isempty(bits_select))
    w(:,bits_select) = repmat(bits_vals_string,y_num,1);
end
if (~isempty(bits_notselect))
    w(:,bits_notselect) = bin_notselect_all_possibilities;
end
y = bin2dec(w) + 1;
