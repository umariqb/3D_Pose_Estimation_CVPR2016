% Thins function takes a cell array containing strings and conatenates the
% strings using a '_' sign as a delemiter between the strings.
% Example: Input: {'walkLeft', '4_30'} Output: 'walkLeft_4_30'

function string = concatStringsInCell(stringcell)


if (iscell(stringcell))
    string = '';
    for i=1:length(stringcell)
        if (i==1)
            string = stringcell{i};
        else
            string = [string '_' stringcell{i}];
        end
    end
else
    string = stringcell;
end