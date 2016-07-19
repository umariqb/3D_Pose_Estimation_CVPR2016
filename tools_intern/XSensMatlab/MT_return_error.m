function [str_out]=MT_return_error(arg1);

% [str_out]=MT_return_error(arg1);
%
% this function displays the error message returned from the MTObj in human readable format
%
% Xsens Technologies B.V., 2002-2007
% v.2.8.4

switch arg1,
    case 0
        str_out = 'No new data calculated (No Error)';    
    case 1
        str_out = 'New data available';
    case 2
        str_out = 'No data on COM port';
    case 3
        str_out = 'No sensor ID received from sensor';
    case 4
        str_out = 'Incomplete data received   (Connection lost)';
    case 5
        str_out = 'Checksum error in data from sensor';
    case 6
        str_out ='COM port could not be opened';
    case 7
        str_out ='Xmu file with calibration data could not be read';
    case 8
        str_out ='Power-loss detected: sample counter with large gaps';
    otherwise
        str_out ='Unknown error returned from MTObj!';
end
        
