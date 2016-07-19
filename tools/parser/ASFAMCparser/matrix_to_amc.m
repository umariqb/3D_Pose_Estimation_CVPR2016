% Writes motion data from matrix D to an AMC file on disk.
% The ACM format is the format used in the CMU online motion capture database
% function [] = matrix_to_amc(fname, D)
% fname = output disk file name for AMC file
% D = input Matlab data matrix
% Example:
% matrix_to_amc('running1.amc', D)
%
%

% Jernej Barbic
% CMU
% March 2003
% Databases Course
function [] = matrix_to_amc(fname, D)

fid=fopen(fname, 'wt');
if fid == -1,
    fprintf('Error, can not open file %s.\n', fname);
	return;
end;

% print header
fprintf(fid,'#!Matlab matrix to amc conversion\n');
fprintf(fid,':FULLY-SPECIFIED\n');
fprintf(fid,':DEGREES\n');

[rows, cols] = size(D);

% print data
for frame=1:rows
  fprintf(fid,'%d\n',frame);

  fprintf(fid,'root %f %f %f %f %f %f\n', D(frame,1:6));
  fprintf(fid,'lowerback %f %f %f\n', D(frame,7:9));
  fprintf(fid,'upperback %f %f %f\n', D(frame,10:12));
  fprintf(fid,'thorax %f %f %f\n', D(frame,13:15));
  fprintf(fid,'lowerneck %f %f %f\n', D(frame,16:18));
  fprintf(fid,'upperneck %f %f %f\n', D(frame,19:21));
  fprintf(fid,'head %f %f %f\n', D(frame,22:24));
  fprintf(fid,'rclavicle %f %f\n', D(frame,25:26));
  fprintf(fid,'rhumerus %f %f %f\n', D(frame,27:29));
  fprintf(fid,'rradius %f\n', D(frame,30));
  fprintf(fid,'rwrist %f\n', D(frame,31));
  fprintf(fid,'rhand %f %f\n', D(frame,32:33));
  fprintf(fid,'rfingers %f\n', D(frame,34));
  fprintf(fid,'rthumb %f %f\n', D(frame,35:36));
  fprintf(fid,'lclavicle %f %f\n', D(frame,37:38));
  fprintf(fid,'lhumerus %f %f %f\n', D(frame,39:41));
  fprintf(fid,'lradius %f\n', D(frame,42));
  fprintf(fid,'lwrist %f\n', D(frame,43));
  fprintf(fid,'lhand %f %f\n', D(frame,44:45));
  fprintf(fid,'lfingers %f\n', D(frame,46));
  fprintf(fid,'lthumb %f %f\n', D(frame,47:48));
  fprintf(fid,'rfemur %f %f %f\n', D(frame,49:51));
  fprintf(fid,'rtibia %f\n', D(frame,52));
  fprintf(fid,'rfoot %f %f\n', D(frame,53:54));
  fprintf(fid,'rtoes %f\n', D(frame,55));
  fprintf(fid,'lfemur %f %f %f\n', D(frame,56:58));
  fprintf(fid,'ltibia %f\n', D(frame,59));
  fprintf(fid,'lfoot %f %f\n', D(frame,60:61));
  fprintf(fid,'ltoes %f\n', D(frame,62));

end

fclose(fid);


