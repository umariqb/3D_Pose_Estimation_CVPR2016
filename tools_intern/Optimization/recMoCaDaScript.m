function rec = recMoCaDaScript(db)

frameRate = 30;
% frameRate = 60;

% hdm_uncut = 'S:\HDM_DB\HDM05\HDM05_amc';
% cmu_uncut = 'S:\CMU_DB\CMU_D180\AMC';

paths = {'E:\CMU_2008-12-18\all_asfamc\subjects'};
% paths = {'E:\CMU_2008-12-18\all_asfamc\subjects\69';...
%          'E:\CMU_2008-12-18\all_asfamc\subjects\86';...
%          'E:\CMU_2008-12-18\all_asfamc\subjects\128';...
%          'E:\CMU_2008-12-18\all_asfamc\subjects\135';...
%          'E:\CMU_2008-12-18\all_asfamc\subjects\141'};

c=0;
for i=1:length(paths)
    s = genpath(paths{i});
    p = 1;
    c=c+1;
    while true
        dirs{c,1} = strtok(s(p:end), pathsep);
        p = p + length(dirs{c}) + 1;
        if isempty(strfind(s(p:end), pathsep))
            break
        else
            c=c+1;
        end;
    end
end

nrOfFolders = length(dirs);
nrOfFilesTotal = 0;

amcfiles = cell(nrOfFolders,1);
nrOfFiles = zeros(nrOfFolders,1);

for i=1:nrOfFolders
    amcfiles{i}     = dir(fullfile(dirs{i},'*.amc'));
    nrOfFiles(i)    = length(amcfiles{i});
    nrOfFilesTotal  = nrOfFilesTotal + nrOfFiles(i);
end

rec = cell(nrOfFolders,max(nrOfFiles));

for i=1:nrOfFolders

    fprintf('\nFolder %i does contain %i amc-files.',i,nrOfFiles(i));

    for j=1:nrOfFiles(i)
        
        amc_filename = amcfiles{i}(j).name;
        asf_filename = [strtok(amc_filename,'_') '.asf'];
        mat_filename = [amc_filename '.mat'];
        
        h = fopen(fullfile(dirs{i},mat_filename));
        
        if (h~=-1) 
                fprintf('\nReading file %s (file %i / %i in folder %i / %i, %i / %i in total)\n',mat_filename,j,nrOfFiles(i),i,nrOfFolders,sum(nrOfFiles(1:i-1))+j,nrOfFilesTotal);
            fclose(h);
            load(fullfile(dirs{i},mat_filename), 'skel', 'mot');
        else
            try
                fprintf('\nReading file %s (file %i / %i in folder %i / %i, %i / %i in total)\n',amc_filename,j,nrOfFiles(i),i,nrOfFolders,sum(nrOfFiles(1:i-1))+j,nrOfFilesTotal);
                skel = readASF(fullfile(dirs{i},asf_filename));
                mot = readAMC(fullfile(dirs{i},amc_filename),skel);
                save(fullfile(dirs{i},mat_filename), 'skel', 'mot');
            catch
                fprintf('\nCould not read file!\n');
            end 
        end
        
        mot = changeFrameRate(skel,mot,frameRate);
        
        rec{i,j}        = recMotKD_acc3(skel,mot,db);
        rec{i,j}.dists  = compareMotions08(skel,rec{i,j}.origmot,rec{i,j}.recmot);
        % Speicherplatz sparen:
        rec{i,j}.origmot.jointTrajectories  = [];
        rec{i,j}.recmot.jointTrajectories   = [];
        rec{i,j}.origmot.rotationEuler      = [];
        rec{i,j}.recmot.rotationEuler       = [];

        save('rec','rec');
    
    end
end

clear nrOfFiles nrOfFolders i j amc_filename asf_filename mat_filename skel mot h;

end