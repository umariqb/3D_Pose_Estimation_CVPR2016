function vector = cellArrayToVector(cellArray)
vector=[];
for i=1:length(cellArray)
    vector=[vector cellArray{i}];
end