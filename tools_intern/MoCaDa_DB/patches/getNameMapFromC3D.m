function nameMap = getNameMapFromC3D( fileName )
% nameMap = getNameMapFromC3D( fileName )
%

Markers=[];
VideoFrameRate=0;
AnalogSignals=[];
AnalogFrameRate=0;
Event=[];
ParameterGroup=[];
CameraInfo=[];
ResidualError=[];

fid=fopen(fileName,'r','n'); % native format (PC-intel)

NrecordFirstParameterblock=fread(fid,1,'int8');     % Reading record number of parameter section
key=fread(fid,1,'int8');                           % key = 80;

if key~=80,
    h=errordlg(['File: ',fileName,' does not comply to the C3D format'],'application error');
    uiwait(h)
    fclose(fid)
    return
end

fseek(fid,512*(NrecordFirstParameterblock-1)+3,'bof'); % jump to processortype - field
proctype=fread(fid,1,'int8')-83;                       % proctype: 1(INTEL-PC); 2(DEC-VAX); 3(MIPS-SUN/SGI)

if proctype==2,
    fclose(fid);
    fid=fopen(fileName,'r','d'); % DEC VAX D floating point and VAX ordering
end

% ###############################################
% ##                                           ##
% ##    read header                            ##
% ##                                           ##
% ###############################################

fseek(fid,2,'bof');

Nmarkers=fread(fid,1,'int16');			        %number of markers
NanalogSamplesPerVideoFrame=fread(fid,1,'int16');			%number of analog channels x #analog frames per video frame
StartFrame=fread(fid,1,'int16');		        %# of first video frame
EndFrame=fread(fid,1,'int16');			        %# of last video frame
MaxInterpolationGap=fread(fid,1,'int16');		%maximum interpolation gap allowed (in frame)
Scale=fread(fid,1,'float32');			        %floating-point scale factor to convert 3D-integers to ref system units
NrecordDataBlock=fread(fid,1,'int16');			%starting record number for 3D point and analog data
NanalogFramesPerVideoFrame=fread(fid,1,'int16');
VideoFrameRate=fread(fid,1,'float32');

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

fclose(fid);

pointIdx = strmatch('POINT',[ParameterGroup(:).name]);
labelsIdx = strmatch('LABELS', [ParameterGroup( pointIdx ).Parameter(:).name]);
labels = ParameterGroup(pointIdx).Parameter(labelsIdx).data;
%% remove joint name group labels (everything before and including ':')
for i = 1:size(labels,2)
    pos = strfind(labels{i}, ':');
    if not(isempty(pos))
        labels{i} = labels{i}(pos+1:length(labels{i}));
    end
end

labels = mapLabelNamesToVicon(labels, 0);

for i = 1:length(labels)
    nameMap{i,1} = char(labels(i));
    nameMap{i,2} = 0;
    nameMap{i,3} = i;
end    
