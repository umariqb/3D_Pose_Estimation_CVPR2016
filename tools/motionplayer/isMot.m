
function out = isMot(mot)
% returns true if given argument is a motion-type structure
% this function tests if mot is of type struct and contains the
% following fields
%         fieldsRequired = {...
%             'njoints', 'nframes', 'frameTime', 'samplingRate'...
%             'jointTrajectories', 'rootTranslation', 'rotationEuler',...
%             'rotationQuat', 'jointNames', 'boneNames', 'nameMap',...
%             'animated', 'unanimated', 'boundingBox', 'filename',...
%             'documentation', 'angleUnit'};
fieldsRequired = {...
    'njoints', 'nframes', 'frameTime', 'samplingRate'...
    'jointTrajectories', 'boundingBox', 'filename'};
for i = 1:size(mot,2)
    m = mot{1,i};
    if(isstruct(m))
        fieldsInMot = fieldnames(m);
        for f = fieldsRequired
            if (any(strcmp(f,fieldsInMot)))
            else
                out = false;
                fprintf('motion is not valid: \n\t field ''%s'' is missing\n', f{1,1});
                break;
            end
            out = true;
        end
    else
        out = false;
        fprintf('type mismatch on ''mot'': type struct expected\n');
        break;
    end
end
if(out == false)
    r = '';
    for f = fieldsRequired
        r = strcat('''',f{1,1},'''',',', r);
    end
    r = strcat('fields required for mot: \n\t(',r,')\n');
    fprintf(r);
end
end