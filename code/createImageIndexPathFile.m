function [] = createImageIndexPathFile(imageLocation, outputFile)
    
    dirData = dir(imageLocation);           
    dirIndex = [dirData.isdir];             
    files = {dirData(~dirIndex).name}';  
    if ~isempty(files)
    files = cellfun(@(x) fullfile(imageLocation,x),...  
                       files,'UniformOutput',false);
    end
  
    refinedFiles = {};
    extensions = {'.jpg' '.jpeg' '.png' '.tiff' '.bmp'};
    for i=1:size(files,1)
        [~, ~, ext] = fileparts(files{i});
        test = strmatch(ext, extensions);
        if(~isempty(test))
            refinedFiles{i,1} = files{i};
        end
       
    end
    
    fileID = fopen(outputFile,'w');
    
    for i=1:size(refinedFiles,1)
        
       fprintf(fileID, '%s 0 0 0 0 0 14', refinedFiles{i}); 
       for j=1:14
         fprintf(fileID, ' 0 0');   
       end
         fprintf(fileID, '\n');
    end
    
    fclose(fileID);

end