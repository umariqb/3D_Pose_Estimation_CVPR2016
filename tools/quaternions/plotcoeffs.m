function plotcoeffs(Q)

N = size(Q,2);
plot([1:N],Q);
set(gca,'xlim',[1 N]);
set(gca,'ylim',1.1*[min(min(Q)) max(max(Q))]);

%axis([1,N,-1.1,1.1]);