function verticesStream = getObjVerticesStream(obj)
    nVerts = size(obj.vertices,1);
    pos = obj.position;
    if(size(pos,2) == obj.nFrames)
        pos = repmat(pos,nVerts,1);
    elseif(size(pos,2) == 1)
        pos = repmat(obj.position,nVerts,obj.nFrames);
    else
        error('position is not specified correctly');
    end
    pos = reshape(pos,3,[])';
    if(~isempty(obj.orientation))
        ori = obj.orientation;
        v = obj.vertices;
        if(size(ori, 2)>1)
            ori = repmat(ori,nVerts,1);
            ori = reshape(ori,4,[]);
            v = repmat(v,obj.nFrames,1);
            verticesStream = quatrot(v',ori)';
        else
            verticesStream = quatrot(v',ori)';
            verticesStream = repmat(verticesStream,obj.nFrames,1);
        end
    else
        verticesStream = repmat(obj.vertices,obj.nFrames,1);
    end
    verticesStream = verticesStream + pos;
end