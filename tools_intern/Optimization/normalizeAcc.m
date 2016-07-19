function data = normalizeAcc(data,joints)

matIDs = jointIDsToMatrixIndices(joints);

lengths = zeros(numel(joints),size(data,2));

r=1;
for i=1:numel(joints)
    lengths(i,:) = sqrt(sum(data(matIDs.pos(r:r+2),:).^2));
    r = r+3;
end
maxis = max(lengths);
data = data./repmat(maxis,size(data,1),1);
