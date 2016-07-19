function [sFeatures, aDescription] = selectFeatures(strFeature, iWhich)
% features = selectFeatures(feature, which)
%
% returns a struct containing the feature set for the selected feature and
% the feature type
%
% INPUT
%   feature .... (string) feature type, possible choices: 
%                'jointAngle', 'relational', 
%                'bk' (bzw. 'bk_scaled', 'bk_original')
%   which ...... (vector) optional. 
%                If specified it restricts the feature set to these
%                entries of the complete set.
% 
% OUTPUT
%   features ... (struct) feature type and feature set
%                 .featureType ... (string) the feature type
%                 .featureSet .... (matrix or cell array) the feature set
%
% EXAMPLE
%   features = selectFeatures('relational')
%   features = selectFeatures('jointAngle', [1,3,5])
%


switch lower(strFeature)        
    case 'jointangle'
        [selectSome, aDescription] = selectFeatures_jointAngle;
    case 'relational'
        [selectSome, aDescription] = selectFeatures_relational;
    case {'bk', 'bk_scaled', 'bk_original'}
        [selectSome, aDescription] = selectFeatures_bk;
    otherwise
        error(['*** no such feature: ', strFeature, '!']);
end

sFeatures.featureType = lower(strFeature);

switch nargin
    case 2
        sFeatures.featureSet = selectSome(iWhich,:);
    otherwise
        sFeatures.featureSet = selectSome([1:end],:);
end

switch nargout
    case 2
        if strmatch(lower(strFeature), {'jointangle','relational', 'bk', 'bk_scaled', 'bk_original'},'exact')
            %okido
        else
            aDescription = 'none available';
        end
end
