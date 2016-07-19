function mot = luko2mot(data,joints)

fprintf('MarkerID:\t\t');
for i=1:size(data,2)/3
    fprintf('%i \t',i);
end
fprintf('\nJointID:\t\t');
for i=1:size(data,2)/3
    if i>length(joints), fprintf('? \t');
    else
        if joints(i)~=0, fprintf('%i \t',joints(i));
        else fprintf('- \t');
        end
    end
end
fprintf('\n');

if length(joints)~=size(data,2)/3
    error('Wrong number of jointIDs! Use 0 for markers you do not want to put in your mot structure!');
end

mot                 = emptyMotion;
mot.njoints         = 31;
mot.samplingRate    = 50;
mot.frameTime       = 1/mot.samplingRate;
mot.animated        = setxor(joints,0)';
mot.unanimated      = setxor(mot.animated,1:mot.njoints)';
mot.jointTrajectories = cell(mot.njoints,1);

nrOfVisibleMarkers  = sum(~isnan(data(:,1:3:end))');

startFrame          = 1;
startFrame_tmp      = 1;
endFrame            = 1;
lengthOfSequence    = 1;
for frame=2:length(nrOfVisibleMarkers)
    if (nrOfVisibleMarkers(frame)>0 && nrOfVisibleMarkers(frame-1)<1)
        startFrame_tmp  = frame;
    elseif ((endFrame<startFrame_tmp) && frame==length(nrOfVisibleMarkers))
        endFrame        = frame;
        startFrame      = startFrame_tmp;
        lengthOfSequence = endFrame-startFrame+1;
    elseif (nrOfVisibleMarkers(frame)<=1 && nrOfVisibleMarkers(frame-1)>1)
        if (frame-startFrame_tmp+1>lengthOfSequence)
            endFrame    = frame-1;
            startFrame  = startFrame_tmp;
            lengthOfSequence = endFrame-startFrame+1;
        end
    end
end

mot.nframes=lengthOfSequence;
counter=0;
for i=1:3:size(data,2)
    counter=counter+1;
    if joints(counter)~=0
        mot.jointTrajectories{joints(counter),1}=filterTimeline(data(startFrame:endFrame,i:i+2)',2,'bin')...
            /(10*2.54); % conversion from mm (to cm) to inch
    end
end

mot = addAccToMot(mot);

counter=0;
for i=1:3:size(data,2)
    counter=counter+1;
    mot.LUKO_rawData{counter} = data(startFrame:endFrame,i:i+2);
end

fprintf('SampFrequency: \t%i\n',mot.samplingRate);
fprintf('StartFrame: \t%i\n',startFrame);
fprintf('EndFrame: \t\t%i\n',endFrame);
fprintf('Length: \t\t%i frames (%2.3f seconds)\n',lengthOfSequence,lengthOfSequence/50);
fprintf('Trajectories: \tinch\n');
fprintf('Accelerations: \tm/s^2\n');
fprintf('LUKO_rawData: \tmm\n');

imagesc(~isnan(data(startFrame:endFrame,2:3:end)));