function mot=getMotFromIndices(dbmats,ind1,ind2,skel)

    sF=min(ind1,ind2);
    eF=max(ind1,ind2);
    
    mot=buildMotFromRootAndRotData(double(dbmats.quat       (:,sF:eF)), ...
                                   double(dbmats.origRootPos(:,sF:eF)), ...
                                   double(dbmats.origRootOri(:,sF:eF)), ...
                                   skel );
    mot.samplingRate = dbmats.frameRate;
    mot.frameTime = 1/mot.samplingRate;
end