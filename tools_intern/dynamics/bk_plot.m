function bk_plot(PreRec)
dim=size(PreRec)
for i=1:dim(2)
%    figure;
    plot(PreRec(i).Recall,PreRec(i).Precision);
    hold all;
end