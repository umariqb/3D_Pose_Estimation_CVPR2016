function feature = feature_AK_bool_bodyExtentExtremitiesRelXZ_robust(mot)

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));

lankle  = mot.jointTrajectories{trajectoryID(mot,'lankle')}([1 3],:);
rankle  = mot.jointTrajectories{trajectoryID(mot,'rankle')}([1 3],:);
lwrist  = mot.jointTrajectories{trajectoryID(mot,'lwrist')}([1 3],:);
rwrist  = mot.jointTrajectories{trajectoryID(mot,'rwrist')}([1 3],:);
headtop = mot.jointTrajectories{trajectoryID(mot,'headtop')}([1 3],:);
root    = mot.jointTrajectories{trajectoryID(mot,'root')}([1 3],:);

points = {lankle; rankle; lwrist; rwrist; headtop; root};

%%%% compute diameter of point set
diam = zeros(1,mot.nframes);
npoints = length(points);
for k=1:npoints-1
    for j=k+1:npoints
        diam = max(diam,sum((points{k} - points{j}).^2));
    end
end
diam = sqrt(diam);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

thresh1 = 3;
thresh2 = 3.25;

f1 = diam >= thresh1*humerus_length;
f2 = diam >= thresh2*humerus_length;

feature = features_combine_robust(f1,f2);
