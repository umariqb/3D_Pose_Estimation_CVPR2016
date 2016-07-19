function word = fitword(word,len)

% FITWORD puts a word in the center of a prespecified space.
% -------------------------
% word = fitword(word, len)
% -------------------------
% Description: puts a word in the center of a prespecified space. If the
%              word is longer than the space, the tail of the word is
%              clipped. If the centering is not symmetric, less space is
%              given before the beginning of the word.
% Input:       {word} word.
%              {len} prespecified length.
% Output:      {word} the same word, fitting in the center of the space.

% © Liran Carmel
% Classification: String manipulations
% Last revision date: 08-Dec-2004

% clip the word if it is too long
wlen = length(word);
if wlen > len
    word = word(1:len);
    return;
end

% center
margins = len - wlen;
left_margin = floor(margins/2);
right_margin = margins - left_margin;
word = [blanks(left_margin) word blanks(right_margin)];