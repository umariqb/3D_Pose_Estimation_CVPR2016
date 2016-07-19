function dist = computePCdists(data,frames4096,nnidx)

dist=zeros(size(nnidx));
fprintf('\t\t\t\t');
for i=1:numel(frames4096)
    fprintf('\b\b\b\b%4i',i);
    Q1          = reshape(data(:,frames4096(i)),3,31);
%     Q_window    = reshape(data(:,i-windowSize:i+windowSize),3,31*(2*windowSize+1));

%     PVA_Q = data(i-windowSize:i+windowSize,:);
%     [coeffsQ,scoreQ] = princomp2(PVA_Q);
    
    for j=1:size(nnidx,1)
        
        P1          = reshape(data(:,nnidx(j,i)),3,31);
%         P_window    = reshape(data(:,j-windowSize:j+windowSize),3,31*(2*windowSize+1));
        
        d1          = pointCloudDist_modified(P1,Q1,'pos');
%         d_window    = pointCloudDist_modified(P_window,Q_window,'pos');

%         PVA_P = data(j-windowSize:j+windowSize,:);
%         [coeffsP,scoreP] = princomp2(PVA_P);
        
        dist(j,i)        = sum(sqrt(sum(d1.^2)));
%         d_pc_window(rowcounter,colcounter)  = sum(sqrt(sum(d_window.^2)));
        
    end
end
fprintf('\n');