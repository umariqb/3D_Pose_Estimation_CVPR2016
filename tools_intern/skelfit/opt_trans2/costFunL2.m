function [costs, grad] = costFunL2( x, targetSkel, resizedSkel )

transSkel = translateSkelFrame( resizedSkel, x );
diff = [transSkel{:}] - [targetSkel{:}];
costs = sum(sqrt(dot(diff, diff)));

% temp = sqrt(dot(diff, diff));
% costs = sum(temp);
% grad(1) = sum(diff(1,:)+repmat(x(1), 1, length(diff))./temp);

% disp(['x = (' num2str(x(1)) ', ' num2str(x(2)) ', ' num2str(x(3)) '), costs = ' num2str(costs) ', costs2 = ' num2str(costs2)]);