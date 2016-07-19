function colorArmature = getColorByNum(num)
%GETCOLORBYNUM
% params:
%   num [int] -> [1,2,...)
% function call:
%   colorArmature = getColorByNum(num)
% return:
%   [r g b]

steps = .33;
r = .0;
g = .0;
b = .0;



fac = 1 + floor(num/6);
row = mod(num,6);
if((row == 0)||(row == 2)||(row == 3))
    r = abs(1 - (fac * steps));
    while(r > 1)
        r = r/10;
    end
end
if((row == 1)||(row == 2)||(row == 5))
    g = abs(1 - (fac * steps));
    while(g > 1)
        g = g/10;
    end
end
if((row == 3)||(row == 4)||(row == 5))
    b = abs(1 - (fac * steps));
    while(b > 1)
        b = b/10;
    end
end
colorArmature = [r g b];
end

% end