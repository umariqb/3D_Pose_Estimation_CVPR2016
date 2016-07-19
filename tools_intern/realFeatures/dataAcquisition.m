function theData = dataAcquisition(skel, mot, features, varargin)
% theData = dataAcquisition(skel, mot, featureSet, verbose)
%
% feature extraction resp. data acquisition, based on feature set and
% feature type with optional text output
% 
% INPUT
%   skel ......... (struct) containing the skeleton data (from parser)
%   mot .......... (struct) containing the motion data (from parser)
%   featureSet ... (struct) feature set and feature type
%   verbose ...... (boolean) optional,
%                  true  => with text output (default)
%                  false => without text output
%
% OUTPUT
%   theData ...... (matrix, [dim x ndata]) containing the data
%
% EXAMPLE
%    theData = dataAcquisition(skel, mot, selectFeatures('jointAngle'))
%

switch nargin
    case 3
        b_verbose = true;
    case 4
        b_verbose = varargin{1};
    otherwise
        error('*** wrong number of input arguments ***');
end

switch lower(features.featureType)
    case 'jointangle' % jointAngle
        dim = size(features.featureSet,1);
        ndata = mot.nframes;
        theData = zeros(dim, ndata);
        theData = dataAcquisition_jointAngle(theData, mot, features.featureSet, 1, b_verbose);
    case 'relational';
        dim = size(features.featureSet,1);
        ndata = mot.nframes;
        theData = zeros(dim, ndata);
        theData = dataAcquisition_relational(mot, features.featureSet, b_verbose);
    case {'bk', 'bk_scaled', 'bk_original'}
        dim = size(features.featureSet,1);
        ndata = mot.nframes;
        theData = zeros(dim, ndata);
        theData = dataAcquisition_bk(mot, features.featureSet, b_verbose);
        switch lower(features.featureType)
            case {'bk_scaled'}
                % temp = theData;
                % ohne Logarithmierung Wertebereichspanne zu groﬂ
                theData = log(theData+eps);
                % % theData(find(temp<=1)) = eps;
            otherwise
        end
        % die ersten und letzten 5 frames sind allesamt 0
        theData = theData(:,6:end-5);
    otherwise
        error(['** no such feature, ' features.featureType '.**']);
end

%end % of function gmm_dataAcquisition
