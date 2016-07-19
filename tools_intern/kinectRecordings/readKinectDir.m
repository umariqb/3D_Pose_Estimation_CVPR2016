function readKinectDir(path,varargin)

switch nargin
    case 1
        output = 'jpg';
    case 2 
        output = varargin{1};
    otherwise
        error('wrong num of args');
end

skelfiles = dir(fullfile(path,'*.skeleton'));

for f=1:numel(skelfiles)
    curfile = fullfile(path,skelfiles(f).name);
    [skels,mots] = parseKinectData(curfile,output);
    filename = [curfile(1:end-9) '.mat'];
    save(filename,'skels','mots');
end

end