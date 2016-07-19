function [D,w,d]=SimpleDTW(fitmot,skel,mot)
% Applays a simple DTW on the given motions
% The motioons are warped with a quadratic DTW-Algo.
% The Distance Features are hard coded.
% author: Bjoern Krueger (kruegerb@cs.uni-bonn.de)

% Extract Params for DTW.
% m1Param=[   mot.rotationQuat{4}'    mot.rotationQuat{9}'    mot.rotationQuat{20}'    mot.rotationQuat{27}'];
% m2Param=[fitmot.rotationQuat{4}' fitmot.rotationQuat{9}' fitmot.rotationQuat{20}' fitmot.rotationQuat{27}'];



% m1Param=[ ... 
%             mot.rotationQuat{4}'          mot.rotationQuat{9}' ...
%             mot.rotationQuat{20}'         mot.rotationQuat{27}' ...
%             mot.jointTrajectories{ 6}'    mot.jointTrajectories{11}' ...   
%             mot.jointTrajectories{23}'    mot.jointTrajectories{30}' ...
%             ];
%         
% m2Param=[ ...
%              fitmot.rotationQuat{4}'       fitmot.rotationQuat{9}' ...
%              fitmot.rotationQuat{20}'      fitmot.rotationQuat{27}' ...
%              fitmot.jointTrajectories{ 6}' fitmot.jointTrajectories{11}' ...
%              fitmot.jointTrajectories{23}' fitmot.jointTrajectories{30}' ...
%              ];

% m1Tmp=[ ... 
%             mot.jointTrajectories{ 6}'    mot.jointTrajectories{11}' ...   
%             mot.jointTrajectories{23}'    mot.jointTrajectories{30}' ...
%       ];
% m1Tmp2=m1Tmp/max(sqrt(sum(m1Tmp.*m1Tmp,2)));
% m1Tmp=[ ... 
%             mot.rotationQuat{4}'          mot.rotationQuat{9}' ...
%             mot.rotationQuat{20}'         mot.rotationQuat{27}' ...
%       ];
% m1Tmp3=m1Tmp/max(sqrt(sum(m1Tmp.*m1Tmp,2)));
% m1Param=[m1Tmp2 m1Tmp3];
% % m1Param=m1Tmp3;
% 
% m2Tmp=[ ... 
%             fitmot.jointTrajectories{ 6}'    fitmot.jointTrajectories{11}' ...   
%             fitmot.jointTrajectories{23}'    fitmot.jointTrajectories{30}' ...
%       ];
% m2Tmp2=m2Tmp/max(sqrt(sum(m2Tmp.*m2Tmp,2)));
% m2Tmp=[ ... 
%             fitmot.rotationQuat{4}'       fitmot.rotationQuat{9}' ...
%              fitmot.rotationQuat{20}'     fitmot.rotationQuat{27}' ...
%       ];
% m2Tmp3=m2Tmp/max(sqrt(sum(m2Tmp.*m2Tmp,2)));
% m2Param=[m2Tmp2 m2Tmp3];
% m2Param=m2Tmp3;

m1Param=zeros(4*   mot.njoints,   mot.nframes);
m2Param=zeros(4*fitmot.njoints,fitmot.nframes);
for j=[4 9 20 27]%1:mot.njoints
    m1Param(j*4-3:j*4,:)=   mot.rotationQuat{j};
    m2Param(j*4-3:j*4,:)=fitmot.rotationQuat{j};
end


% [Dist,D,k,w,d]=dtw(m2Param',m1Param');
[D,w,d]=pointCloudDTW(fitmot,mot,'positions',2:29,5);
%plotMinimaPositions(d);
% figure;
%  plotDTWPath(d,w);
plotDTWPath(D,w);

%mot=warpMotion(w,skel,mot);

% Warp Position:
% rootMove=warp(w,mot.rootTranslation')';
% dim=size(rootMove);
% mot.rootTranslation=rootMove;
% 
% for i=1:mot.njoints
%     if(~isempty(mot.rotationQuat{i}))
%         mot.rotationQuat{i}=warp(w,mot.rotationQuat{i}')';
%     end
% end
% mot.rotationQuat=mot.rotationQuat';

%Cleanup of motion
%mot=cutMot(skel,mot,1,dim(2));
