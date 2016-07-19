%   LMFtest.m          Constrained Rosenbrock's valey
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The script solves a testing problem of the Rosenbrock's function by
%   minimization of of a sum of squares of residuals.
%   Requirements:                                                 FEX ID:
%       inp         function for keyboard input with default value  9033 
%       fig         function for coded figure window placement      9035
%       separator   for separating displayed results               11725
%       LMGnlsq     function for nonlinear least squares
%   Example:
%   Find a solution in the feasible domain with radius 0.5:
%       radius  = 1 => .5
%       x_0     = [-1.2; 1] => 
%       iprint  = 5 => 
%       dist    = lin => sqr
%       weight  = 1000 => 
%       ScaleD  = [] => 
%       Lambda  = 0 => 
%       Trace   = 1 => 
%   giving the result
%
% itr  nfJ   SUM(r^2)        x           dx           l           lc
% 35   50  2.9664e-001  4.5580e-001  2.2705e-007  6.4087e-002  1.0999e-007 
%                       2.0554e-001 -1.1629e-007 
%  Distance from the origin R = 0.500000,   R^2 =  0.250000

clear all
close all
separator([mfilename,'   ',date],'#',38)

r  = eval(inp('radius ','1'));
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   r  = 0      no constraint
%      > 0      radius of a circular feasible domain

x0 = eval(inp('x_0    ','[-1.2; 1]'));
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Vector of initial point coordinates

ipr= eval(inp('iprint ','5'));
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Control variable (step in iterations) for display intermediate results

if r>0                  %   nonzero feasible domain
    dst = inp('dist   ','lin');
%   ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   form of a penalty function (3rd equation), a distance from the border
%       'lin'   linear
%       'sqr'   quadratic

    switch dst
        case 'lin'
            d = @(x) sqrt(x'*x)-r;    %   A distance from the border
        case 'sqr'
            d = @(x) x(1)^2+x(2)^2-r^2;
        otherwise
            error(['in d = ' dst])
    end

    w  = eval(inp('weight ','1000'));
%   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Weight of the penalty

else                    %   without constraint
    d = @(x) 0;
    w = 0;
end
                %   RESIDUALS:
                
ros= @(x) [10*(x(2)-x(1)^2)
           1-x(1)
           (r>0)*(d(x)>0)*d(x)*w
          ];

sd = eval(inp('ScaleD ','[]')); %   D = diag(J'*J)
lm = eval(inp('Lambda ','0'));  %   initial lambda
xy = eval(inp('Trace  ','1'));  %   save intermediate results
disp(' ');

t  = clock;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[xf,ssq,cnt,loops,XY] = LMFnlsq ...
    (ros,x0,'Display',ipr, 'ScaleD',sd, 'Lambda',lm, 'Trace',xy ...
    );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = sqrt(xf'*xf);
fprintf('\n  Distance from the origin R =%9.6f,   R^2 = %9.6f\n', ...
    R, R^2);
separator(['t = ',num2str(etime(clock,t)),' sec'])

if xy
    fig(4); 
    plot(-2,-2,2,2)
    axis square
    hold on
    fi=(0:pi/18:2*pi)';
    plot(cos(fi)*r,sin(fi)*r,'r')   %   circle 
    grid
    fill(cos(fi)*r,sin(fi)*r,'y')   %   circle = fesible domain
    x=-2:.1:2; 
    y=-2:.1:2;
    [X,Y]=meshgrid(x,y);
    Z=100*(Y-X.^2).^2 - (1-X).^2;   %   Rosenbrock's function
    contour(X,Y,Z,30)
    plot(x0(1),x0(2),'ok')          %   starting point
    plot(xf(1),xf(2),'or')          %   terminal point
    plot([x0(1),XY(1,:)],[x0(2),XY(2,:)],'-k.') %   iteration path
    if r>0
        tit = 'Constrained';
    else
        tit = '';
    end
    title([tit,' Rosenbrock valley'],...
        'FontSize',14,'FontWeight','demi')
    xlabel('x_1','FontSize',12,'FontWeight','demi')
    ylabel('x_2','FontSize',12,'FontWeight','demi')
end
