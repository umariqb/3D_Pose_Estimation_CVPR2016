function mat=playCoefPCA(PCAmat,oFrame,skel,optProps, ...
                         index1,index2, ...
                         stepsize,transx,transy,beauty)

dim=11;

PCAmat.redCoefs=PCAmat.coefs(:,1:dim);

x=ones(dim,1)/dim;

vals=40;
range=vals*stepsize/2;

label_i=zeros(1,vals);
label_j=zeros(1,vals);

mat=zeros(vals,vals);

fprintf('i:         ');
for i=1:vals
    fprintf('\b\b\b\b\b\b\b\b');
    fprintf('%2i',i);
    fprintf(' j:   ');
    for j=1:vals

         x_i=-range+i*stepsize+transx;
         x_j=-range+j*stepsize+transy;
         x(index1)=x_i;
         x(index2)=x_j;
         label_i(i)=x_i;
         label_j(j)=x_j;


        tmp=objfunPCA_Acce(x,PCAmat,oFrame,skel,optProps);
        mat(i,j)=sum(tmp(:))^2;
        
        fprintf('\b\b');
        fprintf('%2i',j);
        
        
        
    end
end


fprintf('\n');

desc=['Coefs ' num2str(index1) ' and ' num2str(index2)];
surfMinimaPositions(real(mat),beauty,label_i,label_j,desc);
        