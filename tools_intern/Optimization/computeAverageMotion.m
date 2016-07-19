function [skel,averageMotion] = computeAverageMotion(Tensor)

X=cell(1,Tensor.numNaturalModes);
for i=1:Tensor.numNaturalModes
    X{i}  = ones(1,Tensor.dimNaturalModes(i))/Tensor.dimNaturalModes(i);
end
[skel,averageMotion]=constructMotion(Tensor,X);