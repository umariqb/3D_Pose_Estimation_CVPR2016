motion_classes_in = {'walkLeft3Steps'};
motion_classes_out = {'walkRight3Steps'};
feature_sets = {'AK_upper','AK_lower','AK_mix'};
perms = {[2 1 4 3 6 5 8 7 9 10 12 11 14 13], [16 15 18 17 19 21 20 22 23 24 26 25]-14, [28 27 30 29 31 32 34 33 36 35 37 38 39]-26};

for i=1:length(motion_classes_in)
    for j=1:length(feature_sets)
        load(['S:\data_MoCap\MoCaDaDB\HDM\Training\_features\' feature_sets{j} '\F_' feature_sets{j} '_' motion_classes_in{i} '.mat']);
        
        for k=1:length(F.features)
            F.features{k} = motionTemplateFlip(F.features{k},perms{j});
        end
        F.features_spec = motionTemplateFlip(F.features_spec,perms{j});
        for k=1:length(F.files)
            F.files{k} = strrep(F.files{k},motion_classes_in{i},motion_classes_out{i});
        end
        
        save(['S:\data_MoCap\MoCaDaDB\HDM\Training\_features\' feature_sets{j} '\F_' feature_sets{j} '_' motion_classes_out{i} '.mat'], 'F');
    end
end
