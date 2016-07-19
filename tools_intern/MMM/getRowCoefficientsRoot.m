function X=getRowCoefficientsRoot(Tensor,ColCoefs)

newDimVec=size(Tensor.rootcore);

j=1;

for i=1:Tensor.numNaturalModes
       
    X{i}=Tensor.rootfactors{i+Tensor.numTechnicalModes-1}*ColCoefs(j:j+newDimVec(i+Tensor.numTechnicalModes-1)-1)';
    
    j=j+newDimVec(i+Tensor.numTechnicalModes-1);
end
