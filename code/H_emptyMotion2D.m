function mot = H_emptyMotion2D
%%
mot = struct('inputDB','',...                  % which input used
    'inFeatType','',...                        % which feature method are used like (MoP model)
    'njoints',0,...                            % number of joints
    'nframes',0,...                            % number of frames
    'frameTime',nan,...                        % inverse sampling rate: time per frame (in seconds)
    'samplingRate',nan,...                     % sampling rate (in Hertz) (120 Hertz is Carnegie-Mellon Mocap-DB standard)
    'jointTrajectories2D',cell(1,1),...        % 2D joint trajectories
    'jointNames',cell(1,1),...                 % cell array of joint names: maps node ID to joint name
    'markerNames',cell(1,1),...                % cell array of marker names:
    'boundingBox',[],...                       % bounding box (given a specific skeleton)
    'filename','', ...                         % filename
    'vidStartFrame',nan,...                    % starting video frames
    'vidEndFrame',nan,...                      % ending video frames
    'mocStartFrame',nan,...                    % starting Mocap frames
    'mocEndFrame',nan,...                      % ending Mocap frame
    'frameNumbers',[],...
    'dimData',nan,...                          % dimentions
    'knnWts',[]);                              % weights of knn
end