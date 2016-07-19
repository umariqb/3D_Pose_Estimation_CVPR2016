function [skels,mots] = positionHitsXY(hits,positionsXZ)

n = size(positionsXZ,2);

for k=1:n
    [skels(k),mot] = readMocapD(hits(k).file_id);
    r = rand(1);
    desiredFrontVec = [cos(r*2*pi);sin(r*2*pi)];
    [mot,skels(k)] = rotateMotY(skels(k),mot,desiredFrontVec);
    mot = cropMot(mot,[hits(k).frame_first_matched:hits(k).frame_last_matched]);
    e = mot.rootTranslation([1 3],end);
    s = mot.rootTranslation([1 3],1);
    v = e - s;
    mots(k) = moveMotToXZ(mot, positionsXZ(:,k) - v);
end

