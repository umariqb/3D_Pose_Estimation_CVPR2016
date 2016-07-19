function plotIntegratedPositions(skel,mot,joints,sensors)

g = 9.8112;

if mot.nframes~=size(sensors.xsens.rawCalData{1},1)
    error('Data mismatch!');
end

mot     = addVelToMot(mot);
mot     = addAccToMot(mot);
joints  = sort(joints);

% acc = diff(posSensor,2,2)/mot.frameTime^2;
% acc = filterTimeline(acc,10,'bin');

dataNotZero = sum(~sensors.xsens.rawOriData{1}')~=4;
nframes     = sum(dataNotZero);
njoints     = numel(joints);

accSensor   = cell(njoints,1);
c           = 1;
for i=joints
    
    id      = find(cellfun(@(x) x==i, sensors.xsens.MT_jointIDs));
    if isempty(id), error('Selected joint had not been tracked!'); end
    
    quat    = sensors.xsens.rawOriData{id}(dataNotZero,:)';
    accL    = sensors.xsens.rawCalData{id}(dataNotZero,1:3)';
    accSensor{c} = C_quatrot(accL,quat)-repmat([0;0;g],1,nframes);
    accSensor{c} = accSensor{c}([2 3 1],:);

    c = c+1;
end

velVicon     = cell2mat(mot.jointVelocities(joints)); % m/s^2
velVicon     = velVicon(:,dataNotZero)*100/2.54;

accVicon     = cell2mat(mot.jointAccelerations(joints)); % m/s^2
accVicon     = accVicon(:,dataNotZero);
accVicon     = reshape(accVicon,3,nframes*numel(joints));

accSensor        = cell2mat(accSensor); % m/s^2
accSensor        = reshape(accSensor,3,nframes*njoints);

[d,theta,x0,z0,accSensor] = pointCloudDist_modified(accVicon,accSensor,'acc');

% fprintf('Theta = %.4f\n',theta);

% figure
% plot(accVicon(2,:));
% hold all;
% plot(accSensor(2,:));

accSensor   = reshape(accSensor,3*njoints,nframes);
accVicon    = reshape(accVicon,3*njoints,nframes);

accSensor   = accSensor*100/2.54;
accVicon    = accVicon*100/2.54;

posOrig             = cell2mat(mot.jointTrajectories(joints));

posSensor           = posOrig(:,dataNotZero);
posSensor(:,3:end)  = 0;
posVicon            = posSensor;
% x0=posSensor(:,1);
% acc = cell2mat(mot.jointAccelerations(joints))*100/2.54;

for i=2:nframes
    if i>2
        posSensor(:,i)  = -posSensor(:,i-2) + 2*posSensor(:,i-1) + accSensor(:,i-2)*mot.frameTime^2;
        %     posVicon(:,i)   = -posVicon(:,i-2) + 2*posVicon(:,i-1) + accVicon(:,i-2)*mot.frameTime^2;
    end
    posVicon(:,i)   = posVicon(:,i-1) + velVicon(:,i-1)*mot.frameTime + accVicon(:,i-1)*mot.frameTime^2;
end

motionplayer('skel',{skel},'mot',{mot});
hold all 

c = 1;
for i=1:njoints
    plot3(posOrig(c,:),posOrig(c+1,:),posOrig(c+2,:),'.','color','green');
    plot3(posSensor(c,:),posSensor(c+1,:),posSensor(c+2,:),'.','color','blue');
    plot3(posVicon(c,:),posVicon(c+1,:),posVicon(c+2,:),'.','color','red');
    c = c+3;
end