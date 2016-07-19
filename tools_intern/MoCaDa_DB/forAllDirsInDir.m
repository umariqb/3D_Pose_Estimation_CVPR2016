function y = forAllDirsInDir(startdir, func, recursive, y, varargin)
% y = forAllDirsInDir(startdir, func, recursive, y, varargin)
%
% Traverse directory structure, performing for each directory
% an action defined by a function handle.
%
% INPUT:
% ------
% startdir ..... (string) Start directory. 
%                Any directory containing a file named "skip" will be skipped.
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

if (startdir(end)~=filesep)
    startdir = [startdir filesep];
end

files = dir(startdir);
if (isempty(strmatch('skip',{files.name},'exact'))) % only process dir if no "skip" file is present!
    disp(['Entered directory ' startdir]);
    disp(['Processing directory ' startdir]);
    if (nargin>4)
        args = horzcat({startdir}, varargin);
    else
        args = {startdir};
    end
    a = feval(func,args{:});
    if (~iscell(y))
        y(end+1,1) = a;
    else
        y{end+1,1} = a;
    end
    
    dirs = dir(startdir);
    isdir = cell2mat({dirs.isdir});
    dirs = dirs(find(isdir));
    for k=1:length(dirs)
        if (~strcmp(dirs(k).name,'..') & ~strcmp(dirs(k).name,'.'))
            if (recursive)
                y = forAllDirsInDir([startdir dirs(k).name], func, recursive, y, varargin{:});
            end
        end
    end
    disp(['Left directory ' startdir]);
else
    disp(['Skipped directory ' startdir]);
end
