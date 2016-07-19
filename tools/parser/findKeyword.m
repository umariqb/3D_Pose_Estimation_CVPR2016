function [b, line, pos, line_count] = findKeyword(varargin)
% stops at first occurence of any of the keywords. NOT case sensitive!
% args: fid,keywords
if nargin < 2
    error('Not enough arguments!');
end
fid = varargin{1};

pos = 0;
line_count = 0;
line = [];
while ~feof(fid)
    l = eatWhitespace(fgetl(fid));
    line_count = line_count + 1;
    for i = 2:nargin
        k = strfind(upper(l),upper(varargin{i}));
        if size(k) > 0
            line = l(k:size(l,2));
            b = true;
            pos = ftell(fid);
            return;
        end
    end
end
b = false;
