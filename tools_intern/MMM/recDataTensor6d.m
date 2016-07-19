function Tensor=recDataTensor6d(Tensor)

    Tensor.recData=modeNproduct(Tensor.core,Tensor.factors{1},1);
    for i=2:6
        Tensor.recData=modeNproduct(Tensor.recData,Tensor.factors{i},i);
    end
end