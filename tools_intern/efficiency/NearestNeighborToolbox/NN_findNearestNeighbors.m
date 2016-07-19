function [Result,Dist] = NN_findNearestNeighbors( handle, Points, k )

if (isa(Points,'uint32') && size(Points,1) == 1 && size(Points,2) == 1)
    if nargout > 1
        [Result,Dist] = nn_wrapper('call',handle,'findNearestNeighbors',Points,k);
    else
        Result = nn_wrapper('call',handle,'findNearestNeighbors',Points,k);
    end
elseif isnumeric(Points)
    p_handle = NN_createSampleSet(Points);
    
    if nargout > 1
        [Result,Dist] = nn_wrapper('call',handle,'findNearestNeighbors',p_handle,k);
    else
        Result = nn_wrapper('call',handle,'findNearestNeighbors',p_handle,k);
    end
    
    NN_delete(p_handle);
end

end

