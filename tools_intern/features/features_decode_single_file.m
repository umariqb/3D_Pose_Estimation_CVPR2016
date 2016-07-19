function features = features_decode_single_file(F,file_id)
% features = features_decode_single_file(F,file_id)
% Decode RLE-encoded features pertaining to a single file from a feature data structure
%
% F........ feature data structure
% file_id.. index into F.files, specifying the desired file

if (ischar(file_id))
    filename = file_id;
    file_id = strmatch(filename,F.files,'exact');
    if (isempty(file_id))
        error(['Unknown file: ' filename]);
    end
end

nframes = sum(F.features{file_id}{1});
nfeatures = length(F.features_spec);
features = zeros(nfeatures, nframes);
for k=1:nfeatures
    features(k,:) = runLengthDecode(F.features{file_id}{k});
end