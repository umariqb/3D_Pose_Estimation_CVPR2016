function updateNameMaps( fullMATFilename )

ext  = fullMATFilename(end-3:end);

if(strcmp(upper(ext), '.MAT'))
    load(fullMATFilename, 'skel', 'mot');
    nameMap = getNameMapFromC3D(fullMATFilename(1:end-4));
    mot.nameMap = nameMap;
    skel.nameMap = nameMap;
    save(fullMATFilename, 'skel', 'mot');
    disp([fullMATFilename ' updated.']);

end            
