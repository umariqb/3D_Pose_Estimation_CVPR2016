function structOut = evalFields(structTo,structFrom)
structOut = structTo;
defaultFields = fieldnames(structTo);
for i = 1:size(defaultFields,1);
    f = defaultFields{i};
    if(isfield(structFrom,f))
        s = ['structOut.' f '= structFrom.' f ';'];
        eval(s);
    end
end
end