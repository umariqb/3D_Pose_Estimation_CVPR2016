function inputString = incrementLeftmostDigit( inputString )

I = find(inputString>=48 & inputString<=57);
if ~isempty(I)
    inputString(I(1)) = inputString(I(1))+1;
end