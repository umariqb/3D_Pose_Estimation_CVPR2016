function chapter = parseChapter( inputString )

% expects some sequence 'aaaa_bbbb' within the input string,
% otherwise throws error message.

seperatorIdx = findstr('_', inputString);
if isempty(seperatorIdx)
    seperatorIdx = findstr('-', inputString);
end

if isempty(seperatorIdx)
    error('Fehler in parseChapter: Konnte kein Kapitel finden!');
    return;
end

% determine start
startIdx = seperatorIdx - 1;
while ( startIdx > 0 ) && not(isempty(strfind('0123456789', inputString(startIdx)))) 
    startIdx = startIdx - 1;
end
startIdx = startIdx + 1;

% determine end
endIdx = seperatorIdx + 1;
while ( endIdx < length(inputString) ) && not(isempty(strfind('0123456789', inputString(endIdx))))
    endIdx = endIdx + 1;
end
endIdx = endIdx - 1;

if ( startIdx == seperatorIdx ) || ( endIdx == seperatorIdx )
    error('Fehler in parseChapter: Konnte kein Kapitel finden!');
    return;
end

chapter = inputString(startIdx:endIdx);
if ( seperatorIdx - startIdx < 2 )
    chapter = ['0' chapter];
end
if ( endIdx - seperatorIdx < 2 )
    chapter = [chapter(1:length(chapter)-1) '0' chapter(length(chapter))];
end
chapter = regexprep(chapter, '_', '-'); % replace '_' by '-'
