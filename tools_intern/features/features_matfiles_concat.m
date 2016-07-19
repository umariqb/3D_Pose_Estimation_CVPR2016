function F_out = features_matfiles_concat(F_filenames,varargin)

F_out = [];
files = {};
if (nargin>1)
    files = varargin{1};
end

for k=1:length(F_filenames)
    fid = fopen(F_filenames{k});
    if (fid ~= -1)
        fclose(fid);
        load(F_filenames{k});
    else
        continue;
    end
    if (~isempty(files))
        if (files{k}(1)>0)
            F = features_modify_files(F, files{k}, '', '', true, true);
        else
            continue;
        end
    end
    
    if (k==1)
        F_out = F;
    else
        F_out.features = [F_out.features; F.features];
        F_out.files = [F_out.files; F.files];
        F_out.files_sampling_rate = [F_out.files_sampling_rate; F.files_sampling_rate];
    end
end

if isempty(F_out)
    error('Could not find feature directory!');
end