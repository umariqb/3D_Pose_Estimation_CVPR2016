function velRel = feature_BD_velRelPoint(mot,p_name,p_rel_name,varargin)
% velAbs = feature_BD_velRelPoint(mot,p_name,p_rel_name,win_len_ms)
% NOTES: - Last velocity value is duplicated to maintain the length of the input sequence.
%        - Choosing win_len_ms<=1000/samplingRate amounts to no averaging at all.

switch nargin
    case 3
        win_len_ms = 100;        
    case 4
        if(isempty(varargin{1}))
            win_len_ms = 100;
        else
            win_len_ms = varargin{1};
        end
    otherwise
        error('Wrong number of arguments!');
end

win_len = ceil(win_len_ms/1000*mot.samplingRate);

if (win_len < 1)
    win_len = 1;
end

p = trajectoryID(mot,p_name);
p_rel = trajectoryID(mot,p_rel_name);
vel = diff((mot.jointTrajectories{p} - mot.jointTrajectories{p_rel})');

vel = vel';
vel = [vel vel(:,end)];

if (mot.nframes < win_len)
    vel = padarray(vel,[0 win_len - mot.nframes],'symmetric','post');
end

velAvg = padarray(vel,[0 ceil(win_len/2)],'symmetric','both');
velAvg_conv = zeros(3,size(velAvg,2)+win_len-1);
for k=1:3
    velAvg_conv(k,:) = conv(velAvg(k,:),(1/win_len)*ones(win_len,1));
end

velAvg = velAvg_conv(:,win_len+1:win_len+mot.nframes);
velRel = sqrt(sum((velAvg).^2)) * mot.samplingRate;
