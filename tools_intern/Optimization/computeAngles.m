function [angles,list] = computeAngles(skel,mot,joints)

list=cell(mot.njoints,1);

for i=1:size(skel.paths,1)
    for j=1:numel(skel.paths{i})
        if j==1
            list{skel.paths{i}(j)}= [list{skel.paths{i}(j)} skel.paths{i}(j+1)];
        elseif j<numel(skel.paths{i})
            list{skel.paths{i}(j)}= [list{skel.paths{i}(j)} skel.paths{i}(j-1) skel.paths{i}(j+1)];
        end
    end
end

list{21} = [20,22];
list{28} = [27,29];
list{14} = [13,15];
list{1}  = [2,12];

angles=cell(mot.njoints,1);
for i=joints
    if numel(list{i})==2
        v1 = mot.jointTrajectories{list{i}(1)}-mot.jointTrajectories{i};
        v2 = mot.jointTrajectories{list{i}(2)}-mot.jointTrajectories{i};
        v1 = v1./repmat(sqrt(sum(v1.^2)),3,1);
        v2 = v2./repmat(sqrt(sum(v2.^2)),3,1);
        angles{i} = real(acosd(dot(v1,v2)));
    end
end

