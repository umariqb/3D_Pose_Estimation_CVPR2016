function H_writeImageTest(opts,inp2d,est2dRt,vFile,f,bodyType)
ifr = opts.sFrame + f - 1;
cn = 1;
switch opts.inputDB
    case 'Human36Mbm'
        if(isobject(vFile))
            rgbIm = read(vFile,ifr);
        else
            rgbIm = imread(vFile);
        end
    case 'HumanEva'
        if(isobject(vFile))
            rgbIm = read(vFile,ifr);
        else
            imn   = [vFile opts.subject '_' opts.action '_' num2str(opts.frameNo(1,f)) '_' num2str(opts.frameNo(2,f)) '.png'];
            rgbIm = imread(imn);
        end
end
clf
imshow(rgbIm,'Border','tight');
%%
xgt  = inp2d(1:2:end,1);
ygt  = inp2d(2:2:end,1);
xObj = est2dRt(1:2:end,1);                               % pose
yObj = est2dRt(2:2:end,1);
hold on
%%
pinkish  = [1, 0.6 0.78];     % used for blue arm
brownish = [1, 0.69, 0.39];   % other arm
redk     = 'r';               % blue side wali leg
jamni    = [.48,.06,.89];     % other side wali leg
gr       = 'g';               % used for head to root
jnt.njoints = length(opts.allJoints);
jnt.hd = getSingleJntIdx('Head',opts.allJoints,1);
jnt.nk = getSingleJntIdx('Neck',opts.allJoints,1);
jnt.ls = getSingleJntIdx('Left Shoulder',opts.allJoints,1);
jnt.rs = getSingleJntIdx('Right Shoulder',opts.allJoints,1);
jnt.rh = getSingleJntIdx('Right Hip',opts.allJoints,1);
jnt.lh = getSingleJntIdx('Left Hip',opts.allJoints,1);
jnt.rk = getSingleJntIdx('Right Knee',opts.allJoints,1);
jnt.lk = getSingleJntIdx('Left Knee',opts.allJoints,1);
jnt.ra = getSingleJntIdx('Right Ankle',opts.allJoints,1);
jnt.la = getSingleJntIdx('Left Ankle',opts.allJoints,1);
jnt.re = getSingleJntIdx('Right Elbow',opts.allJoints,1);
jnt.le = getSingleJntIdx('Left Elbow',opts.allJoints,1);
jnt.rw = getSingleJntIdx('Right Wrist',opts.allJoints,1);
jnt.lw = getSingleJntIdx('Left Wrist',opts.allJoints,1);

H_drawLineH36M(jnt,xgt,ygt);
plot(xgt,ygt,'o','MarkerSize',6,'MarkerEdgeColor','r','MarkerFaceColor','y','LineWidth',2);

plot(xObj(jnt.rh:jnt.njoints:end,:),yObj(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',jamni);
plot(xObj(jnt.rk:jnt.njoints:end,:),yObj(jnt.rk:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',jamni);
plot(xObj(jnt.ra:jnt.njoints:end,:),yObj(jnt.ra:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',jamni);
% left leg
plot(xObj(jnt.lh:jnt.njoints:end,:),yObj(jnt.lh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',redk);
plot(xObj(jnt.lk:jnt.njoints:end,:),yObj(jnt.lk:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',redk);
plot(xObj(jnt.la:jnt.njoints:end,:),yObj(jnt.la:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',redk);
% body
plot(xObj(jnt.hd:jnt.njoints:end,:),yObj(jnt.hd:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',gr);
plot(xObj(jnt.nk:jnt.njoints:end,:),yObj(jnt.nk:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',gr);

% left arm
plot(xObj(jnt.ls:jnt.njoints:end,:),yObj(jnt.ls:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',brownish);
plot(xObj(jnt.le:jnt.njoints:end,:),yObj(jnt.le:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',brownish);
plot(xObj(jnt.lw:jnt.njoints:end,:),yObj(jnt.lw:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',brownish);
% right arm
plot(xObj(jnt.rs:jnt.njoints:end,:),yObj(jnt.rs:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',pinkish);
plot(xObj(jnt.re:jnt.njoints:end,:),yObj(jnt.re:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',pinkish);
plot(xObj(jnt.rw:jnt.njoints:end,:),yObj(jnt.rw:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',pinkish);

%plot(xObj,yObj,'*','MarkerSize',4,'MarkerEdgeColor','g');
xm = get(gca,'xLim');
ym = get(gca,'yLim');
text (xm(1) + 20,ym(1) + 20,['# ' num2str(ifr)],'Color','y', 'FontWeight','bold', 'FontSize',15);
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