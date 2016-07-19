function write_features_txt(features_spec,varargin)

outfile = 'features.txt';
if (nargin > 1)
    outfile = varargin{1};
end

fid = fopen(outfile,'w');

names = features_spec_unique_name(features_spec);

fprintf(fid,'\\begin{verbatim}\n');
for k=1:length(features_spec)
    i = findstr(names{k},'bool_');
    if (isempty(i))
        name = names{k};
    else
        name = names{k}(i+5:end);
    end
    fprintf(fid,'%2d %s\n',k,name);
end
fprintf(fid,'\\end{verbatim}\n');

fclose(fid);