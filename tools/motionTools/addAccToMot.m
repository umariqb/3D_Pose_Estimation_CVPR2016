% function mot = addAccToMot(mot)
% computes joint accelerations in each frame and adds the field
% 'jointAccelerations' to mot structure
% additionally filters the computed accelerations with binomial filter
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function mot = addAccToMot(mot,varargin)

if nargin==2
    filterSize = varargin{1};
else
    filterSize = min(floor(mot.samplingRate/10),floor(mot.nframes/2));
end

if iscell(mot.jointTrajectories)
    jointTrajectories   = cell2mat(mot.jointTrajectories);
else
    jointTrajectories   = mot.jointTrajectories;
end
jointAccelerations  = zeros(size(jointTrajectories));

% padding
jointTrajectories = [   3*jointTrajectories(:,1)-2*jointTrajectories(:,2),...
                        2*jointTrajectories(:,1)-jointTrajectories(:,2),...
                        jointTrajectories,...
                        2*jointTrajectories(:,end)-jointTrajectories(:,end-1),...
                        3*jointTrajectories(:,end)-2*jointTrajectories(:,end-1)];
                    
% 5-point derivation
weights = [-1 16 -30 16 -1];
for frame = 3:mot.nframes+2
    jointAccelerations(:,frame-2) = ...
          weights(1) * jointTrajectories(:,frame-2) ...
        + weights(2) * jointTrajectories(:,frame-1) ...
        + weights(3) * jointTrajectories(:,frame)   ...
        + weights(4) * jointTrajectories(:,frame+1) ...
        + weights(5) * jointTrajectories(:,frame+2);
end  
jointAccelerations = jointAccelerations / (12 * mot.frameTime^2);

% filtering accelerations
jointAccelerations = filterTimeline(jointAccelerations,filterSize,'bin');

mot.jointAccelerations = mat2cell(jointAccelerations,3*ones(1,mot.njoints),mot.nframes);