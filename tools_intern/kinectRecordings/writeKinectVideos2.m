function res = writeKinectVideos2(file)

    videofile = file;
    depthfile = [file(1:end-5) 'depth'];

    vNFrames = 0;
    dNFrames = 0;
    
    %% count frames in video file:
    fprintf('Count Frames in video file: ');
    vfid   = fopen(videofile);
    c = 1;
    while  ~feof(vfid)
        tmp = fread(vfid,[1 1],'double');
        if numel(tmp)==1
            vts(c)=tmp;
        end
        res2 = fread(vfid,[1 640*480*4],'uint8');
        c=c+1;
    end
    vNFrames = c;
    fclose(vfid);
    fprintf('%i done.\n',vNFrames);
    
    %%     count frames in depth file
    fprintf('Count Frames in depth file: ');
    dfid = fopen(depthfile);
    c=1;
    while ~feof(dfid)
    
        tmp  = fread(dfid,[1 1],'double');
        if numel(tmp)==1
            dts(c)=tmp;
        end
        res2    = fread(dfid,[1 640*480],'uint16');
        c=c+1;
    end
    fclose(dfid);
    dNFrames = c;
    fprintf('%i done.\n',dNFrames);
    
    %% read video file into large 4d matrix
    
    fprintf('Read video data. Frame:      ');
    vfid = fopen(videofile);
    myimage = zeros(480,640,3,vNFrames);
    
    c = 1;
    vts = zeros(1,vNFrames);
    while  ~feof(vfid)
        fprintf('\b\b\b\b\b%5i',c);
        tmp = fread(vfid,[1 1],'double');
        if numel(tmp)==1
            vts(c)=tmp;
        end
        res2 = fread(vfid,[1 640*480*4],'uint8');
        if size(res2,2)==640*480*4
            myimage(:,:,3,c)=fliplr(reshape(res2(1:4:end),640,[])')/255;
            myimage(:,:,2,c)=fliplr(reshape(res2(2:4:end),640,[])')/255;
            myimage(:,:,1,c)=fliplr(reshape(res2(3:4:end),640,[])')/255;
        end
        c=c+1;
    end
    
    fclose(vfid);
    fprintf(' done.\n');
    
    %% compute new 4d video matrix, now resampled to 30Hz
    fprintf('Resample video to 30Hz.   ')
    vts = vts(vts~=0);
    
    vnts = vts(1):1/30:vts(end);
    
    newimage = zeros(480,640,3,numel(vnts));
    sym=0;
    for r=1:480
        for c=1:640
            switch mod(sym,4)
                case 0: fprintf('\b/');
                case 1: fprintf('\b-');
                case 2: fprintf('\b\\'); 
                case 3: fprintf('\b|');
            end
            
            cp = squeeze(myimage(r,c,:,:));
            
            ncpR = interp1(vts,cp(1,1:numel(vts)),vnts);
            ncpG = interp1(vts,cp(2,1:numel(vts)),vnts);
            ncpB = interp1(vts,cp(3,1:numel(vts)),vnts);
                        
            newimage(r,c,:,:) = [ncpR;ncpG;ncpB];
            sym=sym+1;
        end
    end
    fprintf(' done.\n');
    %% write video to avi:
    fprintf('Write video to avi. Frame:      ')
    aviobj = avifile([videofile '.avi'],'compression','None');
    aviobj = set(aviobj,'fps',30);
    
    vfig = figure();
    set(vfig,'position',[50 50 700, 540])
    
    c=1;
    for f=1:numel(vnts)
        fprintf('\b\b\b\b\b%5i',c);
        imshow(newimage(:,:,:,c));
        set(gca,'units','pixels');
        set(gca,'position',[30 30 639 439]);
        F      = getframe(gca);
        aviobj = addframe(aviobj,F);
        c=c+1;
    end

    aviobj = close(aviobj);
    fprintf(' done.\n')
    
    %% read depth video to large 3d matrix
    fprintf('Read depth video data. Frame:      ');
    dfid = fopen(depthfile);
    
    fps = dNFrames/dts(end);
    
    c=1;
    
    myimage = zeros(640,480,dNFrames);
    
    while ~feof(dfid)
        fprintf('\b\b\b\b\b%5i',c);
        tmp  = fread(dfid,[1 1],'double');
        if numel(tmp)==1
            dts(c)=tmp;
        end
        
        res2    = fread(dfid,[1 640*480],'uint16');
        
        if size(res2,2)==640*480
            myimage(:,:,c) = reshape(res2,640,480)/32768;
        end
        c=c+1;
    end

    fclose(dfid);
    fprintf(' done.\n');
    %% Resample depth information to 30Hz.
    fprintf('Resample depth video to 30Hz.   ');
    dts = dts(dts~=0);
    
    dnts = dts(1):1/30:dts(end);
    
    newimage = zeros(640,480,numel(dnts));
    sym=0;
    for r=1:640
        for c=1:480
            
            switch mod(sym,4)
                case 1: fprintf('\b-'); case 2: fprintf('\b\\'); 
                case 3: fprintf('\b|'); case 0: fprintf('\b/');
            end
            
            cp = squeeze(myimage(r,c,:));
            
            ncp = interp1(dts,cp(1:numel(dts)),dnts);
 
            newimage(r,c,:) = ncp;
            sym=sym+1;
        end
    end
    fprintf('done.\n');
     
    %% write depth video to avi
    fprintf('Write video to avi. Frame:      ')
    aviobj = avifile([depthfile '.avi'],'compression','None');
    aviobj = set(aviobj,'fps',30);
    
    dfig = figure();
    set(dfig,'position',[800 50 700, 540])
    
    c=1;
    for f=1:numel(dnts)
        fprintf('\b\b\b\b\b%5i',c);
        imshow(fliplr(newimage(9:640,:,c)'));
        set(gca,'units','pixels');
        set(gca,'position',[30 30 639 439]);
        F      = getframe(gca);
        aviobj = addframe(aviobj,F);
        c=c+1;
    end
    aviobj = close(aviobj);
    close all;
    fprintf(' done.\n');
    %% write some properties to result struct:
    
    res.videoStartTime = vnts(1);
    res.depthStartTime = dnts(1);
    res.videoEndTime   = vnts(end);
    res.depthEndTime   = dnts(end);
    res.videoFileName  = [videofile '.avi'];
    res.depthFileName  = [depthfile '.avi'];
    fprintf('finished processing %s\n\n',file);
    
end