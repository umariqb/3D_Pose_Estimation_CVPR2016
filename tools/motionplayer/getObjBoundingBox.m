function [ bb ] = getObjBoundingBox( obj )
%GETOBJBOUNDINGBOX Summary of this function goes here
%   Detailed explanation goes here
bb = zeros(6,1);
if(obj.animated)
    bb(1) = min(obj.verticesStream(:,1));
    bb(2) = max(obj.verticesStream(:,1));
    bb(3) = min(obj.verticesStream(:,2));
    bb(4) = max(obj.verticesStream(:,2));
    bb(5) = min(obj.verticesStream(:,3));
    bb(6) = max(obj.verticesStream(:,3));
    if(obj.labeled)
        bb(1) = min(bb(1), obj.labelStream(:,1));
        bb(2) = max(bb(2), obj.labelStream(:,1));
        bb(3) = min(bb(3), obj.labelStream(:,2));
        bb(4) = max(bb(4), obj.labelStream(:,2));
        bb(5) = min(bb(5), obj.labelStream(:,3));
        bb(6) = max(bb(6), obj.labelStream(:,3));
    end
else
    bb(1) = min(obj.vertices(:,1));
    bb(2) = max(obj.vertices(:,1));
    bb(3) = min(obj.vertices(:,2));
    bb(4) = max(obj.vertices(:,2));
    bb(5) = min(obj.vertices(:,3));
    bb(6) = max(obj.vertices(:,3));
end

end

