function skelBones = extractSkelBones( mot)

% bones = { {'LSHO', 'LELB'}, {'LKNE', 'LANK'}, {'LFWT', 'LKNE'}, {'LELB', 'LFRM'}, {'LFRM', 'LWRB'}, {'LSHO', 'CLAV'}, ... 
%           {'RSHO', 'RELB'}, {'RKNE', 'RANK'}, {'RFWT', 'RKNE'}, {'RELB', 'RFRM'}, {'RFRM', 'RWRB'}, {'RSHO', 'CLAV'} };
% % bones = { {'neck', 'lclavicle'}, {'lclavicle', 'lshoulder'}, {'lshoulder', 'lelbow'}, {'lelbow', 'lwrist'}, {'lwrist', 'lfingers'}, ...
% %           {'neck', 'rclavicle'}, {'rclavicle', 'rshoulder'}, {'rshoulder', 'relbow'}, {'relbow', 'rwrist'}, {'rwrist', 'rfingers'}, ...
% %           {'root', 'lhip'}, {'lhip', 'lknee'}, {'lknee', 'lankle'}, {'lankle', 'ltoes'}, ... 
% %           {'root', 'rhip'}, {'rhip', 'rknee'}, {'rknee', 'rankle'}, {'rankle', 'rtoes'}, ... 
% %           {'root', 'belly'}, {'belly', 'chest'}, {'chest', 'neck'}, {'neck', 'head'}, {'head', 'headtop'} }; 
      
      
bones = { {'Neck', 'Left Shoulder'}, {'Left Shoulder', 'Left Elbow'}, {'Left Elbow', 'Left Wrist'}, ...
          {'Neck', 'Right Shoulder'}, {'Right Shoulder', 'Right Elbow'}, {'Right Elbow', 'Right Wrist'},  ...
          {'Left Hip', 'Left Knee'}, {'Left Knee', 'Left Ankle'}, ... 
          {'Left Hip', 'Right Hip'}, {'Right Hip', 'Right Knee'}, {'Right Knee', 'Right Ankle'}, ... 
          {'Left Hip', 'Left Shoulder'}, {'Left Hip', 'Right Shoulder'}, {'Neck', 'Head'}};       

% names{:,1} = nameMap{:,1};
for i=1:length(bones)
    j1 = bones{i}(1);
    j2 = bones{i}(2);
    idx1 = find(strcmp(j1, mot.jointNames(:)));
    idx2 = find(strcmp(j2, mot.jointNames(:)));
%     idx1 = strmatch(j1, nameMap{:,1}, 'exact');
%     idx2 = strmatch(j2, nameMap(:,1), 'exact');
    
    skelBones{i}(1) = mot.nameMap{idx1(1,1),3};
    skelBones{i}(2) = mot.nameMap{idx2(1,1),3};
end
    