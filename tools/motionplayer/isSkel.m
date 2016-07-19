function out = isSkel(skel)
% returns true if given argument is a skeleton-type structure
% this function tests if skel is of type struct and contains the
% following fields
%         fieldsRequired = {...
%             'njoints', 'rootRotationalOffsetEuler',...
%             'rootRotationalOffsetQuat', 'nodes', 'paths', 'jointNames',...
%             'boneNames','nameMap', 'animated', 'unanimated', 'filename',...
%             'version', 'name', 'massUnit', 'lengthUnit', 'angleUnit',...
%             'documentation', 'fileType', 'skin'};
fieldsRequired = {'njoints', 'nodes', 'paths', 'filename', 'name'};
for i = 1:size(skel,2)
    s = skel{1,i};
    if(isstruct(s))
        fieldsInMot = fieldnames(s);
        for f = fieldsRequired
            if any(strcmp(f,fieldsInMot))
            else
                out = false;
                fprintf('skel is not valid: \n\t field ''%s'' is missing\n', f{1,1});
                break;
            end
            out = true;
        end
    else
        out = false;
        fprintf('type mismatch on ''skel'': type struct expected\n');
        break;
    end
end
if(out == false)
    r = '';
    for f = fieldsRequired
        r = strcat('''',f{1,1},'''',',', r);
    end
    r = strcat('fields required for skel: \n\t(',r,')\n');
    fprintf(r);
end
end