function preloadVertexStream( numArmature )
global SCENE
tic;
nframes = SCENE.armatures(numArmature).mot.nframes;
numBones = SCENE.armatures(numArmature).skel.njoints;
motionName = SCENE.armatures(numArmature).mot.filename;
fprintf('\n');
disp(['loading ' motionName '...']);
s = ['calculate bone: ' num2str(1) '/' num2str(numBones)];
disp(s);
for b = 1:numBones
    strlen = length(s);
    s = ['calculate bone: ' num2str(b) '/' num2str(numBones)];
    disp(char(8*ones(1,strlen+2)));
    disp(s);
    if (SCENE.armatures(numArmature).bones(b).parentID == 0)
        trans = SCENE.armatures(numArmature).mot.jointTrajectories{b,1}(:,1:end)';
        vertices = SCENE.armatures(numArmature).bones(b).vertices;
        trans = repmat(trans',size(vertices,1),1);
        trans = reshape(trans,3,[])';
        stream = repmat(vertices,nframes,1) + trans;
        SCENE.armatures(numArmature).bones(b).vertstream = stream;
    else
        head = SCENE.armatures(numArmature).mot.jointTrajectories{...
            SCENE.armatures(numArmature).bones(b).parentID,1}(:,1:end)';
        tail = SCENE.armatures(numArmature).mot.jointTrajectories{...
            SCENE.armatures(numArmature).bones(b).id,1}(:,1:end)';
        stream = getStream(SCENE.armatures(numArmature).bones(b), head, tail);
        SCENE.armatures(numArmature).bones(b).vertstream = stream;
    end
end
t = toc;
disp(['loading ' motionName ' in ' num2str(t) ' sec']);

% returns a stream of all vertex positions to a bone and all its head/tail
% positions
    function stream = getStream(bone, head, tail)
        frames = size(head,1);
        oldHead = bone.headPos;
        oldTail = bone.tailPos;
        vertices = bone.vertices;

        oldDir = (oldTail - oldHead);
        oldLength = sqrt(sum((oldDir.^2)));
        oDirNorm = oldDir / oldLength;
        
        newDir = (tail - head);
        newLength = sqrt(sum((newDir(1,:).^2)));
        newDirNorm = newDir./newLength;
        alpha = acos(...
            oDirNorm(1) * newDirNorm(1:end,1)+...
            oDirNorm(2) * newDirNorm(1:end,2)+...
            oDirNorm(3) * newDirNorm(1:end,3));

        % cross product
        rotAxis = [...
            oDirNorm(2)*newDirNorm(1:end,3)-oDirNorm(3)*newDirNorm(1:end,2) ...
            oDirNorm(3)*newDirNorm(1:end,1)-oDirNorm(1)*newDirNorm(1:end,3) ...
            oDirNorm(1)*newDirNorm(1:end,2)-oDirNorm(2)*newDirNorm(1:end,1)];

        rotAxisLength = sqrt(sum(rotAxis(1:end,:).^2,2));
        
        quaternions = [ones(frames,1) zeros(frames,3)];
        noneZeroRot = find(rotAxisLength > 0);
        rotAxisNormalized = rotAxis(noneZeroRot,:)./...
            repmat(rotAxisLength(noneZeroRot),1,3);
        sinAlpha = sin(alpha./2);
        %drop zero rotations
        sinAlpha = sinAlpha(noneZeroRot,:);
        q1 = cos(alpha(noneZeroRot)./2);
        q2 = rotAxisNormalized(:,1) .* sinAlpha;
        q3 = rotAxisNormalized(:,2) .* sinAlpha;
        q4 = rotAxisNormalized(:,3) .* sinAlpha;
        quats = [q1 q2 q3 q4];
        quaternions(noneZeroRot,:) = quats;
        quaternions = quatnormalize(quaternions');
        
        vertices  = translateVertices(vertices, -oldHead);
        quaternions = repmat(quaternions,size(vertices,1),1);
        quaternions = reshape(quaternions,4,[]);
        stream = quatrot(repmat(vertices,frames,1)',quaternions)';
        headPos = repmat(head',size(vertices,1),1);
        headPos = reshape(headPos,3,[])';
        stream = stream + headPos;
    end
end
