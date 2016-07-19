function pos = computeJointPositions(motion)

nframes=length(motion.TimeLine);

q=repmat(rotquat(pi,'y'),1,nframes);

q=quatmult(motion.OriData{1}',q);

q=repmat(quatinv(q(:,1)),1,nframes);

quats=cell(1,motion.NumMTs);
pos=cell(1,motion.NumMTs);

P{1}=repmat([0;0;0],1,nframes);
P{2}=repmat([35;0;0],1,nframes);
P{3}=repmat([35;0;0],1,nframes);
P{4}=repmat([10;0;0],1,nframes);
P{5}=repmat([10;0;0],1,nframes);

pos{1}=zeros(3,nframes);
for i=1:motion.NumMTs
    quats{i}=quatmult(motion.OriData{i}',q);
    if i>1
        pos{i}=quatrot(P{i},quats{i})+P{i-1};
    end
end

