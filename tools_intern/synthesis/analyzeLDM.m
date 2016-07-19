function [lists]=analyzeLDM(LDM)

% [c,r]=size(LDM);
% 
% for col=1:c
%     count=1;
%     for row=1:r
%         if(LDM(col,row)==1)
%             lists (col,count)=row;
%             count=count+1;
%         end
%     end
% end

[r lists] = sort(LDM,1);
