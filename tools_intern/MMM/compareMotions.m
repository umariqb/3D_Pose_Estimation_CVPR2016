% FUNCTION compareMotions compares to given motions. It returns a matrix of
% distances for joints(rows) and frames(columns).
% INPUT:
%   mot:            struct: motion
%   mot1:           struct: motion that shold be compared to mot
%   varargin{1}:    string: Defines which distance measurement should
%                   be used.
%   
% OUTPUT:
%   result:         matrix: containig distances for every joint for every
%                   frame. Most optimization tools from Matlabs
%                   Optimization Toolbox can use this and make summation
%                   and calculating squares implicit.

function result=compareMotions(mot,mot1,varargin)
    
    existSkel=false;
    plotSteps=true;
    switch nargin
        case 2
            dataRep='Quat';
        case 3 
            dataRep=varargin{1};
        case 4
            dataRep=varargin{1};
            skel   =varargin{2};
            existSkel=true;
        case 5
            dataRep=varargin{1};
            skel   =varargin{2};
            existSkel=true;
            plotSteps=varargin{3};
        otherwise
            error('compareMotions: Wrong number of arguments!\n');
    end

%    result=zeros(mot.nframes,mot.njoints);
    switch dataRep
        case 'Quat'    
            for i=2:mot.njoints
%                result(:,i)=QuatDistRot(i,mot,mot1);
%                result(:,i)=QuatDistAxisJoint(i,mot,mot1);
               result(:,i)=QuatDist(i,mot,mot1);
%                  result(:,i)=QuatDistAbs(i,mot,mot1);
%                resultP(:,i)=PosDist(i,mot,mot1);
            end            
        case 'Position'
            for i=2:mot.njoints
                 result(:,i)=PosDist(i,mot,mot1);
            end
            if plotSteps
                plot3(mot1.jointTrajectorie{5}','.');
                hold on;
                plot3( mot.jointTrajectorie{5}');
                hold off;
                drawnow();
            end
        case 'ExpMap'
            for i=[3 8 19 26]%[2:4 7:9 12:14 18:21 25:28]
                result(:,i)=QuatDistRot(i,mot,mot1);
            end
            if plotSteps
                subplot(2,1,1)
                plot(mot1.rotationQuat{4}','.');
                hold on;
                plot( mot.rotationQuat{4}');
                hold off;
                axis([0 mot.nframes -0.5 1.2])
                subplot(2,1,2)
                plot(mot1.rotationQuat{20}','.');
                hold on;
                plot( mot.rotationQuat{20}');
                hold off;
                axis([0 mot.nframes -0.5 1.2])
                drawnow();
%                 I = getframe(gcf);
%                 imwrite(I.cdata, ['c:\opt_vid\opt_' datestr(now, 30) '.png']);
            end
        case 'jointAngle'
            if existSkel
                JointAngles1 = dataAcquisition(skel, mot,  selectFeatures('jointAngle'),false);
                JointAngles2 = dataAcquisition(skel, mot1, selectFeatures('jointAngle'),false);
                tmp          = abs(JointAngles1-JointAngles2);
                
                if plotSteps
                    
                    plot(JointAngles2','.');
                    hold on;
                    plot( JointAngles1');
                    hold off;
                    axis([0 mot.nframes 0 pi])
                    drawnow();
                end
                result       = tmp.*tmp;
            else
                error(['compareMotions: if jointAngles are compared a '...
                       'skeleton should be given!\n']);
            end
        case 'Acce'
            mot =addAccToMot(mot);
            mot1=addAccToMot(mot1);
            counter=0;
            % for j=1:dimTechnicalModes(3)
%             for j=[5,10,15,22,29]
            for j=1:30
                for i=1:size(mot.jointAccelerations{j},2)
                    counter=counter+1;
                    m   {counter,1}=mot .jointAccelerations{j}(:,i);
                    mRec{counter,1}=mot1.jointAccelerations{j}(:,i);
                end
            end

            result=distVector_pointCloudDistance(m,mRec,0);
            if plotSteps
                subplot(2,1,1);
                joint=5;
                plot(   mot.jointAccelerations{joint}');
                hold on;
                plot(  mot1.jointAccelerations{joint}','.');
                boxsize=2000;
                axis([0 mot.nframes -boxsize boxsize]);
                hold off;
                subplot(2,1,2);
                joint=20;
                plot(   mot.jointAccelerations{joint}');
                hold on;
                plot(  mot1.jointAccelerations{joint}','.');
                boxsize=2000;
                axis([0 mot.nframes -boxsize boxsize]);
                hold off;
                drawnow;
            end
        otherwise
            error('compareMotions: Wrong type of Data specified in var: dataRep\n');
    end
end

function res=QuatDistRot(i,mot,mot1)
    res=zeros(mot.nframes,1);
    if(~isempty(mot.rotationQuat{i})&&~isempty(mot1.rotationQuat{i}))
       res=distS3(mot.rotationQuat{i},mot1.rotationQuat{i},0.001);
    end
end

function res=QuatDistAxisJoint(i,mot,mot1)
    res=zeros(mot.nframes,1);
    
    if(~isempty(mot.rotationQuat{i})&&~isempty(mot1.rotationQuat{i}))
        smo=size(mot.rotationQuat{i},2);
        sm1=size(mot1.rotationQuat{i},2);
        if(sm1<smo)
            smo=sm1;
        end
          rot=acosd(mot.rotationQuat{i}(1,1:smo))-real(acos(mot1.rotationQuat{i}(1,1:smo)));
          rotR=abs(real(rot));
%         rotI=abs(imag(rot));
%         rot=abs(acos(mot.rotationQuat{i}(1,1:smo))*2-acos(mot1.rotationQuat{i}(1,1:smo))*2);
          x1=mot.rotationQuat{i}(2:4,1:smo);
          x2=mot1.rotationQuat{i}(2:4,1:smo);
          for i=1:size(x1,2)
              if(norm(x1(:,i))>0)
                  x1(:,i)=x1(:,i)/norm(x1(:,i));
              end
              if(norm(x2(:,i))>0)
                  x2(:,i)=x2(:,i)/norm(x2(:,i));
              end
          end
          
          angR=(1-dot(x1,x2))*180/pi;
%           angI=1-dot(imag(x1),imag(x2));
%        ang=1-dot(mot.rotationQuat{i}(2:4,1:smo),mot1.rotationQuat{i}(2:4,1:smo));
        res=rotR+angR;%+rotI+angI;
    end  
end

function res=PosDist(i,mot,mot1)
res=zeros(mot.nframes,1);
    
    if(~isempty(mot.jointTrajectories{i})&&~isempty(mot1.jointTrajectories{i}))
        smo=size(mot.jointTrajectories{i},2);
        sm1=size(mot1.jointTrajectories{i},2);
        if(sm1<smo)
            smo=sm1;
        end
        res=abs(mot.jointTrajectories{i}(1,1:smo)-mot1.jointTrajectories{i}(1,1:smo))';
    end  
end

function res=QuatDist(i,mot,mot1)
    res=zeros(mot.nframes,1);
    if(~isempty(mot.rotationQuat{i})&&~isempty(mot1.rotationQuat{i}))
        smo=size(mot.rotationQuat{i},2);
        sm1=size(mot1.rotationQuat{i},2);
        if(sm1<smo)
            smo=sm1;
        end
        res=1-dot(mot.rotationQuat{i}(:,1:smo),mot1.rotationQuat{i}(:,1:smo));
    end  
end

function res=QuatDistAbs(i,mot,mot1)
    res=zeros(mot.nframes,1);
    if(~isempty(mot.rotationQuat{i})&&~isempty(mot1.rotationQuat{i}))
        smo=size(mot.rotationQuat{i},2);
        sm1=size(mot1.rotationQuat{i},2);
        if(sm1<smo)
            smo=sm1;
        end
        res=sum(abs(mot.rotationQuat{i}(:,1:smo)-mot1.rotationQuat{i}(:,1:smo)),1);
    end  
end

function res=QuatDistJochen(mot1,mot2) % = compareMotions_jt

    for i=1:mot1.njoints
        if (~(isempty(mot1.rotationQuat{i})) && ~(isempty(mot2.rotationQuat{i})))
            res(i,1) = mean(real(acosd(dot(mot1.rotationQuat{i},mot2.rotationQuat{i}))*2));
        end
    end
end


% result=sum(result,2)/mot.njoints;

%fprintf('r= %3.3f\n',result);

%Code-Halde:

% for i=2:mot.njoints
%     if(~isempty(mot.rotationQuat{i})&&~isempty(mot1.rotationQuat{i}))
%         smo=size(mot.rotationQuat{i},2);
%         sm1=size(mot1.rotationQuat{i},2);
%         if(sm1<smo)
%             smo=sm1;
%         end
%      
%         tmp=dot(mot.rotationQuat{i}(:,1:smo),mot1.rotationQuat{i}(:,1:smo));
%         j=i*4-3;
%         motion1(:,j:j+3)= mot.rotationQuat{i}(:,1:smo)';
%         motion2(:,j:j+3)=mot1.rotationQuat{i}(:,1:smo)';
% %         result(i)=sum(tmp)/mot.nframes;%real(acosd(sum(tmp,2)/mot.nframes));
% %           result(i)=real(acosd(sum(tmp,2)/mot.nframes));
%     end 
% end
% 
% frames=smo;
% dofs=mot.njoints;
% m=motion1.*motion2;
% colsum=0;
% for i=4:4:size(m,2)-3
%     colsum=colsum+real(acosd(sum(m(:,i:i+3)')')*2);
% end
% result=sum(colsum)/(frames*dofs);





     
%         result(i)=sum(tmp)/mot.nframes;
        
        
%         tmp=dot(mot.rotationQuat{i}(:,1:smo),mot1.rotationQuat{i}(:,1:smo));
%         tmp=(ones(size(tmp))-tmp);
% %         a=sqrt(sum(mot.rotationQuat{i}(:,1:smo).*mot.rotationQuat{i}(:,1:smo)));
% %         b=sqrt(sum(mot1.rotationQuat{i}(:,1:smo).*mot1.rotationQuat{i}(:,1:smo)));
% %         c=a.*b;
% %         tmp=tmp./c;
% %         tmp=real(acosd(tmp));
%         result(i)=sum(tmp)/mot.nframes;%real(acosd(sum(tmp,2)/mot.nframes));
% %



% tmp=abs(mot.rootTranslation-mot1.rootTranslation);
% result=sum(tmp,2);

% result = sum(dist)/(mot.nframes+mot.njoints);
% result = result*result;

        %tmp=sum(tmp)/mot.nframes;
        %tmp=sum(tmp,1)/mot.njoints;
       % tmp=(ones(size(tmp))-tmp)*2;
       
 %       result(i)=tmp/mot.nframes;
