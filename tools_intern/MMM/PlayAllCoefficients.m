function X=PlayAllCoefficients(Tensor)

hold1=1;
hold2=4;
hold3=9;
for i=1:sum(Tensor.dimNaturalModes)
    for j=1:sum(Tensor.dimNaturalModes)
        fprintf('\n\nPlaying with Coefs %i and %i \n',i,j);
        X(:,:,i,j) = playCoefficients(Tensor,i,j,hold1,hold2,hold3,false);
    end
end