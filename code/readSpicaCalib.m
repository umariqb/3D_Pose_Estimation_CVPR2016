function [fc, cc, alpha_c, kc, Rc_ext, omc_ext, Tc_ext] = readSpicaCalib(calfilename)
% Reads the calibration from the file
%
% Format:
%   [FC, CC, ALPHA_C, KC, RC_EXT, OMC_EXT, TC_EXT] 
%                                = ReadSpicaCalib(CALFILENAME);
%
% Input:
%    CALFILENAME - file name of the calibration (e.g. Spica1Calib.cal) 
%                  including full path
%
% Output: 
%    FC      - Focal length (2x1)
%    CC      - Principle point (2x1)
%    ALPHA_C - Skew coefficient (1x1)
%    KC      - Distortion coefficient (5x1)
%    RC_EXT  - Extrinsic rotation matrix (3x3)
%    OMC_EXT - Extrinsic rotation angles, simply a decomposition
%              of RC_EXT (3x1)
%    TC_EXT  - Extrinsic translation vector (3x1)
%
% To map from world coordinate point X to the camera reference frame 
% point Xc, do the following: Xc = RC_EXT * X + TC_EXT;
%
% Written by: Leonid Sigal 
% Revision:   1.0
% Date:       5/12/2006
%
% Copyright 2006, Brown University 
% All Rights Reserved Permission to use, copy, modify, and distribute this 
% software and its documentation for any non-commercial purpose is hereby 
% granted without fee, provided that the above copyright notice appear in 
% all copies and that both that copyright notice and this permission 
% notice appear in supporting documentation, and that the name of the 
% author not be used in advertising or publicity pertaining to distribution 
% of the software without specific, written prior permission. 
% THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, 
% INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY 
% PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY 
% SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER 
% RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF 
% CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN 
% CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE. 

if (~exist(calfilename))
    error(sprintf('%s file does not exist.', calfilename));    
end
    
fid = fopen(calfilename,'r');    
[fc]    = fscanf(fid, '%f', 2);
[cc]    = fscanf(fid, '%f', 2);
[alpha_c] = fscanf(fid, '%f', 1);
[kc]    = fscanf(fid, '%f', 5);
[r]     = fscanf(fid, '%f', 9);
Rc_ext  = [r(1), r(2), r(3); ...
           r(4), r(5), r(6); ...
           r(7), r(8), r(9)];            
omc_ext = rodrigues(Rc_ext);
Tc_ext  = fscanf(fid, '%f', 3);
fclose(fid);            

