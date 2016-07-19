function plotSimAnnPath(O,S,varargin)

switch nargin
    case 2
        v1=1;
        v2=4;
        v3=8;
    case 3
        v1=varargin{1};
        v2=4;
        v3=8;
    case 2
        v1=varargin{1};
        v2=varargin{2};
        v3=8;
    case 5
        v1=varargin{1};
        v2=varargin{2};
        v3=varargin{3};
    otherwise
        error('plotSimAnnPath: Wrong number of args!\n')
end

h=figure;
set(h,'Renderer','OpenGL');
xlim([min(S(:,v1)) max(S(:,v1))]);
ylim([min(S(:,v2)) max(S(:,v2))]);
zlim([min(S(:,v3)) max(S(:,v3))]);
hold all
plot3(S(:,v1),S(:,v2),S(:,v3),'.');
plot3(O(:,v1),O(:,v2),O(:,v3),'LineWidth',2,'Color',[1 0 0]);
grid on;
