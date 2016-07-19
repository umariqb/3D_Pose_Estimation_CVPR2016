function [OrgSkel,OrgMot,RecMot]= ... 
                            constructBothMotionsExtraRoot(Tensor,result,varargin)
                        
	
    switch nargin
        case 2
            cut=true;
        case 3
            cut=varargin{1};
        otherwise
            error('Wrong number of Args!');
    end
                        
    fseps=strfind(result.amc,filesep);
    path=result.amc(1:fseps(end));
    % Read and prepare original motion
%     [OrgSkel,OrgMot]=readMocap(fullfile(path,result.asf),result.amc);
%      OrgMot=reduceFrameRate(OrgSkel,OrgMot);
    OrgMot =result.orgMot; 
    OrgSkel=result.orgSkel;
    % Cut to frames found by MotionTemplate
    if cut
       OrgMot=cutMot(OrgSkel,OrgMot,result.startFrame,result.endFrame);
    end
    % Applay Fit mot to make ist comparable:
     OrgMot=fitMotion(OrgSkel,OrgMot);
    %Reconstruct second motion from Tensor an Coefficients
    [skel,RecMot]=constructMotionExtraRoot(Tensor,result.Y,result.XRoot,OrgSkel,'ExpMap');
        
    %Unwarp to original length:
     RecMot =unwarpMotion(result.warpingPath,OrgSkel,RecMot);
     
    if cut 
        [f,theta,x0,z0] = pointCloudDist_modified(OrgMot.rootTranslation,RecMot.rootTranslation);

        T(1,:) = [ cos(theta)   0 sin(theta) x0 ];
        T(2,:) = [ 0            1 0          0  ];
        T(3,:) = [ -sin(theta)  0 cos(theta) z0 ];
        T(4,:) = [ 0            0 0          1  ];

        tmp=T*[RecMot.rootTranslation; ones(1,size(RecMot.rootTranslation,2))];
        RecMot.rootTranslation=tmp(1:3,:);
    end
     
    %Calculate Euler Angles (Export to asf/amc possible)
    OrgMot=convert2euler(OrgSkel,OrgMot);
    RecMot=convert2euler(OrgSkel,RecMot);
    
    if(isempty(OrgMot.filename))
        OrgMot.filename='Original';
    end
    if(isempty(RecMot.filename))
        RecMot.filename='Reconstruction';
    end
end