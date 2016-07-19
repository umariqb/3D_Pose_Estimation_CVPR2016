function [V_out,weights_out] = expandWeightedVectorSequence(V_in,weights_in)

weights_rounded = max(1,round(weights_in));
s = sum(weights_rounded);
indices = zeros(1,s);
counter = 1;
for k=1:length(weights_rounded)
    indices(counter:counter+weights_rounded(k)-1) = k;
    counter = counter + weights_rounded(k);
end
V_out = V_in(:,indices);
weights_out = weights_in./weights_rounded;
weights_out = weights_out(indices);
