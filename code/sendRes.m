function sendRes(opts,obj,varargin)
if(nargin>2)
    spath  = varargin{1};
else
    %%C = strsplit(opts.saveResPath,opts.actName);
    %%spath  = [C{1} 'tosend'];
    spath = strrep(opts.saveResPath, [opts.actName '_' opts.bodyType '\'],'tosend');
end
if ~exist(spath,'dir')
    mkdir(spath);
end
%%
op.cJoints  = {'Head'; 'Neck'; 'Left Shoulder'; 'Right Shoulder'; 'Left Hip'; 'Right Hip'; 'Left Elbow'; 
    'Left Wrist';'Right Elbow';'Right Wrist';'Left Knee'; 'Left Ankle'; 
    'Right Knee'; 'Right Ankle'};
op.allJoints = opts.allJoints;
op          = getJointsIdx(op);

%%
knnPos    = reshape(obj.proj2D,2*length(obj.knnJoints),obj.knn,size(obj.data,2));
objts.data = knnPos(op.cJidx2,:,:);
% orName  = [opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' opts.bodyType '_objts.mat'];
orName  = [opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' obj.bodyType '_objts.mat'];
save(fullfile(spath,orName),'objts','-v7.3');

end