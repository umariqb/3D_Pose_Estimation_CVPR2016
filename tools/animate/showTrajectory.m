function showTrajectory(varargin)
% showTrajectory(mot,trajname,linestyle,downsampling_fac)

switch (nargin)
    case 2
        mot = varargin{1};
        trajname = varargin{2};
        linestyle = 'red o';
        downsampling_fac = 1;
    case 3
        mot = varargin{1};
        trajname = varargin{2};
        linestyle = varargin{3};
        downsampling_fac = 1;
    case 4
        mot = varargin{1};
        trajname = varargin{2};
        linestyle = varargin{3};
        downsampling_fac = varargin{4};
    otherwise
        error('Wrong number of arguments!');
end
if (ischar(trajname))
    ID = trajectoryID(mot,trajname);
elseif (isnum(trajname))
    ID = trajname;
else
    error('Expected trajectory name or numeric trajectory ID!');
end

if (~ishold)
    hold;
end

plot3(mot.jointTrajectories{ID}(1,1:downsampling_fac:end),mot.jointTrajectories{ID}(2,1:downsampling_fac:end),mot.jointTrajectories{ID}(3,1:downsampling_fac:end),linestyle);