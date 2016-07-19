function [X] = playCoefficients(Tensor,index1,index2,hold1,hold2,hold3,stepsize,transx,transy,beauty,skel,mot)

dim=size(size(Tensor.core),2);
dimvec=size(Tensor.core);
% skel=0;
% [skel,mot]=reconstructMotionT(Tensor,[2 2]);
%[fitskel,fitmot]=constructMotion(Tensor,{[1 0 0] [1 0 0 0 0 ] [1 0 0]},skel,'ExpMap');
% [   skel,   mot]=constructMotion(Tensor,{[1 0 0] [1 0 0 0 0 ] [1 0
% 0]},skel,'ExpMap');
% % [fitskel,fitmot]=constructMotion(Tensor,{[1 0 0] [1 0 0 0 0 ] [1 0 0]},skel,'ExpMap');
% % [skel,mot]=constructMotion(Tensor,{[0 1 0] [0 1 0 0 0 ] [0 1 0]},skel,'ExpMap');
% % %[fitskel,fitmot]=constructMotion(Tensor,{[1 0 0] [1 0 0 0 0 ] [1 0 0]},skel,'ExpMap');
% % [   skel,   mot]=constructMotion(Tensor,{[1 0 0] [1 0 0 0 0 ] [1 0 0]},skel,'ExpMap');
%readMocap('R:\HDM05_3style_example\cut_amc\walkLeftCircle4StepsRstart\bk.asf','R:\HDM05_3style_example\cut_amc\walkLeftCircle4StepsRstart\HDM_bk_walkLeftCircle4StepsRstart_009_120.amc');
% Reduce frame rate
% mot=reduceFrameRate(skel,mot);
% % fit motion
% mot=fitMotion(skel,mot);
% % Timewarp motion
% [mot]=SimpleDTW(fitmot,skel,mot);


% Determine type of tensor, i.e. number of technical modes
nrOfTechnicalModes=Tensor.numTechnicalModes;
nrOfNaturalModes=Tensor.numNaturalModes;

% for i=1:nrOfTechnicalModes
%     Tensor.core=modeNproduct(Tensor.core,Tensor.factors{i},i);
% end

n=sum(dimvec(nrOfTechnicalModes+1:dim));

x0=zeros(1,n);
% x0(2)=0;
%x0(8)=1;
vals=40;

% Compute mode-n-product of core tensor and all matrices related to
% technical modes
for i=1:5%nrOfTechnicalModes
    Tensor.rootcore=modeNproduct(Tensor.rootcore,Tensor.rootfactors{i},i);
end

range=vals*stepsize/2;

% dimvec=Tensor.dimNaturalModes;%size(Tensor.core);
dimvec=size(Tensor.core);


X=zeros(vals,vals);

label_i=zeros(1,vals);
label_j=zeros(1,vals);

fprintf('i:         ');
for i=1:vals
    fprintf('\b\b\b\b\b\b\b\b');
    fprintf('%2i',i);
    fprintf(' j:   ');
    for j=1:vals
% %           x0(6)=1;%x0(7)=0.5;
         x0(hold1)=1;%x0(8)=0.5;
         x0(hold2)=1;
         x0(hold3)=1;

         x_i=-range+i*stepsize+transx;
         x_j=-range+j*stepsize+transy;
         x0(index1)=x_i;
         x0(index2)=x_j;
         label_i(i)=x_i;
         label_j(j)=x_j;
         
%         c=1; d=1;
%         for b=1:size(x0,2)
%             xTmp{c}(d)=x0(b);
%             if (d==dimvec(nrOfTechnicalModes+i))
%                 d=1;c=i+1;
%             else
%                 d=d+1;
%             end
%         end
        fprintf('\b\b');
        fprintf('%2i',j);

        tmp=objfunCol(x0,Tensor,mot,nrOfNaturalModes,nrOfTechnicalModes,dimvec,skel,'ExpMap');

        X(i,j)=sum(tmp(:).*tmp(:));
 %       [S{i,j},M{i,j}]=constructMotion(Tensor,x0);
    end
end
fprintf('\n');

desc=['Coefs ' num2str(index1) ' and ' num2str(index2)];
surfMinimaPositions(real(X),beauty,label_i,label_j,desc);
