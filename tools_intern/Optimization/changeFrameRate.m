function [newMot,newSamp,oldSamp,newkeys] = changeFrameRate(skel,mot,newFrameRate,varargin)

newMot   = mot;
oldSamp  = 1:mot.nframes;
newSamp  = 1:mot.nframes;

switch nargin
   case 3
      keyframes = [];
   case 4
      keyframes = varargin{1};
   otherwise
      error('Wrong num of args!');
end

newkeys = [];

if mot.samplingRate~=newFrameRate
    tic
    newMot.samplingRate = newFrameRate;
    newMot.frameTime    = 1/newFrameRate;

%     if mot.samplingRate<newFrameRate
%         fprintf('Increasing framerate using spline interpolation...');
%     elseif mot.samplingRate>newFrameRate
%         if (mod(mot.samplingRate,newFrameRate)==0)
%             fprintf('Reducing framerate discarding frames...');
%         else
%             fprintf('Reducing framerate using spline interpolation...');
%         end
%     end

    if isempty(keyframes)
      newSamp = 1:mot.samplingRate/newFrameRate:mot.nframes;
    else
%       newSamp = sort(unique([1:mot.samplingRate/newFrameRate:keyframes(end) keyframes]));
      newSamp = 1:mot.samplingRate/newFrameRate:mot.nframes;
      for k=1:numel(keyframes)
          [~,pos] = min(abs(newSamp - keyframes(k)));
          newSamp(pos) = keyframes(k);
      end
           
    end
    
    nkc=1;
    for ck = 1:numel(keyframes)
      [~,nk] = find(newSamp==keyframes(ck),1);
      if ~isempty(nk)
         newkeys(nkc)=nk;
         nkc = nkc+1;
      end
    end

    if ~(isempty(newMot.rootTranslation))
        newMot.rootTranslation  = spline(oldSamp,mot.rootTranslation,newSamp);
        newMot.nframes          = size(newMot.rootTranslation,2);
    end

    if ~(isempty(mot.rotationQuat))
       
        tmpQuats = mot.rotationQuat;
        for i=1:mot.njoints
            if ~(isempty(tmpQuats{i}))
               if newFrameRate<=mot.samplingRate
                  tmpQuats{i} = spline(oldSamp,tmpQuats{i},newSamp);
               else
                  tmpQuats{i} = slerpInterpolation(oldSamp,tmpQuats{i},newSamp);
               end
            end
        end
        newMot.rotationQuat = tmpQuats;
        newMot.jointTrajectories    = C_forwardKinematicsQuat(skel,newMot);
        newMot.nframes              = size(newMot.jointTrajectories{1},2);
        if ~(isempty(mot.rotationEuler))
            newMot                  = convert2euler(skel,newMot);
        end
    elseif ~(isempty(mot.rotationEuler))
        for i=1:mot.njoints
            if ~(isempty(mot.rotationEuler{i}))
                newMot.rotationEuler{i} = spline(oldSamp,mot.rotationEuler{i},newSamp);
            end
        end
        tmpMot                      = convert2quat(skel,newMot);
        newMot.jointTrajectories    = C_forwardKinematicsQuat(skel,tmpMot);
        newMot.nframes              = size(newMot.jointTrajectories{1},2);
    else
        if ~(isempty(mot.jointTrajectories))
            for i=1:mot.njoints
                newMot.jointTrajectories{i}  = spline(oldSamp,mot.jointTrajectories{i},newSamp);
            end
            newMot.nframes              = size(newMot.jointTrajectories{1},2);
        end
    end

    if isfield(newMot,'jointVelocities') 
        if ~(isempty(newMot.jointTrajectories))
            newMot = addVelToMot(newMot);
        elseif ~(isempty(newMot.jointVelocities))
            for i=1:mot.njoints
                if ~(isempty(newMot.jointVelocities{i}))
                    newMot.jointVelocities{i}  = spline(oldSamp,mot.jointVelocities{i},newSamp);
                    newMot.nframes = length(newMot.jointVelocities{i});
                end
            end
        end   
    end

    if isfield(newMot,'jointAccelerations') 
        if ~(isempty(newMot.jointTrajectories))
            newMot = addAccToMot(newMot);
        elseif ~(isempty(newMot.jointAccelerations))
            for i=1:mot.njoints
                if ~(isempty(newMot.jointAccelerations{i}))
                    newMot.jointAccelerations{i}  = spline(oldSamp,mot.jointAccelerations{i},newSamp);
                    newMot.nframes = length(newMot.jointAccelerations{i});
                end
            end
        end   
    end

    if isfield(newMot,'Xsens_rawCalData') 
        if ~(isempty(newMot.Xsens_rawCalData))
            for i=1:size(newMot.Xsens_rawCalData,2)
                if ~(isempty(newMot.Xsens_rawCalData{i}))
                    newMot.Xsens_rawCalData{i}  = spline(oldSamp,mot.Xsens_rawCalData{i}',newSamp)';
                    newMot.nframes = length(newMot.Xsens_rawCalData{i});
                end
            end
        end   
    end
    
    if ~(isempty(newMot.jointTrajectories))
        newMot.boundingBox=computeBoundingBox(newMot);
    end
    
    if isfield(newMot,'phy') 
        if ~(isempty(newMot.phy))
            fields=fieldnames(mot.phy);
           for field=1:size(fields,1)
                if isreal(mot.phy.(fields{field}))
                    newMot.phy.(fields{field})  = spline(oldSamp,mot.phy.(fields{field}),newSamp);
%                     newMot.nframes = length(newMot.phy);
                else
                    newMot.phy.(fields{field}) = mot.phy.(fields{field});
                end
            
           end
        end
    end
%     fprintf('\n...finished in %6f seconds. Old framerate was %i fps, newFrameRate is %i fps.\n',toc,mot.samplingRate,newMot.samplingRate);
else

   newkeys = keyframes;

end
