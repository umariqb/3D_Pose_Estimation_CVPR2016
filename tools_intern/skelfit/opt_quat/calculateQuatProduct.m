function posSoFar = calculateQuatProduct( X, IdxList, rootTranslation, offsets )



posSoFar = rootTranslation;
current_rotation = [1;0;0;0];

for i=IdxList(end:-1:1)
    q = X(4*IdxList(i):4*IdxList(i)+3)';
    current_rotation = quatmult(current_rotation, q);
    posSoFar = posSoFar + quatrot(offsets(:,i), current_rotation);
end
