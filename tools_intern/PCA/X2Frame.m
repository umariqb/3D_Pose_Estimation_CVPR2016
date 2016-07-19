function f=X2Frame(X,f,jointList)

for i=jointList
    if(~isempty(f.rotationQuat{i}))
        f.rotationQuat{i}=X(1:4);
        X=X(5:end);
    end
end