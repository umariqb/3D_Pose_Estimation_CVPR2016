function [J]=calcJumpMap(D,varargin)

switch nargin
    case 1
        phi=0.1;
    case 2
        phi=varargin{1};
    otherwise
        fprintf('calcJumpMap: Wrong number of arguments.\n')
end

J=exp(-D/phi);
% for i=1:size(J,2)
%     J(:,i)=J(:,i)/(sum(J(:,i)));
% end