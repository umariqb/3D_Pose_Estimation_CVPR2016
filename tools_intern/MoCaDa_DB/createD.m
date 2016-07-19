function D = createD(start_dir,root_dir,varargin)

recursive = true;
if (nargin>2)
    recursive = varargin{1};
end
D = forAllFilesInDir(start_dir,{'*.amc','*.bvh','*.c3d'},@addFileToD,recursive,[],root_dir);
