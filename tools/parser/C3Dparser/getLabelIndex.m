function labelIndex = getLabelIndex(nameMap, listOfLabels)

for i = 1:size(listOfLabels,2)
    for j = 1:size(nameMap,1)
        if strcmp( listOfLabels(i), nameMap{j,1} )
            labelIndex(i) = nameMap{j,3};
        end
    end
end