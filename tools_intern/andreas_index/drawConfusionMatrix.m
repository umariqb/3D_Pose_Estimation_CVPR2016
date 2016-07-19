function     drawConfusionMatrix(confusion, class_info, queryClasses,  totalNumberOfHits, numRelevantHits)


figure
ih=imagesc(confusion);
colormap hot;
%colormap hot;
axis equal; axis tight; axis xy;
set(gca,'xtick',queryClasses);
set(gca,'ytick',queryClasses);
set(gca, 'yticklabel', class_info);
colorbar;
caxis([0,1]);
set(ih,'buttondownfcn',{@confusionButtonDown,...
                        class_info,...
                        confusion,...
                        totalNumberOfHits,...
                        numRelevantHits});
set(gcf, 'Position',    [ 8   133   977   849]);
