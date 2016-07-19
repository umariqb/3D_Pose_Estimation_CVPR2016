function [V,weights] = balanceWeightedVectorSequence(V,weights)

[V,weights] = expandWeightedVectorSequence(V,weights);
[V,weights] = contractWeightedVectorSequence(V,weights);
[V,weights] = expandWeightedVectorSequence(V,weights);
