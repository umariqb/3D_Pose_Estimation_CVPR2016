function skel=getSkelFromAMC(filename)

    info = filename2info(filename);
    skel = readASF(fullfile(info.amcpath,info.asfname));
    
end

