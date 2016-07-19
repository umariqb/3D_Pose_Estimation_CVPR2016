function [skels,mots,meanAcc] = extractAllMotions(T,varargin)

[styles,actors,reps]    = deal(T.dimNaturalModes(1),T.dimNaturalModes(2),T.dimNaturalModes(3));
[skels{styles,actors,reps},mots{styles,actors,reps}] ...
                        = extractMotion(T,[styles,actors,reps],T.DataRep);
if nargin>1
    animJoints          = varargin{1};
else  
    animJoints          = 1:skels{styles,actors,reps}.njoints;
end


% meanVel                 = cell(mots{styles,actors,reps}.njoints,1);
% meanPos                 = cell(mots{styles,actors,reps}.njoints,1);
meanAcc                 = cell(mots{styles,actors,reps}.njoints,1);
for joint=animJoints 
%     meanVel{joint}      = zeros(3,mots{styles,actors,reps}.nframes);
%     meanPos{joint}      = zeros(3,mots{styles,actors,reps}.nframes);
    meanAcc{joint}      = zeros(3,mots{styles,actors,reps}.nframes);
end

fprintf('Reconstructing [skel,mot] \t\t\t');
for a=1:T.dimNaturalModes(1)
    for b=1:T.dimNaturalModes(2)
        for c=1:T.dimNaturalModes(3)
            fprintf('\b\b\b%i%i%i',a,b,c);
            [skels{a,b,c},mots{a,b,c}]=extractMotion(T,[a,b,c],T.DataRep);
            mots{a,b,c}=addVelToMot(mots{a,b,c});
            mots{a,b,c}=addAccToMot(mots{a,b,c});
            for joint=animJoints
%                 meanPos{joint} = meanPos{joint} + mots{a,b,c}.jointTrajectories{joint};       
%                 meanVel{joint} = meanVel{joint} + mots{a,b,c}.jointVelocities{joint};
                meanAcc{joint} = meanAcc{joint} + mots{a,b,c}.jointAccelerations{joint};
            end
        end
    end
end

fprintf('\n');
for joint=animJoints
%     meanPos{joint} = meanPos{joint} / (a*b*c);
%     meanVel{joint} = meanVel{joint} / (a*b*c);
    meanAcc{joint} = meanAcc{joint} / (a*b*c);
end
% averageStruct.averagePositions=meanPos;
% averageStruct.averageVelocities=meanVel;
% averageStruct.averageAccelerations=meanAcc;