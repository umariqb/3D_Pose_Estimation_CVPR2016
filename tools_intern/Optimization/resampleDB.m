function db_new = resampleDB(db,newFrameRate)

db_new.frameRate = newFrameRate;

nrOfFrames = size(db.pos,2);

fields = fieldnames(db);

newFrames = 1:ceil(db.frameRate/db_new.frameRate):nrOfFrames;

for i=1:size(fields,1)
    fprintf('\nResampling %s... ',fields{i});
    if size(db.(fields{i}),2)==nrOfFrames
        db_new.(fields{i})      = db.(fields{i})(:,newFrames);
    elseif size(db.(fields{i}),1)==nrOfFrames
        db_new.(fields{i})      = db.(fields{i})(newFrames,:);
    end
    fprintf(' done.');
end
fprintf('\n');

db_new.motNames = db.motNames;

db_new.motStartIDs = ones(size(db.motStartIDs));

startIDs = [db.motStartIDs' nrOfFrames+1];

for i=2:numel(db.motStartIDs)
    db_new.motStartIDs(i)=sum(newFrames<startIDs(i))+1;
end
    
