function Result = NN_getAttributes(Handle,Indices)
    if exist('Indices','var')
        Result = nn_wrapper('call',uint32(Handle),'getAttributes',uint32(Indices));
    else
        Result = nn_wrapper('call',uint32(Handle),'getAttributes');
    end
end