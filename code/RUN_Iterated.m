%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Perform 3D Pose Estimation iteratively on complete Dataset    %%%%
%%%%   In this Demo, number of iterations for each image is set to 1 %%%%
%%%%   Authors: Hashim Yasim, Umar Iqbal, Andreas Döring             %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if((exist('isInitialized','var') == 0) ||  (isInitialized ~= 1))
   errStr=['Please run ''','Initialize''', ' first. Also make sure to compile the binaries first'];
   error(errStr);
end

%% Read Annotation File and start loop for each image

    fid = fopen(TDPose_ImgIndexPath);
    format = '%s%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d';
    annotations = textscan(fid, format);
    fclose(fid);
    imagePaths = annotations{1};
    numImages = length(annotations{1});

%%%%%%%%%%%%%%%%%% MAIN LOOP %%%%%%%%%%%%%%%%%%
%   Iterates over all annotated images and    %
%   performs pose estimation for each image   %
%   seperately.                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:numImages
            if ~exist(opts.saveResPath,'dir')
                mkdir(opts.saveResPath);
            end
            if ~exist(opts.loadInPath,'dir')
                mkdir(opts.loadInPath);
            end
            if ~exist(opts.saveInPath,'dir')
                mkdir(opts.saveInPath);
            end 
            
           fprintf('##### Starting 3D PE for Image %d\n', i);
           
           fid_nn = fopen([TDPose_TmpFileSavePath 'tmp_annotation.txt'], 'w');
           img_path = cell2mat(annotations{1}(i));
           fprintf(fid_nn, '%s', img_path);

           % get specific frame number
           [~,name,ext] = fileparts(img_path);
           C = strsplit([name '.' ext], '_');
           targetGTFrame = str2num(C{3});
           %
           
           for k = 2:size(annotations,2)
                fprintf(fid_nn, ' %d', annotations{k}(i));
           end
      
           fprintf(fid_nn, '\n');
           fclose(fid_nn);
           
           %%%%%%%%% 1st: 2D Pose Estimation %%%%%%%%%%%%%%%%%%%%
           % produces a text-annotation file at given location %%
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           tic;
           fprintf('Starting 2D Pose Estimation...\n');
           
           execString = '../MEX/src/eval_pose_human36m_multiscale/eval_pose_human36m_multiscale ';
           execString = [execString TDPose_ExperimentName ' ' int2str(TDPose_NTrees) ' ' TDPose_ConfigPath];
           execString = [execString ' ' [TDPose_TmpFileSavePath 'tmp_annotation.txt'] ' ' TDPose_TrainFile];
           execString = [execString ' ' opts.loadInPath ' ' TDPose_EstiamtedAnnotationName];
           
           system(execString);
           toc;

           fprintf('\tDone\n')
           
           %%%%%%%%%% LOOP: repeat for a defined amount of rounds %%%%%%%%%
           %%%%%%%%%%                                             %%%%%%%%%
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           for r=1:opts.numRounds
               fprintf('Starting round %d\n', opts.round);
            %%%%%%%%%%%%%%%%%%%%%%%%% Converting File Format %%%%%%%%%%%%%%%%%%%%%%%%%
            %  2D Pose Estimation results are converted and stored at given location %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            tmp_convertedFile = [opts.loadInPath H_dirFilesUm('Human36Mbm', ... 
                                                        TDPose_TmpFileSavePath,...
                                                        TDPose_EstiamtedAnnotationName, ... 
                                                        opts.dataFormat, ...
                                                        opts.loadInPath)];    
            load(tmp_convertedFile, '-mat');
            motIn2DEstimation = motIn;
            
            %%%%%%%%%%% KNN Retrieval, for every body configuration  %%%%%%%%%%%
            %        loop over all possible configurations called              %
            %        'pose', 'left', 'right','upper', 'lower;                  %
            %                  and save them locally                           %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
            fprintf('\tStarting KNN Retrieval....\n');
            tic;
            for bodyTypeNum=1:length(opts.bodyTypes)
                fprintf(['\t\tretrieve body Type ' opts.bodyTypes{bodyTypeNum} '\n']);

                opts.bodyType = opts.bodyTypes{bodyTypeNum};

                % adapting save path depending on bodyType

                opts.saveResPath = fullfile(TDPose_TmpSaveResults);
                opts.saveResPath = ...
                fullfile([opts.saveResPath opts.inputDB '_' opts.database svStr num2str(opts.round) '/']);
                opts.saveResPath = fullfile([opts.saveResPath  '/sepOrient/']);

               % retrieve joint configuration
               opts.cJno = getShapeJointNum(opts.bodyType,opts.inputDB);
               [opts.allJoints, opts.cJoints] = getJointsHE (opts.inputDB,opts.database,opts.cJno,opts.bodyType);
               opts = getJointsIdx(opts);

                cvpr(opts, db);
            end
           fprintf('\nDone retrieving KNN for all body types');
           toc
           
            %%%%%%%%%%%%%% Convert KNN for every body configuration %%%%%%%%%%%%
            %%%%%%%%%%%%%%                                          %%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
            % restore saveResPath 
            opts.saveResPath = fullfile(TDPose_TmpSaveResults);
            opts.saveResPath = ...
            fullfile([opts.saveResPath opts.inputDB '_' opts.database svStr num2str(opts.round) '/']);
            TDPose_TmpSaveResultsConverted = [opts.saveResPath '/nn'];
            opts.saveResPath = fullfile([opts.saveResPath  '/sepOrient/']);

            if ~exist(TDPose_TmpSaveResultsConverted,'dir')
                mkdir(TDPose_TmpSaveResultsConverted);
            end
        
            parse_nn_human36m([ TDPose_TmpFileSavePath TDPose_EstiamtedAnnotationName], ...
            opts.saveResPath, TDPose_TmpSaveResultsConverted);
        
            %%%%%%%%%%%%%% Refinement of nearest neighbours %%%%%%%%%%%%%%%
            %              Poses are refined and saved                    %                                          
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % restore saveResPath
            opts.saveResPath = fullfile(TDPose_TmpSaveResults);
            opts.saveResPath = ...
            fullfile([opts.saveResPath opts.inputDB '_' opts.database svStr num2str(opts.round) '/']);

            tic;
            execString = './../MEX/src/eval_pose_human36m_bestscale_with_nn_and_assign_weights/eval_pose_human36m_bestscale_with_nn_and_assign_weights ';
            execString = [execString TDPose_ExperimentName ' ' int2str(TDPose_NTrees) ' '];
            execString = [execString TDPose_ConfigPath ' ' [TDPose_TmpFileSavePath TDPose_EstiamtedAnnotationName]];
            execString = [execString ' ' TDPose_TmpSaveResultsConverted];
            execString = [execString ' ' opts.saveResPath ' ' TDPose_RefinedEstimationFile];
            
            system(execString);
            toc;
            
            %%%%%%%%%%% Performing the final 3D Pose Estimation %%%%%%%%%%%
            %                                                             %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            opts.dataFormat = 'new';
            opts.extractFrameNum = targetGTFrame;                           % Specifies, which GT frame should be 
                                                                            % extracted
            
            opts.loadIdxPath = fullfile(TDPose_TmpSaveResults);
            opts.loadIdxPath = ...
                fullfile([opts.loadIdxPath opts.inputDB '_' opts.database svStr num2str(opts.round) '/']);
            opts.loadIdxPath = fullfile([opts.loadIdxPath  '/sepOrient/']);
            
            tmp_convertedFile = [opts.loadInPath H_dirFilesUm('Human36Mbm', ...
                                            opts.saveResPath,...
                                            TDPose_RefinedEstimationFile, ... 
                                            opts.dataFormat, ...
                                            opts.loadInPath)]; 
             
             load(tmp_convertedFile, '-mat');
             motIn2DRefined = motIn;
             
             fprintf('Performing 3D Pose Estimation...\n');        
             [err, optim, opts, motrecOpt] = recOnWeightedKernelH36Mbm(opts); 
             fprintf('Estimation error[mm]: %f\n', err.er3DPoseOpt.errFrAll);
             
             if(TDPose_VisualizeResults == 1)
                close all
                subplot(1,3,1)
                imshow(img_path);
                hold on
                motPlot2D(motIn2DEstimation);
                title('Estimated 2D Pose')
                hold off
                subplot(1,3,2)
                imshow(img_path);
                hold on
                motPlot2D(motIn2DEstimation);
                title('Refined 2D Pose')
                hold off
                subplot(1,3,3);
                motPlot3D(opts.inputDB, motrecOpt);
                title('Estimated 3D Pose')
                
             end
             if(TDPose_PauseAfterResult == 1)
                  fprintf('Press Any Key to continue\n');
                  pause;
             end
                         
            %%%%%%%%%%%%%%%%%%%%%%%%% Cleaning up %%%%%%%%%%%%%%%%%%%%%%%%%
            %                                                             %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            target = [TDPose_TmpFileSavePath TDPose_EstiamtedAnnotationName];
            source = [TDPose_TmpSaveResults opts.inputDB '_' opts.database svStr num2str(opts.round) '/' TDPose_RefinedEstimationFile];
            
            movefile(source, target);
            opts.dataFormat = 'old';
            opts.round = opts.round + 1;
           end  
            %%%%%%%%%%%%%%%%%%%%%% Final Cleaning up %%%%%%%%%%%%%%%%%%%%%%
            %                                                             %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

               % set new variables
               opts.round = 1;
               deleteStr = [TDPose_TmpFileSavePath  TDPose_EstiamtedAnnotationName];
               delete(deleteStr);
               deleteStr = [TDPose_TmpFileSavePath 'tmp_annotation.txt'];
               delete(deleteStr);
               
               %disp('Images Processed. Press Key for the next image');
               %pause;
               
%%%%%%%%%%%%%%%%%% END OF MAIN LOOP  %%%%%%%%%%%%%%%%%%

        end
      if(TDPose_DeleteFilesAfterEstimation == 1)
                deleteStr = TDPose_TmpFileSavePath;
                rmdir(deleteStr, 's');
                deleteStr = TDPose_TmpSaveResults;
                rmdir(deleteStr, 's');
       end
               
               
               
