
function H_writeImageTest2(opts,inp2d,est2dRt,vFile,f,bodyType)
ifr = opts.sFrame + f - 1;
if(isobject(vFile))
    rgbIm = read(vFile,ifr);
else
    imn   = [vFile opts.subject '_' opts.action '_' num2str(opts.frameNo(1,f)) '_' num2str(opts.frameNo(2,f)) '.png'];
    rgbIm = imread(imn);
end
clf
imshow(rgbIm,'Border','tight');
%%
xgt  = inp2d(1:2:end,f);
ygt  = inp2d(2:2:end,f);
xObj = est2dRt(1:2:end,f);                               % pose
yObj = est2dRt(2:2:end,f);
hold on
%%
H_drawLine(xgt,ygt);
plot(xgt,ygt,'o','MarkerSize',6,'MarkerEdgeColor','r','MarkerFaceColor','y','LineWidth',2);
%plot(xgt(13),ygt(13),'o','MarkerSize',6,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',2);
plot(xObj,yObj,'*','MarkerSize',4,'MarkerEdgeColor','g');
xm = get(gca,'xLim');
ym = get(gca,'yLim');
text (xm(1) + 20,ym(1) + 20,['Frame # ' num2str(ifr)],'Color','y', 'FontWeight','bold', 'FontSize',15);
%text (xm(1) + 20,ym(1) + 40,['Count # ' num2str(f)],'Color','y', 'FontWeight','bold', 'FontSize',15);
pause(0.4);
%%
imPath = [opts.saveResPath 'optimTestIm\'];
if ~exist(imPath,'dir')
    mkdir(imPath);
end
imName   = [imPath  opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' bodyType '_'  num2str(ifr) '_' num2str(f) '.png'];
frm      = getframe(gcf);
im       = frame2im(frm);
imwrite(im, imName);

end