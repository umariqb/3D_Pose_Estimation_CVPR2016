function res = optimizeMot(Tensor,skel,origmot,varargin)

switch nargin
    case 3
        joints      = (1:31);
    case 4
        joints      = varargin{1};
    otherwise
        ('Wrong number of argins!');
end
res.joints=joints;

res.origmot         = origmot;
[mot,alpha,x0,z0]   = fitMotion(skel,origmot);
[s,motRef]          = extractMotion(Tensor,[1,1,1]);
[D,warpingPath]     = pointCloudDTW(motRef,mot);
res.warpedOrigmot   = warpMotion(warpingPath,skel,mot);

set                 = defaultSet;
set.regardedJoints  = joints;

[res.X,res.recmot]  = reconstructMotion(Tensor,skel,res.warpedOrigmot,'set',set);
res.unwarpedRecmot  = rotateMotion(skel,res.recmot,-alpha,'y');
res.unwarpedRecmot  = translateMotion(skel,warpMotion(fliplr(warpingPath),skel,res.unwarpedRecmot),-x0,0,-z0);
res.Dist            = compareMotionsCrossProduct(skel,res.origmot,res.unwarpedRecmot);