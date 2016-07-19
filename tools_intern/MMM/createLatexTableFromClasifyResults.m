function createLatexTableFromClasifyResults(filename, varargin)

fid=fopen(filename,'w');

% Write header for Table

fprintf(fid,'%% Generated Table(createLatexTableFromClassifyResults)\n');
fprintf(fid,'\\begin{table}[htb]\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\begin{tabular}{|r|c|c|c|}\n');
fprintf(fid,'\\hline\n');
fprintf(fid,'Class & correct hits & false hits & impossible hits \\\\\n');
fprintf(fid,'\\hline\n');

% Now Data from Varargin should be parsed...

c=1;
for arg=1:3:nargin-2
    tmp(c,:)=evaluateClassifyResults(varargin{arg},varargin{arg+1});
    fprintf(fid, [varargin{arg+2} '& %i & %i & %i \\\\\n'],...
                 tmp(c,1),tmp(c,2),tmp(c,3));
    c=c+1;
end
fprintf(fid,'\\hline\n');

fprintf(fid,'All & %i & %i & %i\\\\\n',sum(tmp(:,1)),sum(tmp(:,2)),sum(tmp(:,3)));

% Now End of table:
fprintf(fid,'\\hline\n');
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\end{table}\n');
% fprintf(fid,'  ');
% fprintf(fid,'  ');
% fprintf(fid,'  ');
% fprintf(fid,'  ');
% fprintf(fid,'  ');
fprintf(fid,'%% Generated Table(createLatexTableFromClassifyResults)\n');
fclose(fid);
