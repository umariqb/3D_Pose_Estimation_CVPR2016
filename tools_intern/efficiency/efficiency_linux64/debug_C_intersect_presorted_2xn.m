n_reps = 10;
n_A_max = 10000;
n_B_max = 10000;
A_max = 10000;
B_max = 10000;

for s=0:100:100000
    s
    rand('state',s);
    for k=1:n_reps
        n_A = round(n_A_max*rand);
        n_B = round(n_B_max*rand);
        n_B_A = round(n_A*rand);
        %         A = round(A_max*rand(2,n_A));
        %         B = round(B_max*rand(2,n_B));
        A = rand(2,n_A);
        B = rand(2,n_B);
        B = [B A(:,1:n_B_A)];

        [X,I] = sort(A(2,:));
        A = A(:,I);
        [X,I] = sort(A(1,:));
        A = A(:,I);
        [X,I] = sort(B(2,:));
        B = B(:,I);
        [X,I] = sort(B(1,:));
        B = B(:,I);

        [C,IA,IB]=C_intersect_presorted_2xn(A,B);
        fprintf('n_B_A: %d, |C|: %d\n',n_B_A,size(C,2));
    end
end