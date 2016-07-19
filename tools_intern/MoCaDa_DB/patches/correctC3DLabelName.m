function correctC3DLabelName( fullFilename, labelNr, oldLabelName, newLabelName )

fid = fopen(fullFilename, 'r+');

if fid==-1
    error('Could not open file!');
    return;
end

if length(oldLabelName) > length(newLabelName)
    newLabelName = [newLabelName repmat([' '], 1,length(oldLabelName)-length(newLabelName))];
end

pos = 939 + (labelNr-1)*30;

fseek(fid, pos, 'bof');
data = char(fread(fid, 30, 'char')');

if strcmp( data, [oldLabelName repmat([' '], 1,30 - length(oldLabelName))] )
    fseek(fid, pos, 'bof');
    fwrite(fid, newLabelName);
else
    error(['Could not find label "' oldLabelName '" in ' fullFilename '! Found "' deblank(data) '" instead.']);
end

fclose(fid);
