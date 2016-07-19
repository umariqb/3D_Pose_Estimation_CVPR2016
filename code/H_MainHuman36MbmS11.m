function H_MainHuman36MbmS11
%%
svpath = 'D:\Work\Human36Mbm\GT\';

%%
database = H36MDataBase.instance;
%P3D = cdfread('I:\1_Datasets\Human3.6M\Training\S1\MyPoseFeatures\D3_Positions\Directions 1.cdf');

SelectedSubjects = 11; %[1, 5, 6, 7,8,9];
Features{1}      = H36MPose2DPositionsFeature();
Features{2}      = H36MPose3DPositionsFeature();
Features{3}      = H36MPose3DAnglesFeature();
%Features{4}      = H36MPose3DPositionsFeature('Relative',true);
tframe = 0;

motGT              = H_emptyMotion3D;
motGT.database     = 'Human36Mbm';
motGT.jointNames   = H_myFormatJoints(motGT.database);
motGT.jNamesAll    = {'Root'; 'Right Hip'; 'Right Knee'; 'Right Ankle'; 'RightToeBase'; 'Site' ; 'Left Hip'; 'Left Knee';
    'Left Ankle'; 'LeftToeBase'; 'Site'; 'Spine'; 'Abdomen'; 'Neck'; 'Chin'; 'Head'; 'LeftShoulder NeckBack';
    'Left Shoulder'; 'Left Elbow';  'Left Wrist'; 'LeftHandThumb';'Site';'L_Wrist_End';'Site';'RightShoulder NeckBack';
    'Right Shoulder';'Right Elbow';'Right Wrist'; 'RightHandThumb';'Site';'R_Wrist_End';'Site'};
motGT.selJoints    = H_getSingleJntIdx(motGT.jointNames,motGT.jNamesAll,1);
motGT.njoints      = length(motGT.jointNames);

frame_count      = 0;
for sIdx = 1:length(SelectedSubjects)
    for aIdx = 2:length(database.actions)  % starts from 2
        for saIdx = 1:length(database.subactions)
            s       = SelectedSubjects(sIdx);
            a       = database.actions(aIdx);
            sa      = database.subactions(saIdx);
            nframes = database.getNumFrames(s,a,sa);
            for c = 2:2
                Sequence         = H36MSequence(s, a, sa, c);
                vidfeat          = H36MRGBVideoFeature();
                da               = vidfeat.serializer(Sequence);
                
                for f = 1:64:nframes
                    fprintf('%4d ', f);
                    frame_count = frame_count + 1;
                    Sequence    = H36MSequence(s, a, sa, c, f);
                    F           = H36MComputeFeatures(Sequence, Features);
                    Subject     = Sequence.getSubject();
                    %======================================================   %3D data
                    posSkel     = Subject.getPosSkel();
                    angSkel     = Subject.getAnglesSkel();
                    %joints3d   = bvh2xyz(posSkel, F{2});
                    joints3d    =  reshape(F{2},3,[])';
                    %joints3d   =  reshape(F{4},3,[])';
                    joints3d    = joints3d(motGT.selJoints,:);
                    
                    
                    
                    %======================================================   %2D data
                    pos2dSkel   = Subject.get2DPosSkel();
                    joints2d    = bvh2xy(pos2dSkel, F{1});
                    joints2d    = joints2d(motGT.selJoints,:);
                    
                    motGT.activityName{frame_count,1} = Sequence.getBaseName; 
                    motGT.activityName{frame_count,1}(motGT.activityName{frame_count,1} == ' ') = [];
                    motGT.activityFrNum(frame_count,1) = a-1;   % actions starts from 2
                    motGT.activityFrNum(frame_count,2) = f;
                    motGT.activityFrNum(frame_count,3) = f;
                    
                    for j = 1:motGT.njoints
                        motGT.jointTrajectories{j,1}(1,frame_count) =  double(joints3d(j,1));
                        motGT.jointTrajectories{j,1}(2,frame_count) =  double(joints3d(j,3));      %
                        motGT.jointTrajectories{j,1}(3,frame_count) =  double(joints3d(j,2));      %
                    end
                    for j = 1:motGT.njoints
                        motGT.jointTrajectories2D{j,1}(1,frame_count) =  double(joints2d(j,1));
                        motGT.jointTrajectories2D{j,1}(2,frame_count) =  double(joints2d(j,2));
                    end
                    
                    im          = da.getFrame(f); 
                    imName     = [svpath 'S11_im\' 'S11_im_' num2str(frame_count) '_' num2str(f) '.png'];
                    imwrite(im,imName);
                    
                    %======================================================  % 3D data projection
                    %plot3(joints3d(:,1),joints3d(:,2),joints3d(:,3),'o','MarkerSize',2, 'MarkerEdgeColor','k','MarkerFaceColor','r'); axis equal
                    
                    %                     obj     = Sequence.getCamera();
                    %                     [PX, D] = ProjectPointRadial(joints3d, obj.R, obj.T, obj.f, obj.c, obj.k, obj.p);
                    %                     PX      = PX';
                    %                     PX      = PX(:);
                    %                     im          = da.getFrame(f);
                    %                     pos2dSkel   = Subject.get2DPosSkel();
                    %                     %  figure(2); imshow(im); show2DPose(PX, pos2dSkel); title('3d positions ');
                    %                     %  Camera     = Sequence.getCamera();
                    %                     %  figure(2); imshow(im); show2DPose(Camera.project(F{2}),pos2dSkel); title('3d positions ');
                    %
                    %                     im          = da.getFrame(f);
                    %======================================================
                    fprintf('\b\b\b\b\b');
                    %%
                    if(0)
                        right_ankle    = joints2d(H_getSingleJntIdx('Right Ankle'   ,mot.jointNames,1),:);
                        right_knee     = joints2d(H_getSingleJntIdx('Right Knee'    ,mot.jointNames,1),:);
                        right_hip      = joints2d(H_getSingleJntIdx('Right Hip'     ,mot.jointNames,1),:);
                        left_hip       = joints2d(H_getSingleJntIdx('Left Hip'      ,mot.jointNames,1),:);
                        left_knee      = joints2d(H_getSingleJntIdx('Left Knee'     ,mot.jointNames,1),:);
                        left_ankle     = joints2d(H_getSingleJntIdx('Left Ankle'    ,mot.jointNames,1),:);
                        right_wrist    = joints2d(H_getSingleJntIdx('Right Wrist'   ,mot.jointNames,1),:);
                        right_elbow    = joints2d(H_getSingleJntIdx('Right Elbow'   ,mot.jointNames,1),:);
                        right_shoulder = joints2d(H_getSingleJntIdx('Right Shoulder',mot.jointNames,1),:);
                        left_shoulder  = joints2d(H_getSingleJntIdx('Left Shoulder' ,mot.jointNames,1),:);
                        left_elbow     = joints2d(H_getSingleJntIdx('Left Elbow'    ,mot.jointNames,1),:);
                        left_wrist     = joints2d(H_getSingleJntIdx('Left Wrist'    ,mot.jointNames,1),:);
                        neck           = joints2d(H_getSingleJntIdx('Neck'          ,mot.jointNames,1),:);
                        head_top       = joints2d(H_getSingleJntIdx('Head'          ,mot.jointNames,1),:);
                        figure(1);
                        imshow(im);
                        hold on
                        f1 = F{1,1};
                        plot(f1(1:2:end),f1(2:2:end),'o','MarkerSize',2, 'MarkerEdgeColor','k','MarkerFaceColor','r');
                        hold off
                        line([head_top(1), neck(1)], [head_top(2), neck(2)]);
                        line([neck(1), left_shoulder(1)], [neck(2), left_shoulder(2)]);
                        line([neck(1), right_shoulder(1)], [neck(2), right_shoulder(2)]);
                        % arms
                        line([left_shoulder(1), left_elbow(1)], [left_shoulder(2), left_elbow(2)]);
                        line([left_elbow(1), left_wrist(1)], [left_elbow(2), left_wrist(2)]);
                        line([right_shoulder(1), right_elbow(1)], [right_shoulder(2), right_elbow(2)]);
                        line([right_elbow(1), right_wrist(1)], [right_elbow(2), right_wrist(2)]);
                        % hips
                        line([left_hip(1), right_hip(1)], [left_hip(2), right_hip(2)]);
                        % hips to legs
                        line([left_hip(1), left_knee(1)], [left_hip(2), left_knee(2)]);
                        line([right_hip(1), right_knee(1)], [right_hip(2), right_knee(2)]);
                        line([left_knee(1), left_ankle(1)], [left_knee(2), left_ankle(2)]);
                        line([right_knee(1), right_ankle(1)], [right_knee(2), right_ankle(2)]);
                    end
                    
                    %pause(0.201);
                end % frames                
            end % camera
        end % subaction
    end % action
end % subject
%%


motGT.samplingRate = 200;
motGT.frameTime    = 1/motGT.samplingRate;
motGT.subject      = s;
motGT.action       = Sequence.BaseName;
motGT.action       = strrep(motGT.action,' ','_');
motGT.actionNum    = a;
motGT.subaction    = sa;
motGT.filename     = 'all files';
motGT.actName      = 'Activity_All';
motGT.camera       = Sequence.getCamera();
motGT.nframes      = frame_count;

motGT.skel         = posSkel.tree(motGT.selJoints,:);
motGT.skel2D       = pos2dSkel.tree(motGT.selJoints,:);
motGT.comments     = 'Order was not according to CMU and HDM05 in original file so order has been changed';
%%
if ~exist(svpath,'dir')
    mkdir(svpath);
end

strn = 'motGT_S11_Activity_All_C2';
save(fullfile(svpath,strn),'motGT','-v7.3');
disp([strn  '.... done']);
tframe = tframe + motGT.nframes;
disp(['total frames becomes:  ... ' num2str(tframe) ' ... ']);

end
