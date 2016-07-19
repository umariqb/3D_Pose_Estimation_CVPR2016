function dataMat=buildMatFromTensor(T,dataRep)

selectedJoints=[5 4 3 8 9 10 12 13 14 15 16 19 20 21 26 27 28];
dataMat=[];
for s=1:T.dimNaturalModes(1)
    for a=1:T.dimNaturalModes(2)
        for r=1:T.dimNaturalModes(3)
            fprintf('%2i%2i%2i\n',s,a,r);
            if (r>1 && strcmp(T.motions{s,a,r},T.motions{s,a,r-1}))
                disp('Missing motion');
            else
                [sk,m]              = extractMotion(T,[s,a,r]);
%                 m.rootTranslation   = zeros(3,m.nframes);
%                 m                   = fitRootOrientationsFrameWise(sk,m);
                switch dataRep
                    case 'quat'
                        m.rotationQuat{2}   = [];
                        m.rotationQuat{7}   = [];
                        dataMat             = [dataMat cell2mat(m.rotationQuat(selectedJoints))];
                    case 'euler'
                        m                   = convert2euler(sk,m);
                        dataMat             = [dataMat cell2mat(m.rotationEuler(selectedJoints))];
                end
            end   
        end
    end
end