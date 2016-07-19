function [Js,xy]=tresSparse(J,varargin)

switch nargin
    case 1
        tresh=0.1;
    case 2
        tresh=varargin{1};
    otherwise
        fprintf('tresSparse: Wrong number of arguments!\n');
end

for i=1:size(J,1)
    for j=1:size(J,2)
        if(J(i,j)<tresh)
            J(i,j)=0;
        end
    end
end

for i=1:size(J,1)
    xy(i,1)=mod(i,5)+1;
    xy(i,2)=mod(i,7)+1;
end

Js=sparse(J);

            