%close all;

[skel,mot] = readMocapD(155);

%feature = feature_bool_handTouch(mot);
%feature = feature_bool_handLegTouch(mot);
%feature = feature_bool_velPoint(mot,'root','');        % vel_abs_root
%feature = feature_bool_velPoint(mot,'headtop','neck');        

feature_right = feature_bool_footRightLift(mot);
feature_left = feature_bool_footLeftLift(mot);

% feature_right = feature_bool_distPointSegment(mot,'neck','headtop','rfingers',1);
% feature_left = feature_bool_distPointSegment(mot,'neck','headtop','lfingers',1);

figure;
subplot(3,1,1)
plot((feature_left))
axis([1 mot.nframes 0 1.1]);
subplot(3,1,2)
plot((feature_right),'red')
axis([1 mot.nframes 0 1.1]);
subplot(3,1,3)
plot(and((feature_left),(feature_right)),'black')
axis([1 mot.nframes 0 1.1]);

%feature = feature_angularVelAbsJoint(mot,'head',100);
%feature = feature_bool_torsoBent(mot);
%figure;
%plot(feature);
%set(gca,'ylim',[0 1.1]);
%[feature,d] = feature_bool_distPointSegment(mot,'lknee','lankle','rfingers',1);








%velAbs = feature_velAbsPoint(mot,'ltoes',0);
%velAvg = feature_velAvgPoint(mot,'ltoes',12);

%feature_left = feature_bool_footLeftHighVel(mot);
%feature_right = feature_bool_footRightHighVel(mot);
%feature_left = feature_bool_handLeftHighVel(mot);r_lengths*thresh
%feature_right = feature_bool_handRightHighVel(mot);
%feature_left = feature_bool_handLeftHighVelRel(mot,'lwrist');
%feature_right = feature_bool_handRightHighVelRel(mot,'rwrist');
% feature_left = feature_bool_HighVelRel(mot,'lfingers','lshoulder',120);
% feature_right = feature_bool_HighVelRel(mot,'rfingers','rshoulder',120);


% figure;
% subplot(3,1,1)
% plot(not(feature_left))
% axis([1 mot.nframes 0 1.1]);
% subplot(3,1,2)
% plot(not(feature_right),'red')
% axis([1 mot.nframes 0 1.1]);
% subplot(3,1,3)
% plot(and(not(feature_left),not(feature_right)),'black')
% axis([1 mot.nframes 0 1.1]);
