function result=reconstructMotionWithMTSnippets ...
                (snippets,Tensor,MotionClasses,DataRep)

global VARS_GLOBAL;
    if(size(snippets,1)>0)
        resultX=cell(size(snippets,1),size(snippets{1},1));
        for i=1:size(snippets,1)
            for j=1:size(snippets{i},1)

                amcfile=fullfile(VARS_GLOBAL.dir_root, snippets{i}{j,1});
                infos=filename2info(amcfile);

                resultX{i,j} = emptyResultStruct();
                
                resultX{i,j}.amc         =amcfile;
                resultX{i,j}.asf         =infos.asfname;
                resultX{i,j}.startFrame  =snippets{i}{j,2};
                resultX{i,j}.endFrame    =snippets{i}{j,3};
                resultX{i,j}.motionClass =MotionClasses{i};

                
                [skel,mot]   =readMocap(fullfile( ...
                                    infos.amcpath,infos.asfname),amcfile);
                                
                [skel,fitmot]=extractMotion(Tensor,Tensor.DTW.refMotID);

                mot      =changeFrameRate(skel,mot,30);
                
                resultX{i,j}.orgMot=mot;
                resultX{i,j}.orgSkel=skel;
                
                mot      =cutMot(skel,mot, ...
                          resultX{i,j}.startFrame,resultX{i,j}.endFrame);
                mot      =fitMotion(skel,mot);
                [D,w]=SimpleDTW(fitmot,skel,mot);
                mot=warpMotion(w,skel,mot);
                
                resultX{i,j}.orgMotCut = mot;
                resultX{i,j}.warpingPath =w;

                bkset=defaultSet();
                bkset.optimVar='x';
                bkset.regardedJoints=[1 3 4 8 9 18 19 20 25 26 27 15 16];
                bkset.trajectories=DataRep;
%                 bkset.optimizer{1}='simann';
                bkset.optimizer{1}='lsqnonlin';

                recStruct=reconstructMotion(Tensor,skel,mot,'set',bkset);
    
                resultX{i,j}.X      = recStruct.X;
                resultX{i,j}.recMot = recStruct.motRec;
                
                fprintf('\nSave results:');
                save('ClassifyTMP.mat','resultX');
                fprintf(' Done\n');
            end
        end
    else
        fprintf('TensorClassify: No results, empty snippets!\n')
        resultX=0;
    end
end