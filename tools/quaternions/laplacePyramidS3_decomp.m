function [P,D] = laplacePyramidS3_decomp(varargin)
% [P,D] = laplacePyramidS3_decomp(Q,a,L,do_visualization,tol)
% Laplace pyramid decomposition on unit quaternion sequences.
% No downsampling is performed in contrast to common multiresolution analysis techniques.
%
% Input:    * Q is a 4xN array of quaternions.
%           * a is a euclidean filter (NOT yet processed by orientationFilter()) represented as a row vector.
%           * L is the desired number of filtering steps.
%           * do_visualization: boolean flag. show visualization of computation. default = false.
%           * If tol is specified, it denotes the allowable deviation from unit 
%             length for the input quaternions. Deviations less than tol will
%             lead to re-normalization, deviations larger than tol will lead
%             to re-normalization and a warning. If tol is not specified,
%             all deviations larger than the machine precision will lead to
%             an error. Default is tol = 10*eps.
%
% Output:   * P is a cell array with L entries, each entry representing a resolution 
%             level of the input signal Q. P{i} is the i-fold smoothed version of Q.
%           * D is a cell array with L entries, each entry representing a resolution 
%             level of the input signal Q. D{1..L} are the "details" at the corresponding
%             resolution levels.

switch (nargin)
    case 3
        Q = varargin{1};
        a = varargin{2};
        L = varargin{3};
        do_visualization = false;
        tol = 10*eps;
        error_on_deviations = true;
    case 4
        Q = varargin{1};
        a = varargin{2};
        L = varargin{3};
        do_visualization = varargin{4};
        tol = 10*eps;
        error_on_deviations = false;
    case 5
        Q = varargin{1};
        a = varargin{2};
        L = varargin{3};
        do_visualization = varargin{4};
        tol = varargin{5};
        error_on_deviations = false;
    otherwise
        error('Wrong number of arguments.');
end

if (size(Q,1)~=4)
    error('Input array: number of rows must be 4!');
end
N = size(Q,2);

P = cell(L);
D = cell(L);
for k = 1:L
    a2 = zeros(1,(length(a)-1)*2^(k-1)+1);
    a2((2^(k-1))*[0:length(a)-1]+1) = a;
    b = orientationFilter(a2);
    
    if k==1
        P{k} = filterS3(b,Q);
        %P{k} = filterSphericalAverageA1(a2,Q);
        D{k} = quatlog(quatmult(quatinv(P{k}),Q),tol);
    else
        P{k} = filterS3(b,P{k-1});
        %P{k} = filterSphericalAverageA1(a2,P{k-1});
        D{k} = quatlog(quatmult(quatinv(P{k}),P{k-1}),tol);
    end
end

if (do_visualization)
    figure;
    
    subplot(L+1,2,1);
    plot([1:N],Q);
    axis([1,N,-1.1,1.1]);
    title('Original signal Q');
    
    for k=1:L
        subplot(L+1,2,2*k+1);
        plot([1:N],P{k});
        set(gca,'xlim',[1,N]);
        title([num2str(k) '-fold filtered version of Q']);
        subplot(L+1,2,2*k+2);
        plot([1:N],D{k}); 
        %plot([1:N],D{k}./repmat(sqrt(sum(D{k}.^2)),3,1)); 
        set(gca,'xlim',[1,N]);
        title(['Details at level ' num2str(k)]);
    end
end
