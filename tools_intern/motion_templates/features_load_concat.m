function DB_save = features_load_concat(filename)

load(filename);
DB_save.features = double(DB_save.features);
DB_save.features(DB_save.features==255) = NaN;