function [yLowerBounds,yUpperBounds] = transformBoundaries(xLowerBounds,xUpperBounds,factors,modesToOptimize)

dimAllModes = zeros(1,length(factors));
for i=1:length(factors)
    dimAllModes(i) = size(factors{i},1);
end

counter = 0;
tmp1    = mat2cell(xLowerBounds,1,dimAllModes(modesToOptimize));
tmp2    = mat2cell(xUpperBounds,1,dimAllModes(modesToOptimize));
tmp3    = cell(size(tmp1));
tmp4    = cell(size(tmp2));

for i=modesToOptimize
    counter         = counter+1;
    tmp1{counter}   = repmat(tmp1{counter}',1,size(factors{i},2)).*factors{i};
    tmp2{counter}   = repmat(tmp2{counter}',1,size(factors{i},2)).*factors{i};
    
    tmp3{counter}   = sum(min(tmp1{counter},tmp2{counter}));
    tmp4{counter}   = sum(max(tmp1{counter},tmp2{counter}));
end
yLowerBounds        = cell2mat(tmp3);
yUpperBounds        = cell2mat(tmp4);