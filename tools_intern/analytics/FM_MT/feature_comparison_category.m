function [diff, diffPerFeature] = feature_comparison_category( compFunction, category, dbName1, dbName2, constBoneLengths )

global VARS_GLOBAL
dbPath = VARS_GLOBAL.dir_root;

if nargin < 3
    dbName1 = 'HDM05_cut_amc';
    dbName2 = 'HDM05_cut_c3d';
    constBoneLengths = true;
end

relPath1 = fullfile(dbName1, category);
relPath2 = fullfile(dbName2, category);

absPath1 = fullfile(dbPath, dbName1, category);
absPath2 = fullfile(dbPath, dbName2, category);

files = dir(absPath1);
counter = 0;

diff = 0;
diffPerFeature = zeros(39,1);

for i=1:length(files)
    if not(files(i).isdir)
        file1 = fullfile(absPath1, files(i).name);
        ext1 = files(i).name(end-3:end);
        
        if strcmpi(ext1, '.C3D')
            ext2 = '.AMC';
        elseif strcmpi(ext1, '.AMC')
            ext2 = '.C3D';
        else
            %             disp(['Skipping file ' file1]);
            continue;
        end
        
        file2 = fullfile(absPath2, [files(i).name(1:end-4) ext2]);
        
        counter = counter + 1;
        switch lower(compFunction)
            case 'bitdiff'
                [diff(counter), diffPerFeature(:,counter)] = feature_comparison_bitDiff(file1, file2);
            case 'adv'
                [diff(counter), diffPerFeature(:,counter)] = feature_comparison_adv(file1, file2, true);
            case 'featurecurves'
                [diff(counter), diffPerFeature(:,counter)] = feature_comparison_featureCurves(file1, file2);
            case 'featurecurvesadv'
                [diff(counter), diffPerFeature(:,counter)] = feature_comparison_featureCurvesAdv(file1, file2);
%             case 'fmdtw'
%                 diff(counter) = featureMatrixComparisonDTW(file1, file2, constBoneLengths);
            otherwise
                error(['Unknow comparison function: ''' compFunction]);
        end
        
        disp([files(i).name(1:end-4) ': ' num2str(100*diff(counter)) '% of feature values are different']);
    end
end

disp('');
disp(['Average difference is ' num2str(100*mean(diff)) '%, best is ' num2str(100*min(diff)) '%, worst is ' num2str(100*max(diff)) '%, std. dev. is ' num2str(100*std(diff)) '%.']);