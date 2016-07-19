function out_str = disptext(str,width,hindent,pindent)

% DISPTEXT displays long text in multiple lines, possibly indented.
% ------------------------------------------------
% out_str = disptext(str, width, hindent, pindent)
% ------------------------------------------------
% Description: displays long text in multiple lines, possibly indented.
% Input:       {str} string to display. Can be either a vector, a string
%                   array, or a cell array of strings.
%              {width} approximated line width. Some words can expand over
%                   this length in certain cases.
%              <{hindent}> indentation of first line (header) (def = 0).
%              <{pindent}> indentation of the rest of the paragraph
%                   (def=0). If only one of {hindent} and {pindent} is
%                   input, they are both taken equal.
% Output:      {out_str} char array hosting each line of the display in
%                   another row. If missing, the output is just displayed
%                   to the Matlab window.

% © Liran Carmel
% Classification: Display
% Last revision date: 24-Sep-2004

% parse input line
error(nargchk(2,4,nargin));
error(chkvar(str,{'char','cell'},{},{mfilename,inputname(1),1}));
error(chkvar(width,'integer','scalar',{mfilename,inputname(2),2}));
if nargin == 2
    hindent = 0;
    pindent = 0;
elseif nargin == 3
    pindent = hindent;
end
error(chkvar(hindent,'integer',{'scalar',{'lowerthan',width}},...
    {mfilename,'indentation',0}));
error(chkvar(pindent,'integer',{'scalar',{'lowerthan',width}},...
    {mfilename,'paragraph indentation',0}));

% transform {str} from cell of strings into string array
if iscell(str)
    if iscellstr(str)
        str = char(str);
    else
        error('%s should be cellstr',inputname(1));
    end
end
% transform {str} from string array to a string vector
[rows cols] = size(str);
if rows > 1
    str = [blanks(rows)' str];
    cols = cols + 1;
    str = reshape(str',1,rows*cols);
end

% prepare {width}, {pwidth} and {str}
pwidth = width - pindent;
hwidth = width - hindent;
str = deblank(str);
str = reblank(str);

% initialize output if required
if nargout > 0
    out_str = '';
end

%% (1) display first line
% generate an indented line from the beggining of {str}
lin = blanks(hindent);
eff_width = min(hwidth,length(str));
lin = [lin str(1:eff_width)];
str(1:eff_width) = [];
% remove trailing spaces in {lin} and leading spaces in {str}
if isspace(lin(end))
    lin = deblank(lin);
    str = reblank(str);
else
    % remove leading spaces in {str}
    if ~isempty(str) && isspace(str(1))
        str = reblank(str);
    else
        idx = find(isspace(str));
        if isempty(idx)
            idx = length(str) + 1;
        end
        lin = [lin str(1:idx(1)-1)];
        str(1:idx(1)-1) = [];
        str = reblank(str);
    end
end
% display the line, or store it at output
if nargout > 0
    out_str = strvcat(out_str,lin); %#ok
else
    disp(lin);
end

%% (2) display the rest of the paragraph
% display line by line until {str} is emptied
while ~isempty(str)
    % generate an indented line from the beggining of {str}
    lin = blanks(pindent);
    eff_width = min(pwidth,length(str));
    lin = [lin str(1:eff_width)];
    str(1:eff_width) = [];
    % remove trailing spaces in {lin} and leading spaces in {str}
    if isspace(lin(end))
        lin = deblank(lin);
        str = reblank(str);
    else
        % remove leading spaces in {str}
        if ~isempty(str) && isspace(str(1))
            str = reblank(str);
        else
            idx = find(isspace(str));
            if isempty(idx)
                idx = length(str) + 1;
            end
            lin = [lin str(1:idx(1)-1)];
            str(1:idx(1)-1) = [];
            str = reblank(str);
        end
    end
    % display the line, or store it at output
    if nargout > 0
        out_str = strvcat(out_str,lin);     %#ok
    else
        disp(lin);
    end
end