function ID = trajectoryID(skel,jointname)

i = strmatch(upper(jointname),upper(skel.nameMap(:,1)),'exact');

if (isempty(i))
    error(['Unknown standard joint name "' jointname '"!']);
end

if (length(i)>1)
    error(['Ambiguous standard joint name "' jointname '"!']);
end

ID = skel.nameMap{i,3};