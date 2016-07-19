function plotRec(rec,frames)

if ~isfield(rec,'controlJoints')
    controlJoints = [4,28];
else
    controlJoints = rec.controlJoints;
end
    
mots =cell(1,size(frames,2)*2);
skels=cell(1,size(frames,2)*2);
colors=cell(1,size(frames,2)*2);

for m=1:2:size(frames,2)*2
    mots{m  }  =cutMotion(rec.origmot,        frames((m+1)/2),frames((m+1)/2));
    mots{m+1}  =cutMotion(rec.recmotDewarped ,frames((m+1)/2),frames((m+1)/2));
    skels{m}   =rec.skel;
    skels{m+1} =rec.skel;
    colors{m}  =[0 0.8 0];
    colors{m+1}=[0.8 0 0];
end

motionplayer('skel',skels,'mot',mots,'color',colors)
hold all;
for i=controlJoints
    
    switch i
        case 4
            mystyle='--';
        case 28
            mystyle='-.';
        otherwise
            mystyle='-';
    end
    
    plot3(rec.origmot.jointTrajectories{i}(1,:),...
          rec.origmot.jointTrajectories{i}(2,:),...
          rec.origmot.jointTrajectories{i}(3,:), ...
          'linestyle',mystyle,...
          'linewidth',2,'color',[0 0.8 0]);
    
    plot3(rec.recmotDewarped.jointTrajectories{i}(1,:),...
          rec.recmotDewarped.jointTrajectories{i}(2,:),...
          rec.recmotDewarped.jointTrajectories{i}(3,:),...
          'linestyle',mystyle,...
          'linewidth',2,'color','red');
end