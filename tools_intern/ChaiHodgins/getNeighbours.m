function neighbourList = getNeighbours(neighbourGraph,indexList)

[row,col] = find(neighbourGraph(:,indexList)); 
% col darf nicht gelöscht werden!

neighbourList = unique(row');