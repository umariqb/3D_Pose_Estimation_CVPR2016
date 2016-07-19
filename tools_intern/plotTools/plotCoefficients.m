function plotCoefficients(coefs)

close all;

scrsz = get(0,'ScreenSize');

for Class=1:size(coefs,2)
    figure('Position',[1 scrsz(2) scrsz(3) (scrsz(4)-scrsz(2)*6)]);
    hold all;
    tmp=zeros(size(coefs{1,Class},2),5);
    for Motion=1:size(coefs{1,Class},2)
        subplot(1,size(coefs{1,Class},2),Motion);
        bar(coefs{1,Class}{1,Motion}{1,1}{1});
        ylabel(coefs{1,Class}{1,Motion}{1,2},'Interpreter','none');
        xlabel('Actors')
        set(gca,'XTickLabel',{'BD','BK','DG','MM','TR'});
    end
end