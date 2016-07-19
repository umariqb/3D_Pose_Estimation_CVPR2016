function [Xn,Sn,On]=collectRandomCoefficients(Tensor,mot,DataRep,n)

for i=1:n
    alpha=1-power(0.2,i);
    [Xn{i},Sn{i},On{i}] = findCoefficientsCombinedStrategyV2(Tensor,mot,DataRep,true,alpha);
    plotSimAnnPath(On{i},Sn{i},1,2,3);
end