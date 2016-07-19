% modeNproduct
% computes the mode-n-product T x_n M
% i.e. T x_n M replaces every mode-n-vector v of T by the product Mv
% example:     result = modeNproduct(tensor,matrix,3);
%              with tensor (n1 x n2 x n3 x ... x n) and matrix (m x n3)
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function result = modeNproduct(Tensor,Matrix,n)

if size(Matrix)==1
    result=Tensor*Matrix;
else
    
    nd=ndims(Tensor);
    dim=size(Tensor);
    if nd<n
        nd=nd+1;
        dim=[dim 1];
    end
    order=n:n+nd-1;
    order=order-(order>nd)*nd;

    dim2=dim;
    dim2(n)=size(Matrix,1);

    Tensor = permute(Tensor,order);
    dim = dim(order);
    dim(1) = size(Matrix,1);
    result = Matrix*Tensor(:,:);
    result = reshape(result,dim);
    result = ipermute(result,order);
    result = reshape(result,dim2);
    
end