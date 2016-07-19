function theData = dataAcquisition_relational(mot, featureSet, b_verbose, bScaled)
% theData = dataAcquisition_relational(mot, featureSet, verbose);
%
% called by function "dataAcquisition", implements feature extraction for
% relational features (unscaled)
% 
% INPUT
%   mot .............. (struct) motion data (inherited)
%   featureSet ....... (struct), the feature set (inherited)
%   verbose .......... boolean, optional text output (inherited)
%
% OUTPUT
%   theData ...... (matrix, [ndata x dim]) containing the data
%

switch nargin
    case 3
        bScaled = true;
    case 4
end


%%%%%%%%%%%
%% Zusammenstellung der Daten
%%%%%%%%%%%
for k=1:(size(featureSet,1))
    theData(k,:) = feval(featureSet{k}, mot);
    
    if bScaled
    switch featureSet{k}
        case {'feature_AK_real_handLeftMoveApartRelRoot',... F16 F12
                    'feature_AK_real_handRightMoveApartRelRoot'}
            theData(k,:) = (theData(k,:)+22)*180/44; %2sigma
        case {'feature_AK_real_handLeftToFrontRelTorso', ... F16 F12
                    'feature_AK_real_handRightToFrontRelTorso'}
            theData(k,:) = (theData(k,:)+30)*180/60;
        case {'feature_AK_real_handLeftHighVel', ... F16 F12 F10
                    'feature_AK_real_handRightHighVel'}
            theData(k,:) = (theData(k,:)+0)*180/32;
        case { 'feature_AK_real_footLeftBackRelLegRight', ... F16 F12 F10
                    'feature_AK_real_footRightBackRelLegLeft'}
            theData(k,:) = (theData(k,:)+4)*180/8;
        case {'feature_AK_real_footLeftHighVel', ... F16 F12 F10
                    'feature_AK_real_footRightHighVel'}
            theData(k,:) = (theData(k,:)+0)*180/36;
        case {'feature_AK_real_footLeftRaisedRelYBodyMin',... F16 F12 F10
                    'feature_AK_real_footRightRaisedRelYBodyMin'}
            theData(k,:) = (theData(k,:)+30)*180/105;

        % actually unused
        case {'feature_AK_real_handLeftToTopRelSpine', ... F16
                    'feature_AK_real_handRightToTopRelSpine'}
            theData(k,:) = (theData(k,:)+22)*180/44;
        case {'feature_AK_real_footLeftSidewaysRelHips', ... F16
                    'feature_AK_real_footRightSidewaysRelHips'}
            theData(k,:) = (theData(k,:)+30)*180/60;
        otherwise
    end
end
end
       

%% ENDE Zusammenstellung der Daten

%end % of function feature_jointAngle
