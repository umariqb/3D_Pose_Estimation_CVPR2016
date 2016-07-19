function [vertices,faces] = patchRawFile(rawFile)
%PATCHRAWFILE patches 3D-Object from given rawFile
%   rawFile:
%       [nx9] where each row contains 3 vertices defining a face
%   returns handles to patches with three and four vertices

verts = importdata(rawFile);
[n,m] = size(verts);
vertsPerFace = m/3;
vertices = reshape(verts',m/vertsPerFace,n*vertsPerFace)';
numFaces = size(vertices,1)/vertsPerFace;
faces = (1:3:numFaces*vertsPerFace);
faces = [faces;faces+1;faces+2;]';
[vertices,faces] = removeDupVerts(vertices,faces);
end