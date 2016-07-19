function [ output_args ] = checkNFramesAMCvsC3D(  )

global VARS_GLOBAL

dbpath = VARS_GLOBAL.dir_root;
db1 = 'HDM05_amc';
db2 = 'HDM05_c3d';

actors = {'bd', 'bk', 'dg', 'mm', 'tr'};
% actors = {'dg', 'mm', 'tr'};

oldPath = cd;

for i=1:length(actors)
    path1 = fullfile(dbpath, db1, actors{i});
    path2 = fullfile(dbpath, db2, actors{i});    

    cd(path1);    
    disp(['Processing ' path1]);
    files = dir('*.amc');
    
    for j=1:length(files)
        filename = files(j).name;
        
        filename1 = fullfile(path1, filename);
        filename2 = fullfile(path2, [filename(1:end-3) 'c3d']);
        
        disp(['    ' filename1]);
        [skelAMC, motAMC] = readMocapSmart( filename1 );
        [skelC3D, motC3D] = readMocapSmart( filename2 );
        
        if motAMC.nframes ~= motC3D.nframes
            disp([filename1 ': ' num2str(motAMC.nframes) ' (AMC) vs. ' num2str(motC3D.nframes) ' (C3D) ']);
        end
    end
end

cd(oldPath);
