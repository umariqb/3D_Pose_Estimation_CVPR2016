function files = D2filenames(D,varargin)

path_separator = filesep;

dir_root = '';
if (nargin>1)
    dir_root = varargin{2};
end

files = {};
for k=1:length(D)
    if (D(k).path_name(end) ~= path_separator)
        D(k).path_name = [D(k).path_name path_separator];
    end
    files{k,1} = [dir_root D(k).path_name D(k).file_name];
end
