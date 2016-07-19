function NN_setValues(handle,Values)

nn_wrapper('call',uint32(handle),'setValues',Values);

end