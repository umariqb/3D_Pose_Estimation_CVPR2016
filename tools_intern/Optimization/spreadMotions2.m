function [motCellArray,motOrig]=spreadMotions2(skelCellArray,motCellArray,varargin)

x = 0;
y = 0;
z = -20;

x0=0;
y0=0;
z0=0;

% frames = 100;

if iscell(skelCellArray)
    if size(skelCellArray)~=size(motCellArray)
        error('Different number of skels and mots');
    end
else
    skel            = skelCellArray;
    skelCellArray   = cell(size(motCellArray));
end

motOrig = cell(size(motCellArray));

for i=1:size(motCellArray,2)
    
    if isempty(skelCellArray{i})
        skelCellArray{i} = skel;
    end
    
    motCellArray{i}.rootTranslation(1,:) = ...
        motCellArray{i}.rootTranslation(1,:) - motCellArray{i}.rootTranslation(1,1);
    motCellArray{i}.rootTranslation(3,:) = ...
        motCellArray{i}.rootTranslation(3,:) - motCellArray{i}.rootTranslation(3,1);
    
    [m,p]   = max(sqrt(sum(motCellArray{i}.rootTranslation([1,3],:).^2)));
    
    u       = motCellArray{i}.rootTranslation([1,3],p);
    v       = [1;0];
    angle   = acos((u'*v)/(sqrt(u'*u)));

    if u(2)<0, angle=-angle; end
    
    if isnan(angle), angle = 0; end;
    
%     motCellArray{i}     = rotateMotion(skelCellArray{i},motCellArray{i},angle,'y');
    motOrig{i}          = motCellArray{i};
%     firstRootPos        = motCellArray{i}.rootTranslation(:,1);
    motCellArray{i}     = translateMotion(skelCellArray{i},motCellArray{i},x0,y0,z0);
%     firstRootPosTrans   = motCellArray{i}.rootTranslation(:,1);
%     quats               = cell2mat(motCellArray{i}.rotationQuat);
%     quats               = [repmat(quats(:,1),1,frames+1) quats];
    
%     xs = firstRootPos(1):x0/frames:firstRootPosTrans(1);
%     if isempty(xs), xs = ones(1,frames+1)*firstRootPos(1); end
%     ys = firstRootPos(2):y0/frames:firstRootPosTrans(2);
%     if isempty(ys), ys = ones(1,frames+1)*firstRootPos(2); end
%     zs = firstRootPos(3):z0/frames:firstRootPosTrans(3);
%     if isempty(zs), zs = ones(1,frames+1)*firstRootPos(3); end    
    
%     motCellArray{i}.rootTranslation     = [[xs;ys;zs],motCellArray{i}.rootTranslation];
%     motCellArray{i}.nframes             = motCellArray{i}.nframes + size(xs,2);
%     motCellArray{i}.rotationQuat        = mat2cell(quats,cell2mat(cellfun(@(x) size(x,1),motCellArray{i}.rotationQuat,'UniformOutput',0))',motCellArray{i}.nframes);
%     motCellArray{i}.jointTrajectories   = forwardKinematicsQuat(skelCellArray{i},motCellArray{i});
    motCellArray{i}.boundingBox         = computeBoundingBox(motCellArray{i});
    
    x0=x0+x;
    y0=y0+y;
    z0=z0+z;
    

end

motionplayer('skel',skelCellArray,'mot',motCellArray);
