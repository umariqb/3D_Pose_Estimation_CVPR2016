function [db,options] = deleteMotFromDB(db,motname)

if ~iscell(motname)
    motname={motname};
end

motname       = unique(motname);

totalNrOfFrames = db.nrOfFrames;
totalNrOfMots   = numel(db.motNames);

options.frames2remove = zeros(1,totalNrOfFrames);
options.mots2remove   = zeros(1,numel(motname));

c1=1;
c2=1;

for i=1:length(motname)
    
    idx = find(cellfun(@(x) strcmp(x,motname{i}),db.motNames));

    if ~isempty(idx)
        
        options.mots2remove(c1) = idx;
        c1 = c1+1;
        
        beginDelete = db.motStartIDs(idx);
        if idx==numel(db.motStartIDs)
            endDelete = db.nrOfFrames;
        else
            endDelete   = db.motStartIDs(idx+1)-1;
        end
        
        newFrames2remove = beginDelete:endDelete;

        options.frames2remove(c2:c2+numel(newFrames2remove)-1) = newFrames2remove;
        
        c2 = c2+numel(newFrames2remove);
    else
        fprintf('%s not found.\n',motname{i});
    end
end

options.mots2remove   = options.mots2remove(1:c1-1);
options.frames2remove = options.frames2remove(1:c2-1);

tmp                 = 1:totalNrOfMots;
options.mots2keep   = setdiff(tmp,options.mots2remove);
tmp                 = 1:totalNrOfFrames;
options.frames2keep = setdiff(tmp,options.frames2remove);
        
db.nrOfFrames = numel(options.frames2keep);
motLengths    = diff([db.motStartIDs;db.nrOfFrames+1]);

motLengths    = motLengths(options.mots2keep);

db.motStartIDs = cumsum([1;motLengths(1:end-1)]);

fields = fieldnames(db);
for f=1:size(fields,1)
    
    field = fields{f};
    
    if ~strcmp(field,'motStartIDs')
    
        [a,b]=ismember([totalNrOfMots,totalNrOfFrames],size(db.(field)));

        if all(a)
            fprintf('Caution: Field %s is of ambiguous size. Please remove values manually.\n',field);
        elseif a(1)
            if b(1)==1
%                 db.(field)(options.mots2remove,:)=[];
                db.(field)=db.(field)(options.mots2keep,:);
            elseif b(1)==2
%                 db.(field)(:,options.mots2remove)=[];
                db.(field)=db.(field)(:,options.mots2keep);
            end
        elseif a(2)
            if b(2)==1
%                 db.(field)(options.frames2remove,:)=[];
                db.(field)=db.(field)(options.frames2keep,:);
            elseif b(2)==2
%                 db.(field)(:,options.frames2remove)=[];
                db.(field)=db.(field)(:,options.frames2keep);
            end
        elseif isstruct(db.(field))
            for f2=fieldnames(db.(field))'
                db.(field).(f2{1}) = db.(field).(f2{1})(:,options.frames2keep);
            end
        end
    end
        
end
fprintf('%i motions removed from db.\n',numel(options.mots2remove));