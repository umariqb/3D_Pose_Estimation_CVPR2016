load ..\mocap\D180
load ..\mocap\index
files=D2filenames(D180);
features_spec = [index(1).features_spec;index(2).features_spec;index(3).features_spec];

% extract features from a set of files with the specified feature_specs
F=features_extract(files,features_spec,'F');

% load feature file F
features_load('F');

% decode RLE-encoded features for file number 300 from feature DB F
features = features_single_file(F,300);

% add and remove some features
F = features_modify_features(F2,[index(1).features_spec(1:5);index(2).features_spec(1:2)]);

% (add and) remove some files
F = features_modify_files(F2, D2filenames(D180([1:10 20:30])));