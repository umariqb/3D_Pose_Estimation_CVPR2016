function [eo,so,sn,en]=analyseWarpingPath(w)


so=w(  1,1);
eo=w(end,1);

sn=w(  1,2);
en=w(end,2);

maxStep=2;

% CHECK HORIZONTAL STEP START:

tmp = find(w(:,2)==1);
stL = size(tmp,1);

if (stL>maxStep)
    so = w(tmp(1),1);
end

% CHECK HORIZONTAL STEP END:

tmp = find(w(:,2)==max(w(:,2)));
stL = size(tmp,1);

if (stL>maxStep)
    eo = w(tmp(end),1);
end


% % % check vertical start
% % tmp         = find(w(:,1)==1);
% % stepLength  = size(tmp,1);
% % 
% % if(stepLength > maxStep)
% %     sn  = w(tmp(end),2);
% % end
% % 
% % % check vertical end
% % tmp         = find(w(:,1)==max(w(:,1)));
% % stepLength  = size(tmp,1);
% % 
% % if(stepLength > maxStep)
% %     en  = w(tmp(end),2);
% % end
% % 
% % % check horizontal start
% % tmp         = find(w(:,2)==1);
% % stepLength  = size(tmp,1);
% % 
% % if(stepLength > maxStep)
% %     so  = w(tmp(1),1);
% % end
% % 
% % % check horizontal end
% % tmp         = find(w(:,2)==max(w(:,1)));
% % stepLength  = size(tmp,1);
% % 
% % if(stepLength > maxStep)
% %     eo  = w(tmp(end),1);
end