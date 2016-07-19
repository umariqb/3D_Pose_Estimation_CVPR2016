function [motSeq,startOfSeq,endOfSeq] = findMotionSequence(Pcell,Qcell,varargin)

motSeq          = cell(size(Pcell));
animatedJoints  = [];

for i=1:length(Qcell)
    if (~isempty(Qcell{i}))
        animatedJoints  = [animatedJoints i];
    end
end

if nargin>2
    jointIDs=varargin{1};
else
    jointIDs=animatedJoints;
end

framesQ         = length(Qcell{jointIDs(1)});

P=[];
for i=jointIDs
    P = [P Pcell{i}];
end

framesP = size(P,2)/length(jointIDs);
    
fmin    = inf;

for i=1:framesQ-framesP+1
    Q = [];
    for j=jointIDs
        Q=[Q Qcell{j}(:,i:i+framesP-1)];
    end
    
%     f = pointCloudDist_modified(P,Q);
    f = sum(abs(normOfColumns(P)-normOfColumns(Q)));
    if f<fmin
        fmin=f;
        startOfSeq=i;
    end
end

endOfSeq = startOfSeq+framesP-1;

for j=animatedJoints
    motSeq{j}=Qcell{j}(:,startOfSeq:endOfSeq);
end


