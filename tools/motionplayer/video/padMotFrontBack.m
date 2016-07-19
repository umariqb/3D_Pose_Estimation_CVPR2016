function mot = padMotFrontBack(mot, framesFront, framesBack)


mot.nframes = mot.nframes + framesFront + framesBack;
first = mot.rootTranslation(:,1);
last = mot.rootTranslation(:,end);
mot.rootTranslation = [ repmat(first, 1, framesFront) mot.rootTranslation repmat(last, 1, framesBack)];



for j=1:length(mot.jointTrajectories)
    tra = mot.jointTrajectories{j};
    
    
    first = tra(:,1);
    last = tra(:,end);
    tra = [ repmat(first, 1, framesFront) tra repmat(last, 1, framesBack)];
    mot.jointTrajectories{j} = tra;
    
    if ~isempty(mot.rotationEuler{j})
        first = mot.rotationEuler{j}(:,1);
        last = mot.rotationEuler{j}(:,end);
        mot.rotationEuler{j} = [ repmat(first, 1, framesFront) mot.rotationEuler{j} repmat(last, 1, framesBack)];
    end
    
    if ~isempty(mot.rotationQuat{j})
        first = mot.rotationQuat{j}(:,1);
        last = mot.rotationQuat{j}(:,end);
        mot.rotationQuat{j} = [ repmat(first, 1, framesFront) mot.rotationQuat{j} repmat(last, 1, framesBack)];
    end
end