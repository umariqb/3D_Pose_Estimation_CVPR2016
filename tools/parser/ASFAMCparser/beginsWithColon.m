function result = beginsWithColon(lin)

result = false;
if (length(lin)>0)
    if (lin(1) == ':')
        result = true;
    end
end