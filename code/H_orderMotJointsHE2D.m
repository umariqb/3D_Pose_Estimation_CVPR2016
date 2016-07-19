function mot = H_orderMotJointsHE2D(mot,allJoints)
if(isfield(mot,'inputDB'))
    switch mot.inputDB
        case {'Human80K','Human36Mbm','JHMDB','LeedSports'}
            jIdx = nan(length(allJoints),1);
            for k = 1: length(allJoints)
                try
                    %tmp = find(strcmp(joints(k), mot.jNamesAll(:,1)));
                    tmp = find(strcmp(allJoints(k), mot.jointNames(:,1)));
                    if(~isempty(tmp))
                        jIdx(k) = tmp;
                        motTmp.jointTrajectories2D{k,1} = mot.jointTrajectories2D{tmp}(:,:);
                        motTmp.nameMap{k,1}           = mot.jointNames(tmp,1); %mot.nameMap{tmp,1};
                    end
                catch
                    disp('H:errror: H_orderMotJointsHE2D ... please specify correct joints and their orders! ');
                end
            end
            mot.jointTrajectories2D = motTmp.jointTrajectories2D;
            mot.jointNames = allJoints;
            for i = 1: length(allJoints)
                mot.nameMap{i,1}  = motTmp.nameMap{i,1};
            end
        case 'HumanEva'
            jIdx = nan(length(allJoints),1);
            for k = 1: length(allJoints)
                tmp = find(strcmp(allJoints(k), mot.jointNames(:)));
                if(~isempty(tmp))
                    jIdx(k) = tmp;
                    motTmp.jointTrajectories2D{k,1} = mot.jointTrajectories2D{tmp}(:,:);
                    motTmp.nameMap{k,1}           = mot.jointNames(tmp); %mot.nameMap{tmp,1};
                end
            end
            mot.jointTrajectories2D = motTmp.jointTrajectories2D;
            mot.jointNames = allJoints;
            for i = 1: length(allJoints)
                mot.nameMap{i,1}  = motTmp.nameMap{i,1};
            end
        otherwise
            disp('H-errror: please specify inputDB name in function H_orderMotJointsHE2D ... ');
    end
end
end