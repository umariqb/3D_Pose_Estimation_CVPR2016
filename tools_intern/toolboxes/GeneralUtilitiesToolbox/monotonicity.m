function flag = monotonicity(x,y)

% MONOTONICITY checks the monotonicity status between two functions.
% -------------------------
% flag = monotonicity(x, y)
% -------------------------
% Description: checks the monotonicity status between two functions.
% Input:       {x} any vector.
%              {y} any vector equal in length to {x}.
% Output:      {flag} is +2 for strict increasing, +1 for non-decreasing, 0
%                   for non-monotonic, -1 for non-increasing, and -2 for
%                   strict decreasing. If {flag} is absent (no output
%                   requested), an appropriate text is displayed to screen.

% © Liran Carmel
% Classification: Information extraction
% Last revision date: 17-Feb-2006

% LUT
x_name = upper(inputname(1));
y_name = upper(inputname(2));
str1 = sprintf('%s and %s are strictly decreasing monotonic',x_name,y_name);
str2 = sprintf('%s is non-increasing function of %s',y_name,x_name);
str3 = sprintf('%s and %s are not monotonic',x_name,y_name);
str4 = sprintf('%s is non-decreasing function of %s',y_name,x_name);
str5 = sprintf('%s and %s are strictly increasing monotonic',x_name,y_name);
lut = {str1,str2,str3,str4,str5};

% verify the inputs are row vectors
x = forcerow(x);
y = forcerow(y);

% find monoticity
diff_x = diff(x);
diff_y = diff(y);
sign_y = sign(diff_y);
mono = sign(diff_x .* diff_y);
switch range(mono)
    case 0
        if sign_y(1) == 1
            flag = 2;
        elseif sign_y(1) == -1
            flag = -2;
        elseif sign_y(1) == 0
            flag = 1;
        end
    case 1
        if max(sign_y) == 1
            flag = 1;
        else
            flag = -1;
        end
    case 2
        flag = 0;
end

% display to screen
if nargout == 0
    disp(lut{flag+3});
end