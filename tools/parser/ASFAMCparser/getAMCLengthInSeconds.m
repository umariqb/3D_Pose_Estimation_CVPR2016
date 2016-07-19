function s = getAMCLengthInSeconds(amcfullpath)

[info,OK] = filename2info(amcfullpath);
fs = info.samplingRate;
if (~OK)
    fs = 120;
end

% first try to read compact BIN version of the file
h = fopen([amcfullpath '.BIN'],'r');
if (h > 0) % does compact BIN file exist?
    s = readNumFramesBIN(h)/fs;
else
% try reading compact TXT version of the file
    h = fopen([amcfullpath '.TXT'],'r');
    if (h > 0) % does compact TXT file exist?
		n = strfind(amcname,'_')-1;
		if (length(n)<2)
            disp(['**** Warning: Couldn''t locate ASF name within AMC name "' amcname '"!']);
            s = 0;
            return;
		end
		n = n(2);
		
		asffullpath = [info.amcpath info.asfname];
			
		mot = emptyMotion;
		skel = readASF(asffullpath);
		mot.njoints = skel.njoints;
		mot.jointNames = skel.jointNames;
		mot.boneNames = skel.boneNames;
		mot.nameMap = skel.nameMap;
		mot.animated = skel.animated;
		mot.unanimated = skel.unanimated;    
		mot.filename = amcname;
		mot.angleUnit = skel.angleUnit;
        [result,mot] = readFramesTXT(skel,mot,h,[1 inf]);
        s = lengthInSeconds(mot)
    else
        fid = fopen(amcfullpath,'r');
        s = readNumFrames(fid)/fs;
        fclose(fid);        
    end
end

disp(['Source: ' info.skeletonSource ', skelID: ' info.skeletonID ', category: ' info.motionCategory ', desc: ' info.motionDescription ', fs: ' num2str(info.samplingRate) ', duration: ' num2str(s) ' s.']);


