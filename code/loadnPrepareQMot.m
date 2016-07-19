function [motIn, motInN, opts] = loadnPrepareQMot(opts)
%% Loading input data
switch opts.inputDB 
    case 'Human36Mbm'
        %%
        if(strcmp(opts.inpType,'GroundTruth'))
            derivedPoseStr = [opts.loadInPath  'motGT_' opts.subject '_' opts.actName];            
            load(derivedPoseStr);
            if(~exist('motIn','var'))
                 motIn = motGT;
            end           
            motIn.inputDB = opts.inputDB;
        else
            derivedPoseStr = [opts.loadInPath  'motIn_' opts.subject '_' opts.actName];
            load(derivedPoseStr);
        end
        
        switch opts.inpType
            case {'GroundTruth','pgUmar'}
                motIn          = H_orderMotJointsHE2D(motIn,opts.allJoints);
                motIn.jointTrajectories2DF = motIn.jointTrajectories2D;
                [motIn, rootP2D] = H_getRootTranslationHE2D(motIn,opts);
                for n = 1:motIn.njoints
                    motIn.jointTrajectories2D{n}(2,:) = - motIn.jointTrajectories2D{n}(2,:);
                end
                motIn.discRot  = opts.discRot;
                motInN = 0;
            otherwise
                disp('H-error: H_loadnPrepareQMot please specify inpType');
                
        end
    case 'HumanEva'
        if (strcmp(opts.algo,'PG'))
            derivedPoseStr = [opts.loadInPath opts.subject '_' opts.actName];
            load(derivedPoseStr);
            motIn.discRot  = opts.discRot;
            switch opts.inpType
                case 'pgUmar'
                    motIn          = H_orderMotJointsHE2D(motIn,opts.allJoints);
                    motIn.jointTrajectories2DF = motIn.jointTrajectories2D;
                    [motIn, rootP2D] = H_getRootTranslationHE2D(motIn,opts);
                    for n = 1:motIn.njoints
                        motIn.jointTrajectories2D{n}(2,:) = - motIn.jointTrajectories2D{n}(2,:);
                    end
                    motIn.discRot  = opts.discRot;
                    motInN = 0;
            end
        end
end
opts.frameNo = motIn.frameNumbers;
opts.sFrame  = motIn.vidStartFrame;
opts.eFrame  = motIn.vidEndFrame;
end