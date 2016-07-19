function Result=NN_getValues(handle)
    Result = nn_wrapper('call',uint32(handle),'getValues');
end