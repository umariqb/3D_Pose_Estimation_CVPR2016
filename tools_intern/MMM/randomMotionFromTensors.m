function [skel,mot]=randomMotionFromTensors(TENSORS,varargin)

switch nargin
    case 1
        n=5;
        debug=false(1);
    case 2
        n=varargin{1};
        debug=false(1);
    case 3
        n=varargin{1};
        debug=varargin{2};
    otherwise
        disp('Wrong number of arguments');
end

fprintf('i= __')

mot=emptyMotion();

r = ceil(size(TENSORS,2).*rand(n,1));
for i=1:n
    %recMotion
    fprintf('\b\b%2i',r(i));
    dims=size(TENSORS{r(i)}.core);
    x{1}=rand(dims(4),1);
%     x{1}=x{1}/(sum(x{1}));
    x{1}=x{1}/(sqrt(sum(x{1}.*x{1})));
    x{2}=rand(dims(5),1);
%     x{2}=x{2}/(sum(x{2}));
    x{2}=x{2}/(sqrt(sum(x{2}.*x{2})));
    
    if (debug)
       fprintf('\nx{1}= ');
       for k=1:size(x{1},1)
           for j=1:size(x{1},2)
               fprintf(' %f',x{1}(k,j));
           end
       end
       fprintf('\nx{2}= ');
       for k=1:size(x{2},1)
           for j=1:size(x{2},2)
               fprintf(' %f',x{2}(k,j));
           end
       end
    end
    
    if(exist('skel','var'))        
        [skel,mot1]=constructMotion(TENSORS{r(i)},x,skel);
    else
        [skel,mot1]=constructMotion(TENSORS{r(i)},x);
    end
    
    
    %appendMotion
    if(i>1)
        mot = appendAndBlend(skel,mot,mot1,5,true,false);
    else
        mot=mot1;
    end
    
    for joint=1:mot.njoints
        mot.rotationEuler{joint}=quat2euler(mot.rotationQuat{joint})*180/pi;
    end
end
mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
mot.boundingBox = computeBoundingBox(mot);
fprintf('\b\b\b\b\bReady!\n');
end