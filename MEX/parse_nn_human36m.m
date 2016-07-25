function [] = parse_nn_human36m(inputAnnFile, inputKNNDir, outputDir)
part_comb_type = {'pose', 'upper', 'lower', 'right', 'left'};


for pIdx = 1:length(part_comb_type)
    if(exist('objts'))
        clear objts;
    end

    nn_filename = sprintf('%s/S11_Activity_All_C2_256_%s_objts.mat',...
        inputKNNDir, part_comb_type{pIdx});

    load(nn_filename);

    if(~exist('objts'))
        fprintf(1,'The file does not contain objts');
        continue;
    end


    pose_filename = sprintf('%s', inputAnnFile);
    fid = fopen(pose_filename);
    format = '%s%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%s%f';
    annotations = textscan(fid, format);

    if(~(length(annotations{1,1}) == size(objts.data,3)))
        keyboard;
    end


    for i = 1:size(objts.data,3)
        img_path = cell2mat(annotations{1,1}(i));
        [img_dir,img_name,img_ext] = fileparts(img_path);
        %nn_annot_filename = sprintf('%s/%s.txt', nn_dir_my,...
        nn_annot_filename = sprintf('%s/%s.txt', outputDir,...
            img_name);

        nn = objts.data(:,:,i);

        fid_nn = fopen(nn_annot_filename, 'a');
        for j=1:size(nn,2)
            fprintf(fid_nn, '%s 0 0 0 0 %d 14', img_path, pIdx);

            for k = 1:size(nn,1)
                fprintf(fid_nn, ' %d', uint16(nn(k,j)));
            end
            fprintf(fid_nn, '\n');
        end
        fclose(fid_nn);
    end
end

end
