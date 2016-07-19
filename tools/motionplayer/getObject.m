function obj = getObject( varargin )
%GETOBJECT Summary of this function goes here
%   Detailed explanation goes here
if nargin > 1
    error('myApp:argChk', 'Wrong number of input arguments')
end
obj = emptyObject();
if (nargin == 1)
    objectIn = varargin{1};
    if ~isstruct(objectIn)
        error('myApp:argChk','argument has be of type struct');
    end
    if ~isfield(objectIn,'type')
        error('myApp:argChk','field <type> is required');
    end
    switch lower(objectIn.type)
        %static label
        case 'label'
            % test for required fields
            fieldsRequired = {'type','position'};
            f = isfield(objectIn,fieldsRequired);
            if (min(f) == 0)
                mf = missingFields(f,fieldsRequired);
                error(['missing fields for type label:',mf]);
            end
            % set fields from object input to object output
            obj = evalFields(obj, objectIn);
            obj.boundingBox = [obj.position;obj.position];
        case 'marker'
            % test for required fields
            fieldsRequired = {'type','position'};
            f = isfield(objectIn,fieldsRequired);
            if (min(f) == 0)
                mf = missingFields(f,fieldsRequired);
                error(['missing fields for type marker:',mf]);
            end
            % set fields from object input to object output
            obj = evalFields(obj, objectIn);
            % create vertices and faces + resize
            if(isempty(obj.vertices) || isempty(obj.faces))
                [obj.vertices,obj.faces] = markerSphere(obj.size);
            else
                obj.vertices = obj.vertices .* obj.size;
            end
            % compute vertex positions for animated marker
            if(size(obj.position,2) > 1 || size(obj.orientation,2) > 1)
                obj.animated = true;
                obj.nFrames = size(obj.position,2);
                obj.verticesStream = getObjVerticesStream(obj);
            end
            % compute boundingbox of object
            obj.boundingBox = getObjBoundingBox(obj);
        case 'object'
            % test for required fields
            fieldsRequired = {'type','position','vertices','faces'};
            f = isfield(objectIn,fieldsRequired);
            if (min(f) == 0)
                mf = missingFields(f,fieldsRequired);
                error(['missing fields for type marker:',mf]);
            end
            % set fields from object input to object output
            obj = evalFields(obj, objectIn);
            % resize object
            obj.vertices = obj.vertices .* obj.size;
            % compute vertex positions for animated marker
            if(size(obj.position,2) > 1 || size(obj.orientation,2) > 1)
                obj.animated = true;
                obj.nFrames = size(obj.position,2);
                obj.verticesStream = getObjVerticesStream(obj);
            else
                if(~isempty(obj.orientation))
                    obj.vertices = quatrot(obj.vertices',obj.orientation)';
                end
                if(~isempty(obj.position))
                    obj.vertices = obj.vertices + repmat(obj.position',...
                        size(obj.vertices,1),1);
                end
            end
            % compute boundingbox of object
            obj.boundingBox = getObjBoundingBox(obj);
        otherwise
            error(['no constructer found for type <',objectIn.type,'>']);
    end
else
    obj = emptyObject();
end

    function e = missingFields(f,fieldsRequired)
        e = ' ';
        for i = 1:size(f,2)
            if(~f(i))
                e = [e, '<', fieldsRequired{1,i},'>, '];
            end
        end
        e = e(1:end-2);
    end

    function [vertices,faces] = markerSphere(size)
        res = 1;
        [x,y,z]=meshgrid(...
            -1-res:res:1+res, ...
            -1-res:res:1+res,...
            -1-res:res:1+res);
        w=sqrt(x.^2+y.^2+z.^2);
        ps=isosurface(x,y,z,w,1);
        %scale object to size
        vertices = ps.vertices.*size;
        faces = ps.faces;
    end
end
