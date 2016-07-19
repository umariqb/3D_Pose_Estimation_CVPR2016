function angDB = H_setAngAzEl(varargin)
if(nargin>0)
    method = varargin{1};
else
    method = '2Dvideo';
end
switch method
    case '2Dsyn'
        angDB.startEL = 0;
        angDB.incrEL  = 15;       %15   15
        angDB.angleEL = 90;       %90   90
        angDB.endAZ   = 0;        % 0
        angDB.incrAZ  = 10;       %10   20
        angDB.endAZ   = 350;      %350  340
    case '2Dvideo'
        angDB.startEL = 0;
        angDB.incrEL  = 15;       %15   15
        angDB.endEL   = 90;       %90   90
        angDB.startAZ = 0;        % 0
        angDB.incrAZ  = 15;       %10   20
        angDB.endAZ   = 345;      %350  340
    case 'ActRec'
        angDB.startEL = 0;
        angDB.incrEL  = 30;       %15   15
        angDB.endEL   = 60;       %90   90
        angDB.startAZ = 0;        % 0
        angDB.incrAZ  = 30;       %10   20
        angDB.endAZ   = 330;      %350  340
    otherwise
        angDB.startEL = 0;
        angDB.incrEL  = 15;       %15   15
        angDB.endEL   = 90;       %90   90
        angDB.endAZ   = 0;        % 0
        angDB.incrAZ  = 20;       %10   20
        angDB.endAZ   = 340;      %350  340
end
end