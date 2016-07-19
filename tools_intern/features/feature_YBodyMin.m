function feature = feature_YBodyMin(mot,varargin)

if (nargin>1)
    joints_exclude = varargin{1};
    joint_names = mot.nameMap(:,1)';
    [C,IA] = setdiff(joint_names,joints_exclude);
    nameMap = mot.nameMap(IA,:);
else
    nameMap = mot.nameMap;
end

Y = zeros(size(nameMap,1),mot.nframes);
for k=1:size(nameMap,1)
    Y(k,:) = mot.jointTrajectories{nameMap{k,3}}(2,:);
end
feature = min(Y,[],1);

% joints = {'root','lankle','ltoes','rankle','rtoes','lwrist','lfingers','rwrist','rfingers'};
% traj = mot.jointTrajectories;
% feature = inf*ones(1,mot.nframes);
% for k=1:length(joints)
%     feature = min(feature,traj{trajectoryID(mot,joints{k})}(2,:));
% end