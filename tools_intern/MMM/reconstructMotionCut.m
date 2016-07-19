function resultX=reconstructMotionCut(skel,mot,tensors)


mot=changeFrameRate(skel,mot,30);
info=filename2info(mot.filename);

styles{1}=info.motionCategory;
% styles{2}=info.motionCategory;

TensorID=findTensorForStyles(styles,tensors);

% for subClassInd=1:tensors{TensorID}.dimNaturalModes(1)
        tensors{TensorID}.addSkel=skel;
        [fitSkel, fitMot] = extractMotion(tensors{TensorID}, ...
                                          tensors{TensorID}.DTW.refMotID);


        [gdm, warpPath, ldm] = pointCloudDTW_pos(fitMot, mot, 2);

        segMot=warpMotion(warpPath,skel,mot);
        
% % %         ldm = ldm/max(ldm(:));
% % %         
% % %         parameter.vis           = 0;
% % % 
% % %         % Anpassen!!!
% % % 
% % %         parameter.match_thresh  = 0.5*fitMot.nframes;
% % % 
% % %         parameter.match_endExclusionForward = 1;
% % %         parameter.match_startExclusionBackward = 1;
% % % 
% % %         hits = retrieveSubsequenceDTWHits(ldm, parameter);
        
%        fprintf('\n\n\nSubsequence DTW found %i Hits!\n\n\n', size(hits,2));

       recCount=0;
       
%         for hitInd=1:size(hits,2)

    %                     plotDTWpathNice(ldm,flipud(hits(1, hitInd).match'));
    %                     drawnow();

%             warpPath   = convertWarpingPath(flipud(hits(1, hitInd).match'));

%             segMot = warpMotion(warpPath,skel,mot);

            segMot = fitMotion(skel, segMot);

            set              = defaultSet_eg08;
            set.windowLength = segMot.nframes;
            set.warping      = 0;

            recCount = recCount + 1;

            resultX{recCount}              = emptyResultStruct();
            resultX{recCount}.amc          = fullfile(info.amcpath,info.amcname);
            resultX{recCount}.asf          = info.asfname;
            resultX{recCount}.startFrame   = 1;%hits(1, hitInd).frame_first_matched;
            resultX{recCount}.endFrame     = mot.nframes;%hits(1, hitInd).frame_last_matched;
            resultX{recCount}.motionClass  = styles;
            resultX{recCount}.styles       = tensors{TensorID}.styles;
            resultX{recCount}.orgMot       = mot;% warpMotion(convertWarpingPath(fliplr(flipud(hits(1, hitInd).match'))),skel,segMot);

            fprintf('\nReconstruction { %i } :\n\n',recCount);

            resultX{recCount}.res          = recMot_eg08(tensors{TensorID},skel,segMot,set);
            resultX{recCount}.distUnWarp   =  compareMotions_eg08(resultX{recCount}.res.origMot,resultX{recCount}.res.recMot);
            resultX{recCount}.recMotUnWarp =  warpMotion(fliplr(warpPath),skel,resultX{recCount}.res.recMot);
            resultX{recCount}.distUnWarp   =  compareMotions_eg08(resultX{recCount}.orgMot,resultX{recCount}.recMotUnWarp);
 
        end
        
% end



% end

function listOfTensors = findTensorForStyles(styles, tensors)

    listOfTensors=[];

    for tensorID=1:size(tensors,2)
        positions=0;
        for styleID=1:size(tensors{tensorID}.styles,2)
            findres=cell2mat(strfind(styles,tensors{tensorID}.styles{styleID}));
            if ~isempty(findres)
                positions=positions+findres;
            end

        end
        
        if positions>0
            listOfTensors=[listOfTensors tensorID];
        end
        
    end
    
end