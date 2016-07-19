function matrix = matrixComparisonCategory( compFunction, DB_name1,  DB_name2, category, noGraphics)

if nargin < 5
    noGraphics = false;
end

global VARS_GLOBAL

DB_path1 = fullfile( VARS_GLOBAL.dir_root, DB_name1, category );
DB_path2 = fullfile( VARS_GLOBAL.dir_root, DB_name2, category );

files1 = [ dir(fullfile(DB_path1, '*.c3d')) dir(fullfile(DB_path1, '*.amc')) ];
files2 = [ dir(fullfile(DB_path2, '*.c3d')) dir(fullfile(DB_path2, '*.amc')) ];

filenames1 = {files1.name}';
filenames2 = {files2.name}';

if length(filenames1) ~= length(filenames2)
    error(['Different number of files in ' DB_path1 ' and ' DB_path2 '!']);
end

for i=1:length(files1)
    fileName1 = files1(i).name;
    fileName2 = filenames2{strmatch(fileName1(1:end-3), filenames2)};
    
    fullFile1 = fullfile(DB_path1, fileName1);
    fullFile2 = fullfile(DB_path2, fileName2);
    
    [skel1, mot1] = readMocapSmartLCS(fullFile1, true, false);
    [skel2, mot2] = readMocapSmartLCS(fullFile2, true, false);
    
    switch lower(compFunction)
        case {'std', 'mean', 'max', 'deriv'}
            [diffSum, diffMean, diffStd, diffMax, diffMin, diffDerivMax] = compareMots(mot1, mot2, false, true, true);
    end
    
    switch lower(compFunction)
        case 'std'
            matrix(:,i) = diffStd(:,1);
        case 'mean'
            matrix(:,i) = diffMean(:,1);
        case 'max'
            matrix(:,i) = diffMax(:,1);
        case 'deriv'
            matrix(:,i) = diffDerivMax(:,1);
        case 'dft'
            matrix(:,i) = distDFT(mot1, mot2);
        otherwise 
            error('Unknown compFuncion!');
    end
    
%     stdDevs{i,1} = fullFile1;
%     stdDevs{i,2} = mean(diffStd(:,1));
end

if ~noGraphics
    h=figure;
    
    switch lower(compFunction)
        case 'std'
            compText = 'Average std. dev.';
        case 'mean'
            compText = 'Average abs. traj.-diff.';
        case 'deriv'
            compText = 'Average derivative of traj.-diff.';
        case 'max'
            compText = 'Maximum abs. traj.-diff.';
        case 'dft'
            compText = 'Summed DFT-difference';
    end
    
    
    set(h, 'Name', [compText ' per joint and motion file in class ']);
    
    imagesc(matrix, 'buttondownfcn',{@matrixComparisonCategory_showMatrixEntry, compFunction, DB_name1, DB_name2, category, filenames1, filenames2 })
    colormap('hot');
    axis off;
    joints = getAllJointNames;
    
    for i=1:length(files1)
        h = text(i, length(joints)+1, sprintf('%0.2i',i));
        set(h, 'FontSize', 6);
        set(h, 'HorizontalAlignment', 'Center');
    end
    for i=1:length(joints)
        h = text(0, i, joints{i});
        set(h, 'HorizontalAlignment', 'Right');
    end
    
end