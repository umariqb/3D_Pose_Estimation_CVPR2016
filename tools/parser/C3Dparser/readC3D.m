function [Markers,VideoFrameRate,AnalogSignals,AnalogFrameRate,Event,ParameterGroup,CameraInfo,ResidualError]=readC3D(FullFileName)
% GetC3D:	Getting 3D coordinate/analog data from a C3D file 
%
% Input:	FullFileName - file (including path) to be read
%
% Output:
% Markers            3D-marker data [Nmarkers x NvideoFrames x Ndim(=3)]
% VideoFrameRate     Frames/sec
% AnalogSignals      Analog signals [Nsignals x NanalogSamples ]
% AnalogFrameRate    Samples/sec
% Event              Event(Nevents).time ..value  ..name
% ParameterGroup     ParameterGroup(Ngroups).Parameters(Nparameters).data ..etc.
% CameraInfo         MarkerRelated CameraInfo [Nmarkers x NvideoFrames]
% ResidualError      MarkerRelated ErrorInfo  [Nmarkers x NvideoFrames]

% AUTHOR(S) AND VERSION-HISTORY
% Ver. 1.0 Creation (Alan Morris, Toronto, October 1998) [originally named "getc3d.m"]
% Ver. 2.0 Revision (Jaap Harlaar, Amsterdam, april 2002)

Markers=[];
VideoFrameRate=0;
AnalogSignals=[];
AnalogFrameRate=0;
Event=[];
ParameterGroup=[];
CameraInfo=[];
ResidualError=[];

% ###############################################
% ##                                           ##
% ##    open the file                          ##
% ##                                           ##
% ###############################################

ind=findstr(FullFileName,'\');
if ind>0, FileName=FullFileName(ind(length(ind))+1:length(FullFileName)); else FileName=FullFileName; end

fid=fopen(FullFileName,'r','n'); % native format (PC-intel)

if fid==-1,
h=errordlg(['File: ',FileName,' could not be opened'],'application error');
uiwait(h)
return
end

NrecordFirstParameterblock=fread(fid,1,'int8');     % Reading record number of parameter section
key=fread(fid,1,'int8');                           % key = 80;

if key~=80,
h=errordlg(['File: ',FileName,' does not comply to the C3D format'],'application error');
uiwait(h)
fclose(fid)
return
end


fseek(fid,512*(NrecordFirstParameterblock-1)+3,'bof'); % jump to processortype - field
proctype=fread(fid,1,'int8')-83;                       % proctype: 1(INTEL-PC); 2(DEC-VAX); 3(MIPS-SUN/SGI)

if proctype==2,
    fclose(fid);
   % fid=fopen(FullFileName,'r','d'); % DEC VAX D floating point and VAX ordering
    fid=fopen(FullFileName,'r','n'); % DEC VAX D floating point and VAX ordering
end
    
% ###############################################
% ##                                           ##
% ##    read header                            ##
% ##                                           ##
% ###############################################

%NrecordFirstParameterblock=fread(fid,1,'int8');     % Reading record number of parameter section
%key1=fread(fid,1,'int8');                           % key = 80;

fseek(fid,2,'bof');

Nmarkers=fread(fid,1,'int16');			        %number of markers
NanalogSamplesPerVideoFrame=fread(fid,1,'int16');			%number of analog channels x #analog frames per video frame
StartFrame=fread(fid,1,'int16');		        %# of first video frame

EndFrame=fread(fid,1,'int16');			        %# of last video frame

MaxInterpolationGap=fread(fid,1,'int16');		%maximum interpolation gap allowed (in frame)

Scale=fread(fid,1,'float32');			        %floating-point scale factor to convert 3D-integers to ref system units

NrecordDataBlock=fread(fid,1,'int16');			%starting record number for 3D point and analog data

NanalogFramesPerVideoFrame=fread(fid,1,'int16');
if NanalogFramesPerVideoFrame > 0,
    NanalogChannels=NanalogSamplesPerVideoFrame/NanalogFramesPerVideoFrame;	
else
    NanalogChannels=0;
end


VideoFrameRate=fread(fid,1,'float32');
AnalogFrameRate=VideoFrameRate*NanalogFramesPerVideoFrame;

% ###############################################
% ##                                           ##
% ##    read events                            ##
% ##                                           ##
% ###############################################

fseek(fid,298,'bof');
EventIndicator=fread(fid,1,'int16');	
if EventIndicator==12345,
    Nevents=fread(fid,1,'int16');	
    fseek(fid,2,'cof'); % skip one position/2 bytes
    if Nevents>0,
        for i=1:Nevents,
            Event(i).time=fread(fid,1,'float');
        end
        fseek(fid,188*2,'bof');
        for i=1:Nevents,
            Event(i).value=fread(fid,1,'int8');
        end
         fseek(fid,198*2,'bof');
        for i=1:Nevents,
            Event(i).name=cellstr(char(fread(fid,4,'char')'));
        end
    end
end


% ###############################################
% ##                                           ##
% ##    read 1st parameter block               ##
% ##                                           ##
% ###############################################

fseek(fid,512*(NrecordFirstParameterblock-1),'bof');

dat1=fread(fid,1,'int8'); 
key2=fread(fid,1,'int8');                   % key = 80;
NparameterRecords=fread(fid,1,'int8');
proctype=fread(fid,1,'int8')-83;            % proctype: 1(INTEL-PC); 2(DEC-VAX); 3(MIPS-SUN/SGI)


Ncharacters=fread(fid,1,'int8');   			% characters in group/parameter name
GroupNumber=fread(fid,1,'int8');				% id number -ve=group / +ve=parameter


while Ncharacters > 0 % The end of the parameter record is indicated by <0 characters for group/parameter name
    
    if GroupNumber<0 % Group data
        GroupNumber=abs(GroupNumber); 
        GroupName=fread(fid,[1,Ncharacters],'char');			
        ParameterGroup(GroupNumber).name=cellstr(char(GroupName));	%group name
        offset=fread(fid,1,'int16');							%offset in bytes
        deschars=fread(fid,1,'int8');							%description characters
        GroupDescription=fread(fid,[1,deschars],'char');
        ParameterGroup(GroupNumber).description=cellstr(char(GroupDescription)); %group description
        
        ParameterNumberIndex(GroupNumber)=0;
        fseek(fid,offset-3-deschars,'cof');
        
        
    else % parameter data
        clear dimension;
        ParameterNumberIndex(GroupNumber)=ParameterNumberIndex(GroupNumber)+1;
        ParameterNumber=ParameterNumberIndex(GroupNumber);              % index all parameters within a group
        
        ParameterName=fread(fid,[1,Ncharacters],'char');				% name of parameter
        
        % read parameter name
        if size(ParameterName)>0
            ParameterGroup(GroupNumber).Parameter(ParameterNumber).name=cellstr(char(ParameterName));	%save parameter name
        end
        
        % read offset 
        offset=fread(fid,1,'int16');							%offset of parameters in bytes
        filepos=ftell(fid);										%present file position
        nextrec=filepos+offset(1)-2;							%position of beginning of next record
        
        
        % read type
        type=fread(fid,1,'int8');     % type of data: -1=char/1=byte/2=integer*2/4=real*4
        ParameterGroup(GroupNumber).Parameter(ParameterNumber).datatype=type;
        
        
        % read number of dimensions
        dimnum=fread(fid,1,'int8');
        if dimnum==0 
            datalength=abs(type);								%length of data record
        else
            mult=1;
            for j=1:dimnum
                dimension(j)=fread(fid,1,'int8');
                mult=mult*dimension(j);
                ParameterGroup(GroupNumber).Parameter(ParameterNumber).dim(j)=dimension(j);  %save parameter dimension data
            end
            datalength=abs(type)*mult;							%length of data record for multi-dimensional array
        end
        
        
        if type==-1 %datatype=='char'  
            
            wordlength=dimension(1);	%length of character word
            if dimnum==2 & datalength>0 %& parameter(idnumber,index,2).dim>0            
                for j=1:dimension(2)
                    data=fread(fid,[1,wordlength],'char');	%character word data record for 2-D array
                    ParameterGroup(GroupNumber).Parameter(ParameterNumber).data(j)=cellstr(char(data));
                end
                
            elseif dimnum==1 & datalength>0
                data=fread(fid,[1,wordlength],'char');		%numerical data record of 1-D array
                ParameterGroup(GroupNumber).Parameter(ParameterNumber).data=cellstr(char(data));
            end
            
        elseif type==1    %1-byte for boolean
            
            Nparameters=datalength/abs(type);		
            data=fread(fid,Nparameters,'int8');
            ParameterGroup(GroupNumber).Parameter(ParameterNumber).data=data;
            
        elseif type==2 & datalength>0			%integer
            
            Nparameters=datalength/abs(type);		
            data=fread(fid,Nparameters,'int16');
            if dimnum>1
                ParameterGroup(GroupNumber).Parameter(ParameterNumber).data=reshape(data,dimension);
            else
                ParameterGroup(GroupNumber).Parameter(ParameterNumber).data=data;
            end
            
        elseif type==4 & datalength>0
            
            Nparameters=datalength/abs(type);
            data=fread(fid,Nparameters,'float');
            if dimnum>1
                ParameterGroup(GroupNumber).Parameter(ParameterNumber).data=reshape(data,dimension);
            else
                ParameterGroup(GroupNumber).Parameter(ParameterNumber).data=data;
            end
        else
            % error
        end
        
        deschars=fread(fid,1,'int8');							%description characters
        if deschars>0
            description=fread(fid,[1,deschars],'char');
            ParameterGroup(GroupNumber).Parameter(ParameterNumber).description=cellstr(char(description));
        end
        %moving ahead to next record
        fseek(fid,nextrec,'bof');
    end
    
    % check group/parameter characters and idnumber to see if more records present
    Ncharacters=fread(fid,1,'int8');   			% characters in next group/parameter name
    GroupNumber=fread(fid,1,'int8');				% id number -ve=group / +ve=parameter
end


% ###############################################
% ##                                           ##
% ##    read data block                        ##
% ##                                           ##
% ###############################################
%  Get the coordinate and analog data

fseek(fid,(NrecordDataBlock-1)*512,'bof');

h = waitbar(0,[FileName,' is loading...']);

NvideoFrames=EndFrame - StartFrame + 1;			

if Scale < 0
    
    speedUp = true;
%     speedUp = false;
    
    if speedUp  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  START OF SPEED-UP MODIFACTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        MarkerMatrix = fread(fid, NvideoFrames * Nmarkers * 4, 'float32');
        MarkerMatrix = shiftdim(reshape( MarkerMatrix, 4, Nmarkers, NvideoFrames),1);
        Markers(:,:,1) = MarkerMatrix(:,:,1)';
        Markers(:,:,2) = MarkerMatrix(:,:,2)';
        Markers(:,:,3) = MarkerMatrix(:,:,3)';
        
        % REMARK:   I don't really know, if CameraInfo and ResidualError are calculated correctly since I did not have
        %           any C3D-files with that data included to test the behaviour.
        %           The section below is the origignal source from the www.c3d.org-parser.
        a = fix(MarkerMatrix(:,:,4)');
        if abs(max(max(a))) > 0
            disp('Warning: Experimental parser. Check readC3D.m for details.');
        end
        highbyte=fix(a/256);
        lowbyte=a-highbyte*256; 
        CameraInfo=highbyte; 
        ResidualError=lowbyte*abs(Scale); 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END OF SPEED-UP MODIFACTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        for i=1:NvideoFrames
            for j=1:Nmarkers
                Markers(i,j,1:3)=fread(fid,3,'float32')'; 
                a=fix(fread(fid,1,'float32'));  
                highbyte=fix(a/256);
                lowbyte=a-highbyte*256; 
                CameraInfo(i,j)=highbyte; 
                ResidualError(i,j)=lowbyte*abs(Scale); 
            end
            waitbar(i/NvideoFrames)
            for j=1:NanalogFramesPerVideoFrame,
                AnalogSignals(j+NanalogFramesPerVideoFrame*(i-1),1:NanalogChannels)=...
                    fread(fid,NanalogChannels,'int16')';
            end
        end
    end
else
    for i=1:NvideoFrames
        for j=1:Nmarkers
            Markers(i,j,1:3)=fread(fid,3,'int16')'.*Scale;
            ResidualError(i,j)=fread(fid,1,'int8');
            CameraInfo(i,j)=fread(fid,1,'int8');
        end
        waitbar(i/NvideoFrames)
        for j=1:NanalogFramesPerVideoFrame,
            AnalogSignals(j+NanalogFramesPerVideoFrame*(i-1),1:NanalogChannels)=...
                fread(fid,NanalogChannels,'int16')';
        end
    end
end
    close(h) % waitbar

fclose(fid);

return
% ======================
% end getc3D.m

