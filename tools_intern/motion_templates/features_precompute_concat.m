downsampling_fac = [1 2 3 4 8];

for k=1:length(downsampling_fac)
    sampling_rate_string = num2str(120/downsampling_fac(k));
%     [DB,filenames] = features_decode_subdir('HDM\Training','traditional_upper',true,{},downsampling_fac(k));
%     DB_concat = features_concatenate(DB,filenames,false,['all_training_DB_traditional_upper_' sampling_rate_string '.mat']);
%     [DB,filenames] = features_decode_subdir('HDM\Training','BD_upper',true,{},downsampling_fac(k));
%     DB_concat = features_concatenate(DB,filenames,false,['all_training_DB_BD_upper_' sampling_rate_string '.mat']);
     [DB,filenames] = features_decode_subdir('HDM\Training','BD_lower',true,{},downsampling_fac(k));
     DB_concat = features_concatenate(DB,filenames,false,['all_training_DB_BD_lower_' sampling_rate_string '.mat']);
end
