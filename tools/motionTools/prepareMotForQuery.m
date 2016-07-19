function mot = prepareMotForQuery(skel,mot)

mot.rootTranslation(:,:)    = 0;
mot                         = fitRootOrientationsFrameWise(skel,mot);
% mot.boundingBox             = computeBoundingBox(mot);
% mot                         = addVelToMot(mot);
% mot                         = addAccToMot(mot);