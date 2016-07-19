function f=objfunPCA_Acce(x,PCAmat,oFrame,skel,optProps)

Bplot=false;

frameData=PCAmat.redCoefs*x'+PCAmat.mean;
rFrame=reconstructFramePCA(skel,extractFrame(oFrame,oFrame.nframes), ...
                           frameData,PCAmat.DataRep);
                       
f_control=zeros(1,size(optProps.joints,2));

if(~isempty(optProps.recmot))
    optProps.recmot=addFrame2Motion(optProps.recmot,rFrame);
    if(optProps.recmot.nframes>4)
        optProps.recmot=addAccToMot(optProps.recmot);
    end
end


if Bplot
    
    subplot(2,2,1);
    
    title=['Frame' num2str(optProps.actFrame)];
    for j=1:oFrame.njoints
        plot3(  oFrame.jointTrajectories{j}(1), ...
                oFrame.jointTrajectories{j}(2), ...
                oFrame.jointTrajectories{j}(3), ...
                '+','color','red');
        hold on
        plot3(  rFrame.jointTrajectories{j}(1), ...
                rFrame.jointTrajectories{j}(2), ...
                rFrame.jointTrajectories{j}(3), ...
                'o');
    end
    axis(oFrame.boundingBox);
    view(-80,20);
    grid on;
%     drawnow();
    hold off;
    subplot(2,2,3);
    bar(x');
end


for j=1:size(optProps.joints,2)
%     f_control(j)=(sum( ...
%         (rFrame.jointAccelerations{optProps.joints(j)}- ...
%          oFrame.jointAccelerations{optProps.joints(j)}).^2));

    a1 = oFrame.jointAccelerations{optProps.joints(j)};
    if(~isempty(optProps.recmot))
        if(optProps.recmot.nframes>4)


    %         mo=fFrame1;
    %         mo=addFrame2Motion(mo,fFrame2);
    %         mo=addFrame2Motion(mo,rFrame);

    %         mo=addAccToMot(mo);

    %         rFrame.jointAccelerations{optProps.joints(j)}= diff([... 
    %                     fFrame2.jointTrajectories{optProps.joints(j)}...
    %                     fFrame1.jointTrajectories{optProps.joints(j)} ...
    %                 	rFrame.jointTrajectories{optProps.joints(j)}],2);



            a1 = optProps.recmot.jointAccelerations{optProps.joints(j)}(:,1:end);
    %         a1= mo.jointAccelerations{optProps.joints(j)}(:,3); 
        end
    end



    
    a2= oFrame.jointAccelerations{optProps.joints(j)};

% % % %     
% % % %     l1=sqrt(sum(a1.*a1));
% % % %     l2=sqrt(sum(a2.*a2));
% % % %     
% % % %     l1_=repmat(l1,3,1);
% % % %     l2_=repmat(l2,3,1);
% % % %     
% % % %     an1=a1./l1_;
% % % %     an2=a2./l2_;
% % % % % 
% % % %     dir=real(1-dot(an1,an2));
% % % % %     
% % % % %     len=abs( (l1-l2) ./ (l1+l2));
% % % % %     
% % % %     f_control(:,j) =dir;% + len;


%      f_control(:,j)=sum(sum(abs(a1(:,end-4:end)-a2(:,end-4:end))))';

    f_control(j)=sum(sqrt(sum((a1(:,end-4:end)-a2(:,end-4:end)).^2))/ ...
                    (sqrt(sum(a1(:,end-4:end).^2))+sqrt(sum(a2(:,end-4:end).^2))));
%                 
	if(Bplot&&optProps.joints(j)==5)
        subplot(2,2,2)
        plot(a2','.');
        hold on;
        plot(a1');
        hold off;
        drawnow();
	end
     
end

% f_control=sum(f_control.^2);

f_prior=PCAmat.redCoefs'*PCAmat.inv*PCAmat.redCoefs*x';

% frameData=PCAmat.redCoefs*x'+PCAmat.mean;

if(~isempty(optProps.x_2))
    f_1=optProps.x_1;
    f_2=optProps.x_2;

    f_smooth=sum((frameData-2*f_1+f_2).^2);
else
    f_1=extractFrameData(extractFrame(optProps.recmot, ...
                            optProps.recmot.nframes  ),PCAmat.DataRep);
    f_2=extractFrameData(extractFrame(optProps.recmot, ...
                            optProps.recmot.nframes-1),PCAmat.DataRep);
    f_smooth=sum(((frameData-2*f_1+f_2).^2));
end

alpha_p=0.3;
alpha_s=1;
alpha_c=1;

% fprintf('   p=%f  c=%f  s=%f\n',f_prior,f_control,f_smooth);

% f_prior =repmat(f_prior ,size(optProps.joints,2),1);
% f_smooth=repmat(f_smooth,size(optProps.joints,2),1);

f=[alpha_p*f_prior; alpha_s*f_smooth; alpha_c*f_control(:)];
% f_prior; f_smooth; alpha*
% ftmp=1*f_prior+alpha*f_control(end,:)'+beta*f_smooth;
% 
% f=f_control;
% 
% f(end,:)=ftmp;
if Bplot
    subplot(2,2,4);
    h=bar(f);
%     set(h,'FaceAlpha',0.2,'FaceLighting','phong');
    drawnow();
end






