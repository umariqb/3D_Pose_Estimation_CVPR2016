function D = createDirList(start_dir,varargin)

recursive = true;
if (nargin>2)
    recursive = varargin{1};
end

D = {start_dir};
D = vertcat(D,forAllDirsInDir(start_dir,@addDirToDirList,recursive,{}));
