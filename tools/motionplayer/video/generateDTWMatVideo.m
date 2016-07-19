function generateDTWMatVideo(D,docName)

    compression = 'none';
    quality = 100;
    fps = 30;

    figureSize = [400, 600];

    if ~exist(['video_' docName '.avi'], 'file') % generate the new video

        parameter.filename = ['video_' docName];
        parameter.fps = fps;
        parameter.compression = compression;
        parameter.quality = quality;
        parameter.position = [300,300];
        parameter.size = figureSize;
        
        fh = figure();
        
        set(fh, 'position', [parameter.position(:) parameter.size(:)]);
        set(fh, 'color','white')
        
        imagesc(D);
        colormap hot;
        
        frames = 1:min(size(D));
        fprintf('\n');
        disp('*************************************************************');
        disp('Starting onscreen rendering. Do not move the windows or hover');
        disp('over the figure with the mouse because it will be seen in the avi.');
        disp('*************************************************************');
        fprintf('\n');
        
        % open avi
        aviobj = avifile(parameter.filename, ...
        'compression',  parameter.compression, ...
        'quality',parameter.quality,...
        'fps',parameter.fps);
        
        for f=frames
            
        	l1 = line([f f],[1 min(size(D))],'color','g','linewidth',2);
            l2 = line([1 min(size(D))],[f f],'color','g','linewidth',2);
            
           frame = getframe(fh);
           
           aviobj = addframe(aviobj,frame);
           
           set(l1,'Visible','off')
           set(l2,'Visible','off')
           
        end

        aviobj=close(aviobj);
        
    end
end

