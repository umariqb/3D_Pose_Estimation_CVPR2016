function res=skriptDiffMarker(motMat,PCAmat,skel)

        
mot=motMat{1,1}.orgMot;

mot=changeFrameRate(skel,mot,30);
mot=fitMotion(skel,mot);

% mot=cutMot_jt(mot,motMat{a,b}.startFrame,motMat{a,b}.endFrame);
        
        
% res{1}.M_4_9       =reconstructMotionPCAbased ...
%                                 (skel,mot,PCAmat,[4 9]);
res{1}.M_4_22_29       =reconstructMotionPCAbased ...
                                (skel,mot,PCAmat,[4 22 29]);
                            
                            
% res{1}.M_29     =reconstructMotionPCAbased ...
%                                 (skel,mot,PCAmat,[29]);
%                             
% save('OtherJointsWalk.m','res');
%                             
% res{1}.M_4_29      =reconstructMotionPCAbased ...
%                                 (skel,mot,PCAmat,[4 29]);
%                                   
% res{1}.M_4_9_22  =reconstructMotionPCAbased ...
%                                 (skel,mot,PCAmat,[4 9 22]);

save('OtherJointsWalk.m','res');

mot=motMat{1,9}.orgMot;  
mot=changeFrameRate(skel,mot,30);
mot=fitMotion(skel,mot);
                            
% res{2}.M_4_9       =reconstructMotionPCAbased ...
%                                 (skel,mot,PCAmat,[4 9]);
                            
res{2}.M_4_22_29       =reconstructMotionPCAbased ...
                                (skel,mot,PCAmat,[4 22 29]);
                            
% res{2}.M_29     =reconstructMotionPCAbased ...
%                                 (skel,mot,PCAmat,[29]);
%                             
% save('OtherJointsWalk.m','res');
%                             
% res{2}.M_4_29      =reconstructMotionPCAbased ...
%                                 (skel,mot,PCAmat,[4 29]);
%                             
%                             
%                             
% res{2}.M_4_9_22  =reconstructMotionPCAbased ...
%                                 (skel,mot,PCAmat,[4 9 22]);

                            
save('OtherJointsWalk.m','res');

end
