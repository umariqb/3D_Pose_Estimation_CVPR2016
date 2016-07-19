% function cutMotion
% cuts a motion sequence to specified start and end frame
% mot = cutMotion(mot,startFrame,endFrame)
% authors: Bjoern Krueger (kruegerb@cs.uni-bonn.de), 
%          Jochen Tautges (tautges@cs.uni-bonn.de)

function [mot] = cutMotion(mot,startF,endF)

if startF~=1 || endF~=mot.nframes
    
    if (startF<1 || startF>endF || startF>mot.nframes || endF>mot.nframes)
        error('Forbidden values for start and end frame! sF=%i eF=%i mot.nframes=%i',startF, endF, mot.nframes);
    end
    mot.nframes = endF-startF+1;
%     computePos = false;
    if (isfield(mot,'jointTrajectories') && ~isempty(mot.jointTrajectories))
%         computePos = true;
        if iscell(mot.jointTrajectories)
            if size(mot.jointTrajectories{1},2)>=endF
                mot.jointTrajectories = cellfun(@(x) x(:,startF:endF),mot.jointTrajectories,'UniformOutput',0);
            end
            mot.boundingBox = computeBoundingBox(mot);
        else
            mot.jointTrajectories = mot.jointTrajectories(:,startF:endF);
        end
            
    end
%     computeVel = false;
    if (isfield(mot,'jointVelocities') && ~isempty(mot.jointVelocities))
        if iscell(mot.jointVelocities)
            mot.jointVelocities = cellfun(@(x) x(:,startF:endF),mot.jointVelocities,'UniformOutput',0);
        else
            mot.jointVelocities = mot.jointVelocities(:,startF:endF);
        end
        %         computeVel = true;
    end
%     computeAcc = false;
    if (isfield(mot,'jointAccelerations')&& ~isempty(mot.jointAccelerations))
        %         computeAcc = true;
        if iscell(mot.jointAccelerations)
            mot.jointAccelerations = cellfun(@(x) x(:,startF:endF),mot.jointAccelerations,'UniformOutput',0);
        else
            mot.jointAccelerations = mot.jointAccelerations(:,startF:endF);
        end
    end
%     computeQuat = false;
    if (isfield(mot,'rotationQuat') && ~isempty(mot.rotationQuat))
        if(iscell(mot.rotationQuat))
%         computeQuat = true;
            mot.rotationQuat(mot.animated) = cellfun(@(x) x(:,startF:endF),mot.rotationQuat(mot.animated),'UniformOutput',0);
            mot.rotationQuat(mot.unanimated) = {[]};
        else
            mot.rotationQuat = mot.rotationQuat(:,startF:endF);
        end
    end
    
%     computeEuler = false;
    if (isfield(mot,'rotationEuler') && ~isempty(mot.rotationEuler))
%         computeEuler = true;
        mot.rotationEuler(mot.animated) = cellfun(@(x) x(:,startF:endF),mot.rotationEuler(mot.animated),'UniformOutput',0);
        mot.rotationEuler(mot.unanimated) = {[]};
    end
    
    if ~isempty(mot.rootTranslation)
        mot.rootTranslation = mot.rootTranslation(:,startF:endF);
    end
    
    if isfield(mot,'footprints')
       mot.footprints = mot.footprints(:,startF:endF);
    end
    
    if isfield(mot,'timestamp')
        mot.timestamp = mot.timestamp(:,startF:endF);
    end
    
    % crazy people special field
    if (isfield(mot,'rootOri') && ~isempty(mot.rootOri))
        mot.rootOri = mot.rootOri(:,startF:endF);
    end    

end
