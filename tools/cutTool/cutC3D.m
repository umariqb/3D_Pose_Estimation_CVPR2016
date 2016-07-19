function cutC3D(fullFileNameIn, fullFileNameOut, frameFrom, frameTo)
%
% cutC3D(fullFileNameIn, fullFileNameOut, frameFrom, frameTo)
%

if strcmp(fullFileNameIn, fullFileNameOut)
    h=errordlg('Identical input and output file is not possible.','application error');
    uiwait(h)
    return
end

% ###############################################
% ##    open files and check compatibility     ##
% ###############################################
fin  = fopen(fullFileNameIn,'r'); 
fout  = fopen(fullFileNameOut,'w'); 

if fin==-1
    h=errordlg(['File: ',fullFileNameIn,' could not be opened'],'application error');
    uiwait(h)
    return
end

if fout==-1
    h=errordlg(['File: ',fullFileNameOut,' could not be opened'],'application error');
    uiwait(h)
    return
end

NrecordFirstParameterblock=fread(fin,1,'int8');     % Reading record number of parameter section

key=fread(fin,1,'int8');                           % key = 80;

if key~=80
    h=errordlg(['File: ',FileName,' does not comply to the C3D format'],'application error');
    uiwait(h)
    fclose(fin)
    return
end

% ###############################################
% ##    copy modified header                   ##
% ###############################################

fwrite(fout, NrecordFirstParameterblock, 'int8');
fwrite(fout, 80, 'int8');

fseek(fin, 2, 'bof');

Nmarkers=fread(fin,1,'int16');			        %number of markers
NanalogSamplesPerVideoFrame=fread(fin,1,'int16');%number of analog channels x #analog frames per video frame

StartFrame=fread(fin,1,'int16');		        %# of first video frameEndFrame=fread(fin,1,'int16');			        %# of last video frame
MaxInterpolationGap=fread(fin,1,'int16');		%maximum interpolation gap allowed (in frame)
Scale=fread(fin,1,'float32');			        %floating-point scale factor to convert 3D-integers to ref system units
NrecordDataBlock=fread(fin,1,'int16');			%starting record number for 3D point and analog data

fwrite(fout, Nmarkers, 'int16');
fwrite(fout, NanalogSamplesPerVideoFrame, 'int16');
fwrite(fout, 1, 'int16');
fwrite(fout, frameTo - frameFrom + 1, 'int16');
fwrite(fout, MaxInterpolationGap, 'int16');
fwrite(fout, Scale, 'float32');
fwrite(fout, NrecordDataBlock, 'int16');

% ###############################################
% ##    copy everything up to data block       ##
% ###############################################
% fseek(fin, 0, 'bof');
currentPos = ftell(fin);
data = fread(fin, (NrecordDataBlock-1)*512 - currentPos, 'int8');
fwrite(fout, data, 'int8');

% ###############################################
% ##    copy data block                        ##
% ###############################################
% fseek(fin,(NrecordDataBlock-1)*512,'bof');

NvideoFrames = EndFrame - StartFrame + 1;			
NvideoFramesNew = frameTo - frameFrom + 1;

if Scale < 0
    numberFormat = 'float32';
else
    numberFormat = 'int16';
end

if frameFrom > 1
    fread(fin, Nmarkers*4*(frameFrom - 1), numberFormat);
end

% copy relevant data
data = fread(fin, Nmarkers*4*NvideoFramesNew, numberFormat);
fwrite(fout, data, numberFormat);

% if Scale < 0
%     % skip forward to "frameFrom"
%     if frameFrom > 1
%         fread(fin, Nmarkers*4*(frameFrom - 1), 'float32');
%     end
% 
%     % copy relevant data
%     data = fread(fin, Nmarkers*4*NvideoFramesNew, 'float32');
%     fwrite(fout, data, 'float32');
%           
% else
%     % skip forward to "frameFrom"
%     if frameFrom > 1
%         fread(fin, Nmarkers*4*(frameFrom - 1), 'int16');
%     end
% 
%     % copy relevant data
%     data = fread(fin, Nmarkers*4*NvideoFramesNew, 'int16');     % precisely: 3*int16 + 2*int8
%     fwrite(fout, data, 'float32');
% end

fclose(fin);
fclose(fout);

return
