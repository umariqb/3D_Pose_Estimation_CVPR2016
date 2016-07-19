function costs = estimateJointPos_costFunTrans( x, markerCoords1, markerCoords2, method )


switch method
    case 1
    case 2
    case 3
        A = buildRotMatrix( [ cos(x(1)); cos(x(2)); sin(x(1))], x(3));
        t = x(4:6)';
        diff = A * markerCoords1 + [t t t] - markerCoords2;
        costs = diff;
    case 4
        A = buildRotMatrix( [ x(1); x(2); x(3)], x(4));
        t = x(5:7)';
        diff = A * markerCoords1 + [t t t] - markerCoords2;
        costs = diff;
        costs = norm(diff(:,1)) + norm(diff(:,2)) + norm(diff(:,3));
    case 4
end
