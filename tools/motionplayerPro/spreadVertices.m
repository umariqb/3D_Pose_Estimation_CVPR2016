function spreadVertices(m)
    global SCENE;
    
    if isfield(SCENE.mots{m},'vertices_tmp') && ~isempty(SCENE.mots{m}.vertices_tmp)
        tmp                             = SCENE.mots{m}.vertices_tmp;
        SCENE.mots{m}.vertices_tmp      = SCENE.mots{m}.vertices;
        SCENE.mots{m}.vertices          = tmp;
        tmp                             = SCENE.mots{m}.boundingBox_tmp;
        SCENE.mots{m}.boundingBox_tmp   = SCENE.mots{m}.boundingBox;
        SCENE.mots{m}.boundingBox       = tmp;
        clear tmp;
    else
        SCENE.mots{m}.vertices_tmp  = SCENE.mots{m}.vertices;
        SCENE.mots{m}.boundingBox_tmp = SCENE.mots{m}.boundingBox;
        
        nrOfVertPerBone = size(SCENE.mots{m}.vertices{2},1)/3;
        
        rootPosOffsetXZ([1,3],1)    = SCENE.mots{m}.rootTranslation([1,3],1);
        rootPosOffsetXZ_rep         = repmat(rootPosOffsetXZ,nrOfVertPerBone,SCENE.mots{m}.nframes);
        switch SCENE.spreadFormation
            case 'square'
                nrOfCols    = ceil(sqrt(SCENE.nmots));
                nrOfRows    = ceil(SCENE.nmots/nrOfCols);
                currentRow  = ceil(m/nrOfCols);
                currentCol  = ceil(mod(m,nrOfCols));
                if currentCol==0, currentCol = nrOfCols; end
                
                % following are the offsets in relation to the origin
                z = (nrOfRows-1)*SCENE.spreadOffset(1)/2 - (currentRow-1)*SCENE.spreadOffset;
                y = 0;
                x = -(nrOfCols-1)*SCENE.spreadOffset(1)/2 + (currentCol-1)*SCENE.spreadOffset;
            case 'line'
                % following are the offsets in relation to the origin
                z = 0;
                y = 0;
                x = (m-1)*SCENE.spreadOffset-(SCENE.nmots-1)*SCENE.spreadOffset/2;
            otherwise
                error('Unknown formation specified in SCENE.spreadFormation! See defaultSCENE().');
        end
        
        
        
        offsetBetwMots_rep          = repmat([x;y;z],nrOfVertPerBone,SCENE.mots{m}.nframes);
        
        SCENE.mots{m}.vertices(2:end) = cellfun(@(x)...
            reshape(...
                C_quatrot(...
                    reshape(...
                        x-rootPosOffsetXZ_rep,...
                    3,nrOfVertPerBone*SCENE.mots{m}.nframes),...
                SCENE.mots{m}.rotOffset),...
            nrOfVertPerBone*3,SCENE.mots{m}.nframes)...
        +offsetBetwMots_rep,...
        SCENE.mots{m}.vertices(2:end),'UniformOutput',0);
    
        SCENE.mots{m}.boundingBox   = computeBoundingBoxPRO(SCENE.mots{m});
    end
    
end