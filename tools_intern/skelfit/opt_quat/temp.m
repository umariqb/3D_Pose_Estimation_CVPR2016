function [ output_args ] = temp( input_args )

syms x y z;
syms qx qy qz qw;

qr2 =
 
[ (qx*x+qy*y+qz*z)*qx+(qw*x+qy*z-qz*y)*qw-(qw*y+qz*x-qx*z)*qz+(qw*z+qx*y-qy*x)*qy; ...
  (qx*x+qy*y+qz*z)*qy+(qw*y+qz*x-qx*z)*qw-(qw*z+qx*y-qy*x)*qx+(qw*x+qy*z-qz*y)*qz; ...
  (qx*x+qy*y+qz*z)*qz+(qw*z+qx*y-qy*x)*qw-(qw*x+qy*z-qz*y)*qy+(qw*y+qz*x-qx*z)*qx];

qr2 = qr2 / (qw^2+qx^2+qy^2+qz^2);