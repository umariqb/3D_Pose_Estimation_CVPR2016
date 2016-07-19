function motPlot2D(motData)

pinkish  = [1, 0.6 0.78];     % used for blue arm
brownish = [1, 0.69, 0.39];   % other arm
redk     = 'r';               % blue side wali leg
jamni    = [.48,.06,.89];     % other side wali leg
gr       = 'g';               % used for head to root

%%
allJoints = motData.jointNames;
jnt.njoints = length(allJoints);
jnt.hd = getSingleJntIdx('Head',allJoints,1);
jnt.nk = getSingleJntIdx('Neck',allJoints,1);
jnt.ls = getSingleJntIdx('Left Shoulder',allJoints,1);
jnt.rs = getSingleJntIdx('Right Shoulder',allJoints,1);
jnt.rh = getSingleJntIdx('Right Hip',allJoints,1);
jnt.lh = getSingleJntIdx('Left Hip',allJoints,1);
jnt.rk = getSingleJntIdx('Right Knee',allJoints,1);
jnt.lk = getSingleJntIdx('Left Knee',allJoints,1);
jnt.ra = getSingleJntIdx('Right Ankle',allJoints,1);
jnt.la = getSingleJntIdx('Left Ankle',allJoints,1);
jnt.re = getSingleJntIdx('Right Elbow',allJoints,1);
jnt.le = getSingleJntIdx('Left Elbow',allJoints,1);
jnt.rw = getSingleJntIdx('Right Wrist',allJoints,1);
jnt.lw = getSingleJntIdx('Left Wrist',allJoints,1);


inp2d    = cell2mat(motData.jointTrajectories2D);
x  = inp2d(1:2:end,1);
y  = inp2d(2:2:end,1);
H_drawLineH36M(jnt, x, y)
end


