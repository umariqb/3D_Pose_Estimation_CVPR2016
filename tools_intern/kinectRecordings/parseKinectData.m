function [skels,mots] = parseKinectData(file,varargin)

switch nargin
    case 1
        output = 'jpg';
    case 2 
        output = varargin{1};
    otherwise
        error('Wrong num of args!');
end


[skels,mots] = readKinectData(file);

switch output
    case 'video'
        videofile = [file(1:end-9) '.video'];
        videoInfo = writeKinectVideos2(videofile);
    case 'jpg'
        [folder, filename] = fileparts(file);
        jpgpath   = [folder '\' filename '\'];
        videofile = [file(1:end-9) '.video'];
        videoInfo = writeKinectJPGs(jpgpath,videofile);
    otherwise
        error('unknown output specified! Allowed are video and jpg.');
end
        
% resample mots
for m=1:numel(mots)
    
    mots{m}.videoInfo = videoInfo;
    
    newts = mots{m}.timestamps(1):1/30:mots{m}.timestamps(end);
    
    for j=1:mots{m}.njoints
        mots{m}.jointTrajectories{j} = spline(mots{m}.timestamps, ...
                                              mots{m}.jointTrajectories{j}, ...
                                              newts);
    end

    mots{m}.timestamps = newts;
    mots{m}.videoInfo.motStartTime = newts(1);
    mots{m}.videoInfo.motEndTime   = newts(end);
    mots{m}.samplingRate = 30;
    mots{m}.frameTime    = 1/30;
    
    emptySeconds =   mots{m}.videoInfo.motStartTime ...
                   - mots{m}.videoInfo.videoStartTime;
                
    emptyFrames  = floor(emptySeconds * 30);
    
    for j=1:mots{m}.njoints
        mots{m}.jointTrajectories{j} = [nan(3,emptyFrames) mots{m}.jointTrajectories{j}];
    end
    
    mots{m}.nframes    = numel(newts) + emptyFrames;

end


end