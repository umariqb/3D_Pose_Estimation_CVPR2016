function f=objfunPCA(x,PCAmat,oFrame,skel,DataRep,optProps)

frameData=PCAmat.redCoefs*x'+PCAmat.mean;

rFrame=reconstructFramePCA(skel,oFrame,frameData,PCAmat.DataRep);
% draw=false;
draw=true;
if draw
 
    subplot(3,1,1);
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
    subplot(3,1,2);
    bar(x);
end

% f_control=zeros(1,size(optProps.joints,2));

for j=1:size(optProps.joints,2)
    f_control(j,:)=( ...
        (rFrame.jointTrajectories{optProps.joints(j)} ...
        -oFrame.jointTrajectories{optProps.joints(j)}).^2);
end

% f_control=sum(f_control.^2);

% f_prior=x*PCAmat.redCoefs'*PCAmat.inv*PCAmat.redCoefs*x';

if(~isempty(optProps.x_2))
    f_1=optProps.x_1;
    f_2=optProps.x_2;

    f_smooth=sum((frameData-2*f_1+f_2).^2);
else
    f_smooth=0;
end
% 
alpha_smooth=0.2;
alpha_prior=0;
alpha_control=0.8;

% f=f_prior+alpha*f_control+beta*f_smooth;

% f_prior =repmat(f_prior ,size(optProps.joints,2),1);
% f_smooth=repmat(f_smooth,size(optProps.joints,2),1);

f=[alpha_smooth*f_smooth alpha_control*f_control(:)'];

if draw
    subplot(3,1,3);
    bar(f);
    drawnow();
end

% beta*f_smooth'
% f_prior

