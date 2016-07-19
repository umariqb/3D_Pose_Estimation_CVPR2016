function H_drawLineH36M(jnt,xgt,ygt,varargin)

cArmR =  [0 0.6 0.8];
cArmL =  'b';
cLegL =  [0.6 0 0.6];
cLegR =  [1 0.4 1];
cHead =  [1 0.6 0.3];
cBody  = 'c';

if(nargin > 5)
    
end
if(nargin > 4)
    cArmR =  varargin{2};
    cArmL =  varargin{2};
    cLegR =  varargin{2};
    cLegL =  varargin{2};
    cHead =  varargin{2};
    cBody  = varargin{2};
end
if(nargin > 3)
    zgt = varargin{1};
end
widLeg = 3; % 3

if(nargin == 3)
    %% 2D
    switch jnt.njoints
        case 18
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cArmR =  'b';
            cArmL =  'b';
            cLegL =  'b';
            cLegR =  'b';
            cHead =  'b';
            cBody  = 'b';
            %==================================================================% Head
            line('XData',xgt([jnt.hd jnt.nk])  ,'YData',ygt([jnt.hd jnt.nk])  ,'Color',cHead ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.nk jnt.ct])  ,'YData',ygt([jnt.nk jnt.ct])  ,'Color',cHead ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.ct jnt.rt])  ,'YData',ygt([jnt.ct jnt.rt])  ,'Color',cHead ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.nk jnt.ls])  ,'YData',ygt([jnt.nk jnt.ls])  ,'Color',cHead ,'LineWidth',widLeg);
            line('XData',xgt([jnt.nk jnt.rs])  ,'YData',ygt([jnt.nk jnt.rs])  ,'Color',cHead ,'LineWidth',widLeg);
            %==================================================================% Body
            line('XData',xgt([jnt.rt jnt.lh])  ,'YData',ygt([jnt.rt jnt.lh])  ,'Color',cBody ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.rt jnt.rh])  ,'YData',ygt([jnt.rt jnt.rh])  ,'Color',cBody ,'LineWidth',widLeg);  
            %line('XData',xgt([jnt.lh jnt.rh])  ,'YData',ygt([jnt.lh jnt.rh])  ,'Color',cBody ,'LineWidth',widLeg);%
            %==================================================================% Left Arm
            line('XData',xgt([jnt.ls jnt.le])   ,'YData',ygt([jnt.ls jnt.le])  ,'Color',cArmL ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.le jnt.lw])   ,'YData',ygt([jnt.le jnt.lw])  ,'Color',cArmL ,'LineWidth',widLeg);            
            %==================================================================% Right Arm
            line('XData',xgt([jnt.rs jnt.re])   ,'YData',ygt([jnt.rs jnt.re])  ,'Color',cArmR ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.re jnt.rw])   ,'YData',ygt([jnt.re jnt.rw])  ,'Color',cArmR ,'LineWidth',widLeg);     %
            %==================================================================% Left Leg
            line('XData',xgt([jnt.lh jnt.lk])   ,'YData',ygt([jnt.lh jnt.lk])  ,'Color',cLegL ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.lk jnt.la])   ,'YData',ygt([jnt.lk jnt.la])  ,'Color',cLegL ,'LineWidth',widLeg);
            line('XData',xgt([jnt.la jnt.lf])   ,'YData',ygt([jnt.la jnt.lf])  ,'Color',cLegL ,'LineWidth',widLeg);
            %==================================================================% Right Leg
            line('XData',xgt([jnt.rh jnt.rk])   ,'YData',ygt([jnt.rh jnt.rk])  ,'Color',cLegR ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.rk jnt.ra])   ,'YData',ygt([jnt.rk jnt.ra])  , 'Color',cLegR ,'LineWidth',widLeg);
            line('XData',xgt([jnt.ra jnt.rf])   ,'YData',ygt([jnt.ra jnt.rf])  , 'Color',cLegR ,'LineWidth',widLeg);
        case 17
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %==================================================================% Head
            line('XData',xgt([9 10])  ,'YData',ygt([9 10])  , 'Color',cHead ,'LineWidth',widLeg);    %
            line('XData',xgt([10 11])  ,'YData',ygt([10 11])   ,'Color',cHead ,'LineWidth',widLeg);
            %==================================================================% Body
            line('XData',xgt([1 8])  ,'YData',ygt([1 8])  , 'Color',cBody ,'LineWidth',widLeg);    %
            line('XData',xgt([8 9])  ,'YData',ygt([8 9])  , 'Color',cBody ,'LineWidth',widLeg);    %
            %==================================================================% Right Arm
            line('XData',xgt([9 15])   ,'YData',ygt([9 15])     ,'Color',cArmR ,'LineWidth',widLeg);    %
            line('XData',xgt([15 16])   ,'YData',ygt([15 16])      ,'Color',cArmR ,'LineWidth',widLeg);    %
            line('XData',xgt([16 17])  ,'YData',ygt([16 17])    ,'Color',cArmR ,'LineWidth',widLeg);    %
            %==================================================================% Left Arm
            line('XData',xgt([9 12])   ,'YData',ygt([9 12])     ,'Color',cArmL ,'LineWidth',widLeg);    %
            line('XData',xgt([12 13])   ,'YData',ygt([12 13])     ,'Color',cArmL ,'LineWidth',widLeg);    %
            line('XData',xgt([13 14])   ,'YData',ygt([13 14])     ,'Color',cArmL ,'LineWidth',widLeg);    %
            %==================================================================% Right Leg
            line('XData',xgt([1 2])  ,'YData',ygt([1 2])    ,'Color',cLegR ,'LineWidth',widLeg);
            line('XData',xgt([2 3])  ,'YData',ygt([2 3])    ,'Color',cLegR ,'LineWidth',widLeg);
            line('XData',xgt([3 4]) ,'YData',ygt([3 4])  ,'Color',cLegR ,'LineWidth',widLeg);
            %==================================================================% Left Leg
            line('XData',xgt([1 5])  ,'YData',ygt([1 5])  ,'Color',cLegL ,'LineWidth',widLeg);
            line('XData',xgt([5 6])  ,'YData',ygt([5 6])   ,'Color',cLegL ,'LineWidth',widLeg);
            line('XData',xgt([6 7]) ,'YData',ygt([6 7])  ,'Color',cLegL ,'LineWidth',widLeg);
        case 14
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %==================================================================% Head
            line('XData',xgt([jnt.hd jnt.nk])  ,'YData',ygt([jnt.hd jnt.nk])  ,'Color',cHead ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.nk jnt.ls])  ,'YData',ygt([jnt.nk jnt.ls])  ,'Color',cHead ,'LineWidth',widLeg);
            line('XData',xgt([jnt.nk jnt.rs])  ,'YData',ygt([jnt.nk jnt.rs])  ,'Color',cHead ,'LineWidth',widLeg);
            %==================================================================% Body
            line('XData',xgt([jnt.ls jnt.lh])  ,'YData',ygt([jnt.ls jnt.lh])  ,'Color',cBody ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.rs jnt.rh])  ,'YData',ygt([jnt.rs jnt.rh])  ,'Color',cBody ,'LineWidth',widLeg);  
            line('XData',xgt([jnt.lh jnt.rh])  ,'YData',ygt([jnt.lh jnt.rh])  ,'Color',cBody ,'LineWidth',widLeg);%
            %==================================================================% Left Arm
            line('XData',xgt([jnt.ls jnt.le])   ,'YData',ygt([jnt.ls jnt.le])  ,'Color',cArmL ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.le jnt.lw])   ,'YData',ygt([jnt.le jnt.lw])  ,'Color',cArmL ,'LineWidth',widLeg);            
            %==================================================================% Right Arm
            line('XData',xgt([jnt.rs jnt.re])   ,'YData',ygt([jnt.rs jnt.re])  ,'Color',cArmR ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.re jnt.rw])   ,'YData',ygt([jnt.re jnt.rw])  ,'Color',cArmR ,'LineWidth',widLeg);     %
            %==================================================================% Left Leg
            line('XData',xgt([jnt.lh jnt.lk])   ,'YData',ygt([jnt.lh jnt.lk])  ,'Color',cLegL ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.lk jnt.la])   ,'YData',ygt([jnt.lk jnt.la])  ,'Color',cLegL ,'LineWidth',widLeg);
            %==================================================================% Right Leg
            line('XData',xgt([jnt.rh jnt.rk])   ,'YData',ygt([jnt.rh jnt.rk])  ,'Color',cLegR ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.rk jnt.ra])   ,'YData',ygt([jnt.rk jnt.ra])  , 'Color',cLegR ,'LineWidth',widLeg);
     
        case 32
        otherwise
            disp('H-error: H_drawLineH36M:- wrong number of joints...');
    end
else
    %% 3D
    switch jnt.njoints
        case 17
            %==================================================================% Head
            line('XData',xgt([9 10])  ,'YData',ygt([9 10])  , 'ZData',zgt([9 10])  ,'Color',cHead ,'LineWidth',widLeg);    %
            line('XData',xgt([10 11])  ,'YData',ygt([10 11])  , 'ZData',zgt([10 11])  ,'Color',cHead ,'LineWidth',widLeg);
            %==================================================================% Body
            line('XData',xgt([1 8])  ,'YData',ygt([1 8])  , 'ZData',zgt([1 8])  ,'Color',cBody ,'LineWidth',widLeg);    %
            line('XData',xgt([8 9])  ,'YData',ygt([8 9])  , 'ZData',zgt([8 9])  ,'Color',cBody ,'LineWidth',widLeg);    %
            %==================================================================% Right Arm
            line('XData',xgt([9 15])   ,'YData',ygt([9 15])   , 'ZData',zgt([9 15])   ,'Color',cArmR ,'LineWidth',widLeg);    %
            line('XData',xgt([15 16])   ,'YData',ygt([15 16])   , 'ZData',zgt([15 16])   ,'Color',cArmR ,'LineWidth',widLeg);    %
            line('XData',xgt([16 17])  ,'YData',ygt([16 17])  , 'ZData',zgt([16 17])  ,'Color',cArmR ,'LineWidth',widLeg);    %
            %==================================================================% Left Arm
            line('XData',xgt([9 12])   ,'YData',ygt([9 12])   , 'ZData',zgt([9 12])   ,'Color',cArmL ,'LineWidth',widLeg);    %
            line('XData',xgt([12 13])   ,'YData',ygt([12 13])   , 'ZData',zgt([12 13])   ,'Color',cArmL ,'LineWidth',widLeg);    %
            line('XData',xgt([13 14])   ,'YData',ygt([13 14])   , 'ZData',zgt([13 14])   ,'Color',cArmL ,'LineWidth',widLeg);    %
            %==================================================================% Right Leg
            line('XData',xgt([1 2])  ,'YData',ygt([1 2])  , 'ZData',zgt([1 2])  ,'Color',cLegR ,'LineWidth',widLeg);
            line('XData',xgt([2 3])  ,'YData',ygt([2 3])  , 'ZData',zgt([2 3])  ,'Color',cLegR ,'LineWidth',widLeg);
            line('XData',xgt([3 4]) ,'YData',ygt([3 4]) , 'ZData',zgt([3 4]) ,'Color',cLegR ,'LineWidth',widLeg);
            %==================================================================% Left Leg
            line('XData',xgt([1 5])  ,'YData',ygt([1 5])  , 'ZData',zgt([1 5])  ,'Color',cLegL ,'LineWidth',widLeg);
            line('XData',xgt([5 6])  ,'YData',ygt([5 6])  , 'ZData',zgt([5 6])  ,'Color',cLegL ,'LineWidth',widLeg);
            line('XData',xgt([6 7]) ,'YData',ygt([6 7]) , 'ZData',zgt([6 7]) ,'Color',cLegL ,'LineWidth',widLeg);
        case 14            
            %==================================================================% Head
            line('XData',xgt([jnt.hd jnt.nk])  ,'YData',ygt([jnt.hd jnt.nk])  , 'ZData',zgt([jnt.hd jnt.nk])  ,'Color',cHead ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.nk jnt.ls])  ,'YData',ygt([jnt.nk jnt.ls])  , 'ZData',zgt([jnt.nk jnt.ls])  ,'Color',cHead ,'LineWidth',widLeg);
            line('XData',xgt([jnt.nk jnt.rs])  ,'YData',ygt([jnt.nk jnt.rs])  , 'ZData',zgt([jnt.nk jnt.rs])  ,'Color',cHead ,'LineWidth',widLeg);
            %==================================================================% Body
            line('XData',xgt([jnt.ls jnt.lh])  ,'YData',ygt([jnt.ls jnt.lh])  , 'ZData',zgt([jnt.ls jnt.lh])  ,'Color',cBody ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.rs jnt.rh])  ,'YData',ygt([jnt.rs jnt.rh])  , 'ZData',zgt([jnt.rs jnt.rh])  ,'Color',cBody ,'LineWidth',widLeg);  
            line('XData',xgt([jnt.lh jnt.rh])  ,'YData',ygt([jnt.lh jnt.rh])  , 'ZData',zgt([jnt.lh jnt.rh])  ,'Color',cBody ,'LineWidth',widLeg);%
            %==================================================================% Left Arm
            line('XData',xgt([jnt.ls jnt.le])   ,'YData',ygt([jnt.ls jnt.le])   , 'ZData',zgt([jnt.ls jnt.le])   ,'Color',cArmL ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.le jnt.lw])   ,'YData',ygt([jnt.le jnt.lw])   , 'ZData',zgt([jnt.le jnt.lw])   ,'Color',cArmL ,'LineWidth',widLeg);            
            %==================================================================% Right Arm
            line('XData',xgt([jnt.rs jnt.re])   ,'YData',ygt([jnt.rs jnt.re])   , 'ZData',zgt([jnt.rs jnt.re])   ,'Color',cArmR ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.re jnt.rw])   ,'YData',ygt([jnt.re jnt.rw])   , 'ZData',zgt([jnt.re jnt.rw])   ,'Color',cArmR ,'LineWidth',widLeg);     %
            %==================================================================% Left Leg
            line('XData',xgt([jnt.lh jnt.lk])   ,'YData',ygt([jnt.lh jnt.lk])   , 'ZData',zgt([jnt.lh jnt.lk])   ,'Color',cLegL ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.lk jnt.la])   ,'YData',ygt([jnt.lk jnt.la])   , 'ZData',zgt([jnt.lk jnt.la])   ,'Color',cLegL ,'LineWidth',widLeg);
            %==================================================================% Right Leg
            line('XData',xgt([jnt.rh jnt.rk])   ,'YData',ygt([jnt.rh jnt.rk])   , 'ZData',zgt([jnt.rh jnt.rk])   ,'Color',cLegR ,'LineWidth',widLeg);    %
            line('XData',xgt([jnt.rk jnt.ra])   ,'YData',ygt([jnt.rk jnt.ra])   , 'ZData',zgt([jnt.rk jnt.ra])   ,'Color',cLegR ,'LineWidth',widLeg);
        case 32
            %% njoints = 32
            %==================================================================% Head
            line('XData',xgt([14 15])  ,'YData',ygt([14 15])  , 'ZData',zgt([14 15])  ,'Color',cHead ,'LineWidth',widLeg);
            line('XData',xgt([15 16])  ,'YData',ygt([15 16])  , 'ZData',zgt([15 16])  ,'Color',cHead ,'LineWidth',widLeg);
            % line('XData',xgt([16 17]),'YData',ygt([16 17])  , 'ZData',zgt([16 17])  ,'Color',cHead ,'LineWidth',widLeg);
            %==================================================================% Body
            line('XData',xgt([1 13])  ,'YData',ygt([1 13])   , 'ZData',zgt([1 13])    ,'Color',cBody ,'LineWidth',widLeg); % 1 and 12 same positions
            %line('XData',xgt([12 13]),'YData',ygt([12 13])  , 'ZData',zgt([12 13])   ,'Color',cBody ,'LineWidth',widLeg);
            line('XData',xgt([13 14]) ,'YData',ygt([13 14])  , 'ZData',zgt([13 14])   ,'Color',cBody ,'LineWidth',widLeg);
            %==================================================================% Right Arm
            line('XData',xgt([14 18])  ,'YData',ygt([14 18])  , 'ZData',zgt([14 18])  ,'Color',cArmR ,'LineWidth',widLeg);
            line('XData',xgt([18 19])  ,'YData',ygt([18 19])  , 'ZData',zgt([18 19])  ,'Color',cArmR ,'LineWidth',widLeg);
            line('XData',xgt([19 20])  ,'YData',ygt([19 20])  , 'ZData',zgt([19 20])  ,'Color',cArmR ,'LineWidth',widLeg);
            line('XData',xgt([20 21])  ,'YData',ygt([20 21])  , 'ZData',zgt([20 21])  ,'Color',cArmR ,'LineWidth',widLeg);
            %line('XData',xgt([21 22]) ,'YData',ygt([21 22])  , 'ZData',zgt([21 22])  ,'Color',cArmR ,'LineWidth',widLeg);
            line('XData',xgt([20 22])  ,'YData',ygt([20 22])  , 'ZData',zgt([20 22])  ,'Color',cArmR ,'LineWidth',widLeg);
            line('XData',xgt([20 23])  ,'YData',ygt([20 23])  , 'ZData',zgt([20 23])  ,'Color',cArmR ,'LineWidth',widLeg);
            %==================================================================% Left Arm
            line('XData',xgt([14 26])  ,'YData',ygt([14 26])  , 'ZData',zgt([14 26])  ,'Color',cArmL ,'LineWidth',widLeg);
            line('XData',xgt([26 27])  ,'YData',ygt([26 27])  , 'ZData',zgt([26 27])  ,'Color',cArmL ,'LineWidth',widLeg);
            line('XData',xgt([27 28])  ,'YData',ygt([27 28])  , 'ZData',zgt([27 28])  ,'Color',cArmL ,'LineWidth',widLeg);
            line('XData',xgt([28 29])  ,'YData',ygt([28 29])  , 'ZData',zgt([28 29])  ,'Color',cArmL ,'LineWidth',widLeg);
            %line('XData',xgt([29 30]) ,'YData',ygt([29 30])  , 'ZData',zgt([29 30])  ,'Color',cArmL ,'LineWidth',widLeg);
            line('XData',xgt([28 30])  ,'YData',ygt([28 30])  , 'ZData',zgt([28 30])  ,'Color',cArmL ,'LineWidth',widLeg);
            line('XData',xgt([28 31])  ,'YData',ygt([28 31])  , 'ZData',zgt([28 31])  ,'Color',cArmL ,'LineWidth',widLeg);
            %==================================================================% Right Leg
            line('XData',xgt([1 2])   ,'YData',ygt([1 2])   , 'ZData',zgt([1 2])     ,'Color',cLegR ,'LineWidth',widLeg);
            line('XData',xgt([2 3])   ,'YData',ygt([2 3])     , 'ZData',zgt([2 3])   ,'Color',cLegR ,'LineWidth',widLeg);
            line('XData',xgt([3 4])   ,'YData',ygt([3 4])    , 'ZData',zgt([3 4])    ,'Color',cLegR ,'LineWidth',widLeg);
            line('XData',xgt([4 5])   ,'YData',ygt([4 5])    , 'ZData',zgt([4 5])    ,'Color',cLegR ,'LineWidth',widLeg);
            line('XData',xgt([5 6])   ,'YData',ygt([5 6])    , 'ZData',zgt([5 6])    ,'Color',cLegR ,'LineWidth',widLeg);
            %==================================================================% Left Leg
            line('XData',xgt([1 7])   ,'YData',ygt([1 7])    , 'ZData',zgt([1 7])    ,'Color',cLegL ,'LineWidth',widLeg);
            line('XData',xgt([7 8])   ,'YData',ygt([7 8])    , 'ZData',zgt([7 8])    ,'Color',cLegL ,'LineWidth',widLeg);
            line('XData',xgt([8 9])   ,'YData',ygt([8 9])    , 'ZData',zgt([8 9])    ,'Color',cLegL ,'LineWidth',widLeg);
            line('XData',xgt([9 10])  ,'YData',ygt([9 10])   , 'ZData',zgt([9 10])   ,'Color',cLegL ,'LineWidth',widLeg);
            line('XData',xgt([10 11]) ,'YData',ygt([10 11])  , 'ZData',zgt([10 11])  ,'Color',cLegL ,'LineWidth',widLeg);
        otherwise
            disp('H-error: H_drawLineH36M:- wrong number of joints...');
    end
    
end
% c = uisetcolor
end