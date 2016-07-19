function angVelAbs = feature_angularVelAbsJoint(mot,j_name,varargin)
%angVelAbs = feature_angularVelJoint(mot,j_name,win_len_ms,frame_rate)

win_len_ms = 0;
frame_rate = mot.samplingRate;

if (nargin>3)
    frame_rate = varargin{2};
end
if (nargin>2)
    win_len_ms = varargin{1};
end

win_len = ceil(win_len_ms/1000*mot.samplingRate);

if (win_len < 1)
    win_len = 1;
end

j = DOFID(mot,j_name);

angVel = angularVelocity(mot.rotationQuat{j},frame_rate);
angVel = angVel{1};

if (mot.nframes < win_len)
    angVel = padarray(angVel,[0 win_len - mot.nframes],'symmetric','post');
end

angVelAvg = padarray(angVel,[0 ceil(win_len/2)],'symmetric','both');
angVelAvg_conv = zeros(3,size(angVelAvg,2)+win_len-1);
for k=1:3
    angVelAvg_conv(k,:) = conv(angVelAvg(k,:),(1/win_len)*ones(win_len,1));
end

angVelAvg = angVelAvg_conv(:,win_len+1:win_len+mot.nframes);

angVelAbs = sqrt(sum((angVelAvg).^2));

%figure;
%plot(angVelAbs);
