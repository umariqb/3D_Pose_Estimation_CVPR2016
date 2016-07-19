function rootTranslation = extractRootTranslation(skel,data)

itx = strmatch('tx',skel.nodes(1).DOF);
ity = strmatch('ty',skel.nodes(1).DOF);
itz = strmatch('tz',skel.nodes(1).DOF);

rootTranslation = data([itx,ity,itz],:);