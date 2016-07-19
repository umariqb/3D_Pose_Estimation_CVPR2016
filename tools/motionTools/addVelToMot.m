% function mot = addVelToMot(mot)
% computes joint velocities in each frame and adds the field
% 'jointVelocities' to mot structure
% additionally filters the computed velocities with binomial filter
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function mot = addVelToMot(mot,varargin)

if nargin==2
    filterSize = varargin{1};
else
    filterSize = min(floor(mot.samplingRate/10),floor(mot.nframes/2));
end

if iscell(mot.jointTrajectories)
    jointTrajectories   = double(cell2mat(mot.jointTrajectories));
else
    jointTrajectories   = mot.jointTrajectories;
end

jointVelocities     = zeros(size(jointTrajectories));

if mot.nframes>1
    % padding
    jointTrajectories = [   3*jointTrajectories(:,1)-2*jointTrajectories(:,2),...
                            2*jointTrajectories(:,1)-jointTrajectories(:,2),...
                            jointTrajectories,...
                            2*jointTrajectories(:,end)-jointTrajectories(:,end-1),...
                            3*jointTrajectories(:,end)-2*jointTrajectories(:,end-1)];

    % 5-point derivation
    weights = [1 -8 0 8 -1];
    for frame = 3:mot.nframes+2
        jointVelocities(:,frame-2) = ...
                  weights(1) * jointTrajectories(:,frame-2) ...
                + weights(2) * jointTrajectories(:,frame-1) ...
                + weights(3) * jointTrajectories(:,frame)   ...
                + weights(4) * jointTrajectories(:,frame+1) ...
                + weights(5) * jointTrajectories(:,frame+2);
    end  
    jointVelocities = jointVelocities / (12 * mot.frameTime);

    % filtering velocities
    jointVelocities = filterTimeline(jointVelocities,filterSize,'bin');

end

mot.jointVelocities = mat2cell(jointVelocities,3*ones(1,mot.njoints),mot.nframes);