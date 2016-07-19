function template = motionTemplateFlip(template,varargin)

perm = [2 1 4 3 6 5 8 7 9 10 12 11 14 13 16 15 18 17 19 21 20 22 23 24 26 25 28 27 30 29 31 32 34 33 36 35 37 38 39];
if (nargin>1)
    perm = varargin{1};
end

template = template(perm,:);
