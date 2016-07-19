function [Dist] = clacDistancesOverTensor(T,varargin)

[styles,actors,reps]    = deal(T.dimNaturalModes(1),T.dimNaturalModes(2),T.dimNaturalModes(3));
[skels{styles,actors,reps},mots{styles,actors,reps}] ...
                        = reconstructMotion_jt(T,[styles,actors,reps],T.DataRep);
if nargin>1
    animJoints          = varargin{1};
else  
    animJoints          = 1:skels{styles,actors,reps}.njoints;
end

% meanAcc                 = cell(mots{styles,actors,reps}.njoints,1);
% for joint=animJoints
%     meanAcc{joint}      = zeros(size(mots{styles,actors,reps}.jointTrajectories{1}));
% end

A=1;

fprintf('Reconstructing [skel,mot] \t\t\t');
for a=1:T.dimNaturalModes(1)
    for b=1:T.dimNaturalModes(2)
        for c=1:T.dimNaturalModes(3)
            
            fprintf('\b\b\b%i%i%i',a,b,c);
            [skel_A,mot_A]=reconstructMotion_jt(T,[a,b,c],T.DataRep);
            mot_A=addAccToMot(mot_A);
%             for joint=animJoints
%                 meanAcc{joint} = meanAcc{joint} + mots{a,b,c}.jointAccelerations{joint};
%             end

% % %          Dist(A)=compareMotionsPointCloudDist_modified(mot_A,varargin{2},'Acc',animJoints);
            
            B=1;
            
            for x=1:T.dimNaturalModes(1)
                for y=1:T.dimNaturalModes(2)
                    for z=1:T.dimNaturalModes(3)
                        
                        fprintf('\b\b\b%i%i%i',a,b,c);
                        [skel_B,mot_B]=reconstructMotion_jt(T,[x,y,z],T.DataRep);
                        mot_B=addAccToMot(mot_B);
%                         for joint=animJoints
%                             meanAcc{joint} = meanAcc{joint} + mots{a,b,c}.jointAccelerations{joint};
%                         end
                        
                        Dist(A,B)=compareMotionsPointCloudDist_modified(mot_A,mot_B,'Acc',animJoints);
                        
                        fprintf('\n|%i,%i|=%f\n',A,B,Dist(A,B));
                        B=B+1;
 
                    end
                end
            end
            
            A=A+1;
            
            
        end
    end
end

fprintf('\n');
% for joint=animJoints
%     meanAcc{joint} = meanAcc{joint} / (a*b*c);
% end

        

