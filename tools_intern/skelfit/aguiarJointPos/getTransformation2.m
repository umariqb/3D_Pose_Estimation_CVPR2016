function [A, t, residuum] = getTransformation2( markerCoords1, markerCoords2 )


[T, A] = procrust( markerCoords2, markerCoords1 );

t = mean(markerCoords2 - A*markerCoords1, 2);
residuum = A*markerCoords1 + [t t t] - markerCoords2;
