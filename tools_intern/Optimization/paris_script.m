

for allFiles
    
    amc_filename = ######;
    asf_filename = [amc_filename(1:6) '.asf'];
    mat_filename = [amc_filename '.mat'];

    h = fopen(fullfile(pathstr,mat_filename));
    if (h~=-1) 
        fclose(h);
        load(fullfile(pathstr,mat_filename), 'skel', 'mot');
    else
        try
            skel = readASF(fullfile(pathstr,asf_filename));
            mot = readAMC(fullfile(pathstr,amc_filename),skel);
            save(fullfile(pathstr,mat_filename), 'skel', 'mot');
        catch
            fprintf('\nCould not read file!');
        end
    end
        
    rec{i} = recMotKD_acc3(skel,mot,data512);
    rec{i}.dists = compareMotions08(skel,rec{i}.origmot,rec{i}.recmot);