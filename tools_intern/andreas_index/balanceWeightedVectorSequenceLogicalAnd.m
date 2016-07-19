function [V,weights] = balanceWeightedVectorSequenceLogicalAnd(V, weights)


[V,weights] = expandWeightedVectorSequence(V,weights);
[V,weights] = contractWeightedVectorSequenceLogicalAnd(V,weights);
[V,weights] = expandWeightedVectorSequence(V,weights);
