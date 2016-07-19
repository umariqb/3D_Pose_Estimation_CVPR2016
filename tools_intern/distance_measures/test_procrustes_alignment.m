% s = whos('h1');
% if (~isempty(s) && ishandle(h1))
%     close(h1);
% end
% s = whos('h2');
% if (~isempty(s) && ishandle(h2))
%     close(h2);
% end

n = 1;
m = 1;

mot1sf = cropMot(mot1,n);
mot2sf = cropMot(mot2,m);
mot2sf_aligned = rotateMotY_absolute(skel2,mot2sf,theta(n,m));

h1 = figure;
animate([skel1,skel2],[mot1sf,mot2sf_aligned]);
set(gcf,'name','only rotated, not translated');

mot2sf_aligned = moveMotByXZ(mot2sf_aligned,[x0(n,m) z0(n,m)]');

h2 = figure;
animate([skel1,skel2],[mot1sf,mot2sf_aligned]);
set(gcf,'name','fully aligned');
