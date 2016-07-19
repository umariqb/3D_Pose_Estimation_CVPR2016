function [OrgSkel,OrgMot,RecMot]= ... 
                            constructBothMotions(Tensor,result)
                        
	
    fseps=strfind(result.amc,filesep);
    path=result.amc(1:fseps(end));
    % Read and prepare original motion
    [OrgSkel,OrgMot]=readMocap(fullfile(path,result.asf),result.amc);
     OrgMot=reduceFrameRate(OrgSkel,OrgMot);
    % Cut to frames found by MotionTemplate
     OrgMot=cutMot(OrgSkel,OrgMot,result.startFrame,result.endFrame);
    % Applay Fit mot to make ist comparable:
     OrgMot=fitMotion(OrgSkel,OrgMot);
    %Reconstruct second motion from Tensor an Coefficients
    [skel,RecMot]=constructMotion(Tensor,result.X,OrgSkel,'ExpMap');
    %UNwarp to original length:
     RecMot =unwarpMotion(result.warpingPath,OrgSkel,RecMot);
    %Calculate Euler Angles (Export to asf/amc possible)
    OrgMot=convert2euler(OrgSkel,OrgMot);
    RecMot=convert2euler(OrgSkel,RecMot);
        
end