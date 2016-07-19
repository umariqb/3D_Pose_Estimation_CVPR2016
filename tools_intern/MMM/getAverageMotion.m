function [skel,mot]=getAverageMotion(tensor,skel)

% Get average motion from tensor

    avCoefs=cell(1,tensor.numNaturalModes);
    for i=1:tensor.numNaturalModes
        avCoefs{i} = ones(1,tensor.dimNaturalModes(i)) / ...
                     tensor.dimNaturalModes(i);
    end

%     skel=readASF(tensor.)
    
    [skel, mot] = constructMotion(tensor, avCoefs,skel);
    
end