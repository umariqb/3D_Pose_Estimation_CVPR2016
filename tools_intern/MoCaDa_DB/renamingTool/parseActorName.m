function actorName = parseActorName( inputString )

actorMap = { { {'bjorn', 'björn'}, 'bk' },
             { {'bastian'}       , 'bd' },
             { {'tido'}          , 'tr' },
             { {'daniel'}        , 'dg' },
             { {'meinard'}       , 'mm' } };

foundNameIdx = 0;
found = false;

for i = 1:length(actorMap)
    for j = 1:length(actorMap{i}{1})
        occurances = findstr(lower(inputString), lower(actorMap{i}{1}{j}));
        if not(isempty(occurances))
            actorName = actorMap{i}{2};
            found = true;
            break;
        end
    end
    if found
        break;
    end
end
