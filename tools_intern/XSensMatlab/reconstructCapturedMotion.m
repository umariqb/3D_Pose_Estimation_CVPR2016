function [recMot,coeffs] = reconstructCapturedMotion(Tensor,capturedMot,varargin)

switch nargin
    case 2
        consideredJoints=capturedMot.animated';
        actor=1;
    case 3
        actor=varargin{1};
        consideredJoints=capturedMot.animated';
    case 4
        actor=varargin{1};
        consideredJoints=varargin{2};
    otherwise
        error('Wrong number of input arguments!');
end

% marker positions on hands are better described by jointIDs 23 and 30
consideredJoints_tmp=consideredJoints;
consideredJoints(consideredJoints==21)=23;
consideredJoints(consideredJoints==28)=30;
capturedMot=correctJoints(capturedMot,consideredJoints_tmp,consideredJoints);

fprintf('\n');
if isfield(Tensor,'averageJointAccelerations')
    averAcce        = Tensor.averageJointAccelerations;
    [s,m]           = reconstructMotion_jt(Tensor,[1,actor,1]);
else
    fprintf('Computing average accelerations out of Tensor...\n');
    [s,m,averAcce]  = reconstructAllMotions_jt(Tensor,consideredJoints);
    s               = s{1,actor,1};
    m               = m{1,actor,1};
    fprintf('...done.\n');
end

capturedMot         = changeFrameRate(s,capturedMot,m.samplingRate);

fprintf('\nFinding subsequence of captured motion...\n');
[capturedMot.jointAccelerations,startOS,endOS] = ...
    findMotionSequence(averAcce,capturedMot.jointAccelerations,consideredJoints);
fprintf('...done. Start frame: %i, end frame: %i\n',startOS,endOS);

capturedMot_unwarped = capturedMot;

counter=0;
for i=consideredJoints
    counter=counter+1;
    figure(1);
    subplot(4,length(consideredJoints),counter);
    plot(capturedMot.jointAccelerations{i}(2,:),'r');
    hold on;
    plot(averAcce{i}(2,:),'b');
    hold off;
end
drawnow;

% Warpen der aufgenommenen Bewegung
fprintf('\nWarping the captured motion...\n');
[D,w]       = pointCloudDTW_jt(m,capturedMot,'a',capturedMot.animated',0);
capturedMot = warpMotion(w,s,capturedMot);
fprintf('...done.\n');

for i=consideredJoints
    counter=counter+1;
    figure(1);
    subplot(4,length(consideredJoints),counter);
    plot(capturedMot.jointAccelerations{i}(2,:),'r');
    hold on;
    plot(averAcce{i}(2,:),'b');
    hold off;
end
drawnow;

fprintf('\nComputing coefficients for reconstructing the captured motion...\n');
[coeffs,recMot]     = findCoefficients_jt(Tensor,capturedMot,s,'a',consideredJoints,consideredJoints(1));
recMot              = convert2euler(s,recMot);
fprintf('...done.\n');

for i=consideredJoints
    counter=counter+1;
    figure(1);
    subplot(4,length(consideredJoints),counter);
    plot(capturedMot.jointAccelerations{i}(2,:),'r');
    hold on;
    plot(recMot.jointAccelerations{i}(2,:),'g');
    hold off;
end
drawnow;

% Unwarpen der rekonstruierten Bewegung
fprintf('\nUnwarping the captured motion...\n');
[D,w]   = pointCloudDTW_jt(capturedMot_unwarped,recMot,'a',consideredJoints,0);
recMot  = warpMotion(w,s,recMot);
% recMot = warpMotion(fliplr(w),s,recMot);
fprintf('...done.\n');

recMot  = removeSkating(recMot);

for i=consideredJoints
    counter=counter+1;
    figure(1);
    subplot(4,length(consideredJoints),counter);
    plot(capturedMot_unwarped.jointAccelerations{i}(2,:),'r');
    hold on;
    plot(recMot.jointAccelerations{i}(2,:),'g');
    hold off;
end
drawnow;