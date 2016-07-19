function [res] = compareAngles(mot1,mot2,varargin)

mot1=addBonesToMot(mot1);
mot2=addBonesToMot(mot2);

endEffectors    = [6,11,17,23,24,30,31];
regardedJoints  = setxor((1:31),endEffectors);
weights         = ones(1,length(regardedJoints));
switch nargin
    case 2
    case 3
        if ~isempty(intersect(varargin{1},endEffectors))
            fprintf('End effectors selected - ignoring end effectors...\n');
        end
        regardedJoints  = intersect(varargin{1},regardedJoints);
        weights         = ones(1,length(regardedJoints));
    case 4
        if length(varargin{1})~=length(varargin{2})
            error('Number of selected joints does not equal number of weights!');
        end
        if ~isempty(intersect(varargin{1},endEffectors))
            fprintf('End effectors selected - ignoring end effectors...\n');
        end
        [regardedJoints,pos1] = intersect(varargin{1},regardedJoints);
        weights = varargin{2}(pos1);
    otherwise
        error('Wrong number og argins!');
end

fprintf('Joints: \t');
fprintf('%.3i ',regardedJoints);
fprintf('\nWeights: \t');
fprintf('%.1f ',weights);
fprintf('\n');

counter=0;
for i=regardedJoints
    counter=counter+1;
    res(counter,:)=weights(counter)*computeAngleDiff(mot1,mot2,i);
end

function diff=computeAngleDiff(mot1,mot2,joint)
switch joint
    case 3 %lknee
        z = arrayfun(@(x)intersect(x.f1, x.f2),mot1.bones{:,5})
end

angle1=real(acosd(dot(-mot1.bones{2,4},mot1.bones{3,4})));
        angle2=real(acosd(dot(-mot2.bones{2,4},mot2.bones{3,4})));
        dot(cross(-mot1.bones{2,4},mot1.bones{3,4}),cross(-mot2.bones{2,4},mot2.bones{3,4}))
        diff=abs(angle1-angle2);