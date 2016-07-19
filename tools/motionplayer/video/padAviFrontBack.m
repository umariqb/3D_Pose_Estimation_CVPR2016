function padAviFrontBack( aviFilename, padFramesBefore, padFramesAfter, newAviFilename, parameter)

if nargin<4
   error('Please specify input data');
end

if nargin<5
   parameter=[]; 
end

if isfield(parameter, 'compression') == 0
     parameter.compression = 'ffds';
end


global VARS_GLOBAL_ANIM;
VARS_GLOBAL_ANIM.video_compression = parameter.compression;
imFirst = extractVideoFrame(aviFilename,'first');%;,[aviFilename(1:end-4) '_first.tif']);
imLast = extractVideoFrame(aviFilename,'last');%,[aviFilename(1:end-4) '_last.tif']);


info = aviinfo(aviFilename);

aviobj = avifile(newAviFilename, ...
    'compression',  parameter.compression, ...
    'quality',info.Quality,...
    'fps',info.FramesPerSecond);
%use try-catch to close the avi if anything bad happens
try 
    
    % add padding frames before the animation
    frameFirst = im2frame(imFirst);
    for f=1:padFramesBefore
        aviobj = addframe(aviobj,frameFirst);            
    end


    strlen = -2;
    for f = 1:info.NumFrames
        mov = aviread(aviFilename,f);
        
        
        aviobj = addframe(aviobj,mov);
        
        s = ['Frame ' num2str(f) ' of ' num2str(info.NumFrames)];
        disp(char(8*ones(1,strlen+2)));
        strlen = length(s);
        disp(s);


    end
    
    % add padding frames after the animation    
    
    frameLast = im2frame(imLast);
    for f=1:padFramesAfter
        aviobj = addframe(aviobj,frameLast);            
    end

    
catch ME
    if strcmp(aviobj.CurrentState, 'Open') == 1    
        aviobj=close(aviobj);
    end
    ME.stack
    warning('Avi creation did not complete.');
end

if strcmp(aviobj.CurrentState, 'Open') == 1    
    aviobj=close(aviobj);
end
