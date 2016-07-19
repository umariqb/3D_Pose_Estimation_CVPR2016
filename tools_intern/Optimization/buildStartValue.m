function [startValueVector,startValueCell] = buildStartValue(dims)

startValueCell = cell(1,numel(dims));
for i=1:numel(dims)
    startValueCell{i}=1/dims(i)*ones(1,dims(i));
end
startValueVector=cell2mat(startValueCell);