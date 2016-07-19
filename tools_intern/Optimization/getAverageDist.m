function res = getAverageDist(classify_cell)

res.distWarped      = nan(size(classify_cell,1),size(classify_cell,2));
res.distUnwarped    = nan(size(res.distWarped));
res.distFit         = nan(size(res.distWarped));

for i=1:size(classify_cell,1)
    for j=1:size(classify_cell,2)
        if ~isempty(classify_cell{i,j})
            res.distWarped(i,j) = classify_cell{i,j}.res.distance.dist_cm;
            res.distUnwarped(i,j) = classify_cell{i,j}.res.distanceUnwarped.dist_cm;
            
            origMot = classify_cell{i,j}.res.origMotCut;
            recMot = classify_cell{i,j}.res.recMotUnwarped;
            motFit = fitMotFrameWise(classify_cell{i,j}.res.skel,origMot,recMot);
            
            distFit = compareMotions_eg08(classify_cell{i,j}.res.origMotCut,motFit);
            res.distFit(i,j) = distFit.dist_cm;
        end
    end
end
res.distWarpedMean = mean(res.distWarped(~isnan(res.distWarped)));
res.distUnwarpedMean = mean(res.distUnwarped(~isnan(res.distUnwarped)));
res.distFitMean = mean(res.distFit(~isnan(res.distFit)));