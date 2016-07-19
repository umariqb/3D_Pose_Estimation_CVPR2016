function motionPlayOnClick(src,eventdata,mots,varargin)

% t = get(gcf,'selectionType');
% switch t
% %%%%%%%%%% left click %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% case 'normal'
% set(gcf,'name',[info.skeletonSource ' ' info.skeletonID ' ' info.motionCategory ' ' info.motionDescription]);
    
    motionplayer('skel',{mots.skel mots.skel},'mot',{mots.mot1 mots.mot2});

% end