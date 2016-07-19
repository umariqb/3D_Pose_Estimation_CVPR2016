function [csvLabels,csvData] = BK_load_csv(fileName);
% Mat-Filename:

BKmatName=[fileName '.MAT'];

[fid] = fopen(BKmatName, 'r');

if fid == -1
    % MAT-File doesn't exist

    A = exist(fileName);
    if A==2
        % Load csv-file with motion data
        motiondata=importdata(fileName);

        % Extract Data
        csvLabels =motiondata.textdata();
        csvData   =motiondata.data();

        %Save a Mat-File
        save(BKmatName, 'Labels', 'Data');
    else
       csvLabels =[];
       csvData   =[]; 
    end
else
    % MAT-File can be loaded
    load(BKmatName, 'Labels', 'Data');
    fclose(fid);
end