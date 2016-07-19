function X=getRowCoefficients(Tensor,ColCoefs)

newDimVec=size(Tensor.core);

j=1;

for i=1:Tensor.numNaturalModes
       
    X{i}=Tensor.factors{i+Tensor.numTechnicalModes}*ColCoefs(j:j+newDimVec(i+Tensor.numTechnicalModes)-1)';
    
    j=j+newDimVec(i+Tensor.numTechnicalModes);
end
%     
%     y0=[]
%         for j=1:dimvec(i)
%             y0=[y0 1/dimvec(i)];
%         end
%         x0=[x0 (Tensor.factors{nrOfTechnicalModes+i}'*y0')'];
%     end
%     
%     
%     
%     j=1;
% for i=1:length(sizes)
%     X{i}        = x(j:j+sizes(i)-1);
%     j           = j+sizes(i);
% end