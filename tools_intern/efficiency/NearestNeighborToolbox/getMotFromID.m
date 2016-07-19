function mot=getMotFromID(dbmats,ID,skel)

    startF = dbmats.motStartIDs(ID);
    if ID~=size(dbmats.motStartIDs,1)
        endF   = dbmats.motStartIDs(ID+1)-1;
    else
        endF   = size(dbmats.pos,2);
    end

    mot=buildMotFromRootAndRotData(double(dbmats.quat       (:,startF:endF)), ...
                                   double(dbmats.origRootPos(:,startF:endF)), ...
                                   double(dbmats.origRootOri(:,startF:endF)), ...
                                   skel );

end