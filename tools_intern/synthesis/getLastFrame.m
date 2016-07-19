function query=getLastFrame(mot);

dim=size(mot.orgFrames);

query=mot.orgFrames(dim(2));
