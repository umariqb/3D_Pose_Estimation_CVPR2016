function exportObjFiles(varargin)

    global SCENE;
    
    frame = SCENE.status.curFrame;
    
    switch SCENE.bones
        case 'sticks'
            faces = [1 2 3;1 3 4;1 5 2;2 5 6;2 6 3;3 6 7;3 7 4;4 7 8;1 4 8;1 8 5;5 7 6;5 8 7];
            faces = faces(:,[1 3 2]);
        case 'diamonds'
            faces = [1 2 3;1 3 4;1 4 5;1 5 2;2 3 6;3 4 6;4 5 6;5 2 6];
        otherwise
            error('Unknown bone type.');
    end
       
    fprintf('Exporting motion ');
    output = [];
    
    foldername = ['objexport-' datestr(clock,'yyyymmdd-HHMM')];
    
    if ~exist(foldername,'dir')
        mkdir(foldername);
    end
    
    txt_filename1 = fullfile(foldername,'objfile1.txt');
    txt_filename2 = fullfile(foldername,'objfile2.txt');
    
    fid1 = fopen(txt_filename1, 'w');
    fid2 = fopen(txt_filename2, 'w');
    
    for i=1:SCENE.nmots
        
        meshname = [num2str(frame,'%05i') '_' num2str(i,'%04i')];
        
        fprintf(repmat('\b',1,size(output,2)));
        output = sprintf('%i / %i (%s)',i,SCENE.nmots,meshname);
        fprintf('%s',output);
        
        nrOfBones           = SCENE.mots{i}.njoints-1;
        nrOfVertPerBone     = max(faces(:));
        nrOfFacesPerBone    = size(faces,1);

        f = repmat(faces,nrOfBones,1);
        tmp = repmat(0:nrOfVertPerBone:(nrOfBones-1)*nrOfVertPerBone,nrOfFacesPerBone,1);
        tmp = repmat(tmp(:),1,3);
        f = f + tmp;
    
        cf = min(frame,SCENE.mots{i}.nframes);
        
        v = cell2mat(cellfun(@(x) x(:,cf),SCENE.mots{i}.vertices(2:end),'UniformOutput',0));
        v = reshape(v,3,numel(v)/3)';
        
        faceColor = get(SCENE.mots{i}.joint_handles(2),'FaceColor');
        
        fprintf(fid1,...
            ['<Mesh name ="' meshname '" xsi:type="geo:TriangleMeshType">\r\n',...
            '<scale>0.5</scale>\r\n',...
            '<translation x="0.0" y="0.0" z="0.0" />\r\n',...
            '<renderingOptions>8</renderingOptions>\r\n',...
            '<path>meshes\\jochen\\',meshname,'.obj</path>\r\n',...
            '<material name="' meshname '" />\r\n',...
            '</Mesh>\r\n\r\n']);
    
        fprintf(fid2,...
            ['<BRDF name="' meshname '" xsi:type="mat:BRDF_LambertianType">\r\n',...
             '<diffuseReflectance>\r\n',...
             '<colorCIE_RGB r="' num2str(faceColor(1)) '" g="' num2str(faceColor(2)) '" b="' num2str(faceColor(3)) '" />\r\n',...
             '</diffuseReflectance>\r\n',...
             '<scale>1.0</scale>\r\n',...
             '</BRDF>\r\n\r\n']);
        
        vertface2obj(v,f,fullfile(foldername,[meshname '.obj']));
    end
    fprintf('\n');
    fprintf('Files exported to folder %s.\n',foldername);
    
    fclose(fid1);
    fclose(fid2);

end