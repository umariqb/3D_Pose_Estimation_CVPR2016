function hand = plotSlide(varargin)

    switch nargin
        case 1
            timeSeries = varargin{1};
            xvalues    = 1:size(timeSeries,2);
        case 2
            timeSeries = varargin{2};
            xvalues    = varargin{1};
        otherwise
            error('Wrong num of Args!\n');
    end

    numPoints = size(timeSeries,2);
    numDims   = size(timeSeries,1);

    c_lo = 5;
    c_up = 12;
    c_in = c_up - c_lo;

    timeSeries = interp1(xvalues,timeSeries',xvalues(1):0.1:xvalues(end),'linear')';
    xvalues = xvalues(1):0.1:xvalues(end);
    hand = figure();
    
    cmap = colormap(jet(128));
    
    numPoints = size(timeSeries,2);
    
    for dim=1:numDims
       
        for point = 1:numPoints-1

            col = cmap( floor((timeSeries(dim,point)-c_lo)/( c_in / 127))+1,:);
            
            line([xvalues(point) xvalues(point+1)],... %x values of line
                 [timeSeries(dim,point) timeSeries(dim,point+1)], ... % y values of line
                'color', col, 'linewidth',4 );
            
        end
        
    end
    
    grid on;
    
       
end