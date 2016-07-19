% Reads data from an AMC motion file into a Matlab matrix variable. 
% AMC file has to be in the AMC format used in the online CMU motion capture library.
% number of dimensions = number of columns = 62
% function D = amc_to_matrix(fname)
% fname = name of disk input file, in AMC format
% Example:
% D = amc_to_matrix(fname)
%

% Jernej Barbic
% CMU
% March 2003
% Databases Course
function [D] = amc_to_matrix(fname)


fid=fopen(fname, 'rt');
if fid == -1,
 fprintf('Error, can not open file %s.\n', fname);
 return;
end;

% read-in header
line=fgetl(fid);
while ~strcmp(line,':DEGREES')
  line=fgetl(fid);
end

D=[];
dims =[6 3 3 3 3 3 3 2 3 1 1 2 1 2 2 3 1 1 2 1 2 3 1 2 1 3 1 2 1];
locations = [1 7 10 13 16 19 22 25 27 30 31 32 34 35 37 39 42 43 44 46 47 49 52 53 55 56 59 60 62];

% read-in data
% labels can be in any order
frame=1;
while ~feof(fid)
  if rem(frame,100) == 0
 disp('Reading frame: ');
 disp(frame);
  end;

  row = zeros(62,1);

  % read frame number
  line = fscanf(fid,'%s\n',1);

  for i=1:29

 % read angle label
 id = fscanf (fid,'%s',1);

 switch (id)
   case 'root', index = 1;
   case 'lowerback', index = 2;
   case 'upperback', index = 3;
   case 'thorax', index = 4; 
   case 'lowerneck', index = 5; 
   case 'upperneck', index = 6; 
   case 'head', index = 7;
   case 'rclavicle', index = 8; 
   case 'rhumerus', index = 9;
   case 'rradius', index = 10;
   case 'rwrist', index = 11;
   case 'rhand', index = 12;
   case 'rfingers', index = 13;
   case 'rthumb', index = 14;
   case 'lclavicle', index = 15; 
   case 'lhumerus', index = 16;
   case 'lradius', index = 17;
   case 'lwrist', index = 18;
   case 'lhand', index = 19;
   case 'lfingers', index = 20;
   case 'lthumb', index = 21;
   case 'rfemur', index = 22;
   case 'rtibia', index = 23;
   case 'rfoot', index = 24;
   case 'rtoes', index = 25;
   case 'lfemur', index = 26;
   case 'ltibia', index = 27;
   case 'lfoot', index = 28;
   case 'ltoes', index = 29; 
 otherwise
    fprintf('Error, labels in the amc are not correct.\n');
    return;
 end
 
 % where to put the data
 location = locations(index);
 len = dims(index);

 if len == 6
   x = fscanf (fid,'%f %f %f %f %f %f\n',6);
 else 
   if len == 3
  x = fscanf (fid,'%f %f %f\n',3);
   else 
  if len == 2
    x = fscanf (fid,'%f %f\n',2);
  else 
    if len == 1
   x = fscanf (fid,'%f\n',1);
    end
  end
   end
 end
 
 row(location:location+len-1,1) = x;
  end
  row = row';
  D = [D; row];
  frame = frame + 1;
end

disp('Total number of frames read: ');
disp(frame-1);

fclose(fid);
