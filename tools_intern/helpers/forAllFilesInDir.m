function y = forAllFilesInDir(startdir, filetypes, func, recursive, y, varargin)
% y = forAllFilesInDir(startdir, filetypes, func, recursive, y, varargin)
%
% Traverse directory structure, performing for each file of a specified filetype 
% an action defined by a function handle.
%
% INPUT:
% ------
% startdir ..... (string) Start directory. 
%                Any directory containing a file named "skip" will be skipped.
% filetypes .... (cell array of strings) File type filter, e.g. {'*.amc' '*.asf'} 
%                or {'*.*'} for all files
% func ......... (function handle) Worker function to be called for each file
%                The function designated by func will be passed the current complete 
%                filename (including pathname) as the first argument. If the parameter list 
%                varargin is nonempty, a single cell array with the current filename as the
%                first entry followed by the remaining parameters in varargin will be passed.
% recursive .... (boolean) Flag indicating whether recursive traversal is desired or not.
% y ............ (matrix or cell array) Initial value for output container. Usually empty ([]).
% varargin ..... (cell array of parameters) Parameters to be passed to func, see "func".
%
% OUTPUT:
% -------
% y ............ (matrix or cell array) Collected outputs of calls to func, vertically concatenated.
%
% EXAMPLE:
% --------
% y = forAllFilesInDir('S:\data_MoCap\MoCaDaDB\AMC',{'*.amc'},@getAMCLengthInSeconds,true,[]);
% y = forAllFilesInDir('S:\data_MoCap\MoCaDaDB\AMC',{'*.amc'},@getAMCLengthInSeconds,true,[],param1,...,paramn);

if (startdir(end)~=filesep)
    startdir = [startdir filesep];
end

files = dir(startdir);
if (isempty(strmatch('skip',{files.name},'exact'))) % only process dir if no "skip" file is present!
    disp(['Entered directory ' startdir]);
	files = [];
	for k=1:length(filetypes)
        fls = dir([startdir filetypes{k}]);
        files = [files; fls];
	end
	
	for k=1:length(files)
        disp(['Processing file ' files(k).name]);
        if (nargin>5)
            args = horzcat({[startdir files(k).name]}, varargin);
        else
            args = {[startdir files(k).name]};
        end
        a = feval(func,args{:});
        y = [y; a];
	end
	
	if (recursive)
		dirs = dir(startdir);
		isdir = cell2mat({dirs.isdir});
		dirs = dirs(find(isdir));
		for k = 1:length(dirs)
            if (~strcmp(dirs(k).name,'.') & ~strcmp(dirs(k).name,'..'))
                y = forAllFilesInDir([startdir dirs(k).name], filetypes, func, recursive, y, varargin{:});
            end
		end
	end
    disp(['Left directory ' startdir]);
else
    disp(['Skipped directory ' startdir]);
end
