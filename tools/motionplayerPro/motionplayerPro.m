% MOTIONPLAYERPRO(varargin)
%
% tool for visualizing motions in MATLAB
% 
% motionplayerPro('skel',skels,'mot',mots,'obj',objects)
% with
% - skels being a cell array containing multiple skeleton structs 
%      OR being a single skeleton struct (not necessarily bound into a cell array)
% - mots  being a cell array containing multiple motion structs
%      OR being a single motion struct (not necessarily bound into a cell array)
% - objects (...to be continued)
%
% Note: 
% - The order of the parameters is irrelevant!
% - Default settings can be adjusted in the function defaultSCENE
% 
% Author: Jochen Tautges (tautges@cs.uni-bonn.de)
% (work based on the function "motionplayer" implemented by Jörg Hoffmann)
%
% see also: DEFAULTSCENE, ADDOBJTOSCENE, MPP_GUI, MPP_START

function h = motionplayerPro(varargin)

    global SCENE;
    SCENE               = defaultSCENE();
    SCENE.handles.fig   = MPP_GUI();

    set(SCENE.handles.fig,'Color',SCENE.colors.backgroundColor);
    
    addObjToSCENE(varargin{:});
    clear varargin;
    drawnow();
    
    MPP_start();
    
    h = SCENE.handles.fig;
end