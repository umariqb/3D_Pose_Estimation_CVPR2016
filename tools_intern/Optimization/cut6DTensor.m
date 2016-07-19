function Tensor=cut6DTensor(Tensor,startFrame,endFrame)
% second mode is supposed to be frame mode
Tensor.data                 = Tensor.data(:,startFrame:endFrame,:,:,:,:);
Tensor.rootdata             = Tensor.rootdata(:,startFrame:endFrame,:,:,:);

Tensor.core                 = Tensor.core(:,startFrame:endFrame,:,:,:,:);
Tensor.rootcore             = Tensor.rootcore(:,startFrame:endFrame,:,:,:);

Tensor.factors{2}           = Tensor.factors{2}(startFrame:endFrame,:);
Tensor.rootfactors{2}       = Tensor.rootfactors{2}(startFrame:endFrame,:);

    findFrames              = cellfun(@(x) strcmpi(x,'frames'), Tensor.form);
Tensor.dimTechnicalModes(findFrames==1) = endFrame-startFrame+1;