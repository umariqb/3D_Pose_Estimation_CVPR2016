function [R,latx] = euler2matrixSymb(anglenames,rotorder)

for k=1:length(anglenames)
    angles(k) = sym(anglenames{k});
end

switch (lower(rotorder(1)))
    case 'x'
        R = [1 0 0; 0 cos(angles(1)) -sin(angles(1)); 0 sin(angles(1)) cos(angles(1))];
    case 'y'
        R = [cos(angles(1)) 0 sin(angles(1)); 0 1 0; -sin(angles(1)) 0 cos(angles(1))];
    case 'z'
        R = [cos(angles(1)) -sin(angles(1)) 0; sin(angles(1)) cos(angles(1)) 0; 0 0 1];
end

for k=2:length(rotorder)
    switch (lower(rotorder(k)))
        case 'x'
            R = R*[1 0 0; 0 cos(angles(k)) -sin(angles(k)); 0 sin(angles(k)) cos(angles(k))];
        case 'y'
            R = R*[cos(angles(k)) 0 sin(angles(k)); 0 1 0; -sin(angles(k)) 0 cos(angles(k))];
        case 'z'
            R = R*[cos(angles(k)) -sin(angles(k)) 0; sin(angles(k)) cos(angles(k)) 0; 0 0 1];
    end
end

latx = latex(R);
latx = strrep(latx,'\noalign{\medskip}','');
latx = strrep(latx,'\cos(1)','\co{1}');
latx = strrep(latx,'\cos(2)','\co{2}');
latx = strrep(latx,'\cos(3)','\co{3}');
latx = strrep(latx,'\sin(1)','\si{1}');
latx = strrep(latx,'\sin(2)','\si{2}');
latx = strrep(latx,'\sin(3)','\si{3}');
latx = strrep(latx,'\left [','\left(');
latx = strrep(latx,'\right [','\right)');