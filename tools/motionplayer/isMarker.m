function out = isMarker(marker)
%ISMARKER validates marker-struct
fieldsRequired = {'stream', 'color','size'};
out = true;
for i = 1:size(marker,2)
    m = marker{1,i};
    if(isstruct(m))
        fieldsInMarker = fieldnames(m);
        for f = fieldsRequired
            if (any(strcmp(f,fieldsInMarker)))
            else
                out = false;
                fprintf('marker is not valid: \n\t field ''%s'' is missing\n', f{1,1});
                break;
            end
        end
    else
        out = false;
        fprintf('type mismatch on ''marker'': type struct expected\n');
        break;
    end
end
if(out == false)
    r = '';
    for f = fieldsRequired
        r = strcat('''',f{1,1},'''',',', r);
    end
    r = strcat('fields required for marker: \n\t(',r,')\n');
    fprintf(r);
end
end