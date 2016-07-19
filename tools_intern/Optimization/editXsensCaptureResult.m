function res = editXsensCaptureResult(capRes)

res.locAcc      = cell(31,1);
res.globAcc     = cell(31,1);
res.globAccFil  = cell(31,1);
rotQuat         = cell(31,1);

g = 9.8112;
for i=1:size(capRes.MT_IDs,1)
    jointID                     = capRes.MT_jointIDs{i};
    rotQuat{jointID}            = capRes.rawOriData{i}';
    
    res.locAcc{jointID}         = capRes.rawCalData{i}(:,1:3)';
    res.globAcc{jointID}        = C_quatrot(res.locAcc{jointID},rotQuat{jointID});
    res.globAcc{jointID}(3,:)   = res.globAcc{jointID}(3,:) - g;
    
    res.locAcc{jointID}         = res.locAcc{jointID}([2,3,1],:);
    res.globAcc{jointID}        = res.globAcc{jointID}([2,3,1],:);
end

if ~isempty(rotQuat{1})
    a                   = [1;0];
    p                   = C_quatrot([0;0;-1],rotQuat{1});
    u                   = [p(1,:);p(3,:)];
    v                   = repmat(a,1,size(u,2));
    angles              = real(acos(dot(u,v)./(dot(u,u))));
    angles(u(2,:)<0)    = -angles(u(2,:)<0);
    qy                  = rotquat(angles,'y');
    
    rootAcc = C_quatrot(res.globAcc{1},qy);
    
    for i=1:size(capRes.MT_IDs,1)
        jointID                     = capRes.MT_jointIDs{i};
        res.globAcc{jointID}        = C_quatrot(res.globAcc{jointID},qy)-rootAcc;
        res.globAccFil{jointID}     = filterTimeline(res.globAcc{jointID},2,'bin');
    end
else
    fprintf('\Fitting failed because the root had apparently not been tracked!\n');
end