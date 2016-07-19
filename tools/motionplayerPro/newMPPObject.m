% --
% creates a template for MotionplayerPro Objects
% fields required:
% - type (currently possible values: 'dot', 'cross', 'tetra'
% - data: matrix of size (3*nrOfObj x nrOfFrames)
% - samplingRate
% optional fields: (for default values see DEFAULTSCENE)
% - color
% - alpha
% - size
% 
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function object = newMPPObject()

% help newMPPObject;

object.type         = [];
object.data         = [];
object.samplingRate = [];
object.color        = [];
object.alpha        = [];
object.size         = [];
object.boundingBox  = [];