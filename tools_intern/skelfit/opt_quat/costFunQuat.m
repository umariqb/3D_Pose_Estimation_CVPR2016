function [costs, gradient] = costFunQuat( X )

global VARS_GLOBAL_SKELFIT

jt_goal = VARS_GLOBAL_SKELFIT.jointTrajectories;
rootRotationalOffsetQuat = VARS_GLOBAL_SKELFIT.rootRotationalOffsetQuat;
nodes = VARS_GLOBAL_SKELFIT.nodes;
frame = VARS_GLOBAL_SKELFIT.frame;
nameMap = VARS_GLOBAL_SKELFIT.nameMap;
nJoints = VARS_GLOBAL_SKELFIT.nJoints;

rootTranslation = X(1:3)';
% rotationQuat = X(4:length(rotationQuat));

for i=1:nJoints
    rotationQuat{i} = X(4*i: 4*i + 3)';
end

% determine paths from root to joints
rootIdx = strMatch('root', nameMap(:,1), 'exact');
paths = cell(nJoints,1);

for i=1:nJoints
    idx = i;
    while idx~=rootIdx
        paths{i} = [paths{i} idx];
        idx = nodes(idx).parentID;
    end
    paths{i} = [paths{i} idx];
end
   
derivatives = zeros( nJoints, length(X) - 3 );

for i=1:nJoints
    for j=1:length(paths{i});   % idxs contained in path are the relevant ones, other derivatives are zero.
        idx = paths{i}(j);
        if idx~=rootIdx
            posSoFar = calculateQuatProduct(X, paths{i}(j+1:end), rootTranslation, [nodes.offset]);
            x = posSoFar(1);
            y = posSoFar(2);
            z = posSoFar(3);
%             qr = [ (qx*x+qy*y+qz*z)*qx+(qw*x+qy*z-qz*y)*qw-(qw*y+qz*x-qx*z)*qz+(qw*z+qx*y-qy*x)*qy; ...
%                    (qx*x+qy*y+qz*z)*qy+(qw*y+qz*x-qx*z)*qw-(qw*z+qx*y-qy*x)*qx+(qw*x+qy*z-qz*y)*qz; ...
%                    (qx*x+qy*y+qz*z)*qz+(qw*z+qx*y-qy*x)*qw-(qw*x+qy*z-qz*y)*qy+(qw*y+qz*x-qx*z)*qx];
%             qr = qr / (qw^2+qx^2+qy^2+qz^2);
% 
%             qrw = diff(qr, qw);
%             qrx = diff(qr, qx);
%             qry = diff(qr, qy);
%             qrz = diff(qr, qz);

            qw = X(idx*4);
            qx = X(idx*4+1);
            qy = X(idx*4+2);
            qz = X(idx*4+3);
            q = [qw;qx;qy;qz];

            qrw = [ (2*qw*x+2*qy*z-2*qz*y)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qx+(qw*x+qy*z-qz*y)*qw-(qw*y+qz*x-qx*z)*qz+(qw*z+qx*y-qy*x)*qy)/(qw^2+qx^2+qy^2+qz^2)^2*qw; ...
                    (2*qw*y+2*qz*x-2*qx*z)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qy+(qw*y+qz*x-qx*z)*qw-(qw*z+qx*y-qy*x)*qx+(qw*x+qy*z-qz*y)*qz)/(qw^2+qx^2+qy^2+qz^2)^2*qw; ...
                    (2*qw*z+2*qx*y-2*qy*x)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qz+(qw*z+qx*y-qy*x)*qw-(qw*x+qy*z-qz*y)*qy+(qw*y+qz*x-qx*z)*qx)/(qw^2+qx^2+qy^2+qz^2)^2*qw];
            qrx = [ (2*qx*x+2*qy*y+2*qz*z)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qx+(qw*x+qy*z-qz*y)*qw-(qw*y+qz*x-qx*z)*qz+(qw*z+qx*y-qy*x)*qy)/(qw^2+qx^2+qy^2+qz^2)^2*qx; ...
                    (2*qy*x-2*qw*z-2*qx*y)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qy+(qw*y+qz*x-qx*z)*qw-(qw*z+qx*y-qy*x)*qx+(qw*x+qy*z-qz*y)*qz)/(qw^2+qx^2+qy^2+qz^2)^2*qx; ...
                    (2*qw*y+2*qz*x-2*qx*z)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qz+(qw*z+qx*y-qy*x)*qw-(qw*x+qy*z-qz*y)*qy+(qw*y+qz*x-qx*z)*qx)/(qw^2+qx^2+qy^2+qz^2)^2*qx];
            qry = [ (2*qw*z+2*qx*y-2*qy*x)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qx+(qw*x+qy*z-qz*y)*qw-(qw*y+qz*x-qx*z)*qz+(qw*z+qx*y-qy*x)*qy)/(qw^2+qx^2+qy^2+qz^2)^2*qy; ...
                    (2*qx*x+2*qy*y+2*qz*z)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qy+(qw*y+qz*x-qx*z)*qw-(qw*z+qx*y-qy*x)*qx+(qw*x+qy*z-qz*y)*qz)/(qw^2+qx^2+qy^2+qz^2)^2*qy; ...
                    (2*qz*y-2*qw*x-2*qy*z)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qz+(qw*z+qx*y-qy*x)*qw-(qw*x+qy*z-qz*y)*qy+(qw*y+qz*x-qx*z)*qx)/(qw^2+qx^2+qy^2+qz^2)^2*qy];
            qrz = [ (2*qx*z-2*qw*y-2*qz*x)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qx+(qw*x+qy*z-qz*y)*qw-(qw*y+qz*x-qx*z)*qz+(qw*z+qx*y-qy*x)*qy)/(qw^2+qx^2+qy^2+qz^2)^2*qz; ...
                    (2*qw*x+2*qy*z-2*qz*y)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qy+(qw*y+qz*x-qx*z)*qw-(qw*z+qx*y-qy*x)*qx+(qw*x+qy*z-qz*y)*qz)/(qw^2+qx^2+qy^2+qz^2)^2*qz; ...
                    (2*qx*x+2*qy*y+2*qz*z)/(qw^2+qx^2+qy^2+qz^2)-2*((qx*x+qy*y+qz*z)*qz+(qw*z+qx*y-qy*x)*qw-(qw*x+qy*z-qz*y)*qy+(qw*y+qz*x-qx*z)*qx)/(qw^2+qx^2+qy^2+qz^2)^2*qz];

            derivatives( i, idx*4     ) = calculateQuatProduct(X, paths{i}(1:j), qrw, [nodes.offset]);
            derivatives( i, idx*4 + 1 ) = calculateQuatProduct(X, paths{i}(1:j), qrx, [nodes.offset]);
            derivatives( i, idx*4 + 2 ) = calculateQuatProduct(X, paths{i}(1:j), qry, [nodes.offset]);
            derivatives( i, idx*4 + 3 ) = calculateQuatProduct(X, paths{i}(1:j), qrz, [nodes.offset]);
        else
            % was ist mit root?
        end
    end
end

% for i=1:nJoints
%     for j=1:(length(X)-3)/4
%         q = X(j*4:j*4+3);
%         for t=1:4
%             qt = q(t);
%             
%         end
%     end
% end

% pro joint k:
%   pro Quaternionenteil qt von q ( also für jedes x aus X )
%      Leite die errechnete Koordinate ab, folgendermaßen:
%      (benötigt Abfolge von Rotationen, die zur FK für diesen joint
%      benutzt wird)
%      sei (x,y,z) die Koordinaten des Punktes bis zur Rotation an k (um qt)
%      berechne diff(quatrot((x,y,z), q), qt):
%
%      syms qx qy qz qw;   % bzw., dies sind die koordinaten von q, also keine Variablen!!
% 
%      qr2 = [ -(-x*qx-y*qy-z*qz)*qx+(x*qw+z*qy-y*qz)*qw-(y*qw+x*qz-z*qx)*qz+(z*qw+y*qx-x*qy)*qy; ...
%      -(-x*qx-y*qy-z*qz)*qy+(y*qw+x*qz-z*qx)*qw-(z*qw+y*qx-x*qy)*qx+(x*qw+z*qy-y*qz)*qz; ...
%      -(-x*qx-y*qy-z*qz)*qz+(z*qw+y*qx-x*qy)*qw-(x*qw+z*qy-y*qz)*qy+(y*qw+x*qz-z*qx)*qx];
% 
%      qr2 = qr2 / (qw^2+qx^2+qy^2+qz^2);
%      ( Ist das bereits die Ableitung ?!)
%
%      multipliziere restliche Rotationen dran... (q1 ... qk-1)

jt_fk = fK_Quat_frame(rotationQuat, rootTranslation, nodes, rootRotationalOffsetQuat);

diff = cell2mat(jt_goal) - cell2mat(jt_fk);
costs = sqrt( dot( diff, diff ) );
gradient = 1;