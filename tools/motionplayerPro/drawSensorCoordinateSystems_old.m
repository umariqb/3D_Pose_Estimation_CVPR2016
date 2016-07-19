function drawSensorCoordinateSystems_old(varargin)

global SCENE;

if SCENE.status.sensorCoordSyst_drawn
    SCENE.status.sensorCoordSyst_drawn = false;
    set(SCENE.handles.drawSensorCoordSyst_Button,'CData',SCENE.buttons.sensorcoords+0.5,'TooltipString','draw sensor coordinate systems');
    
    for i=1:SCENE.nmots
        if SCENE.mots{i}.rotDataAvailable
            sensors = fieldnames(SCENE.mots{i}.virtualSensors);
            for j=1:numel(sensors)
                delete(SCENE.handles.sensorCoordSystems(i,j,1));
                delete(SCENE.handles.sensorCoordSystems(i,j,2));
                delete(SCENE.handles.sensorCoordSystems(i,j,3));
            end
        end
    end
else
    SCENE.status.sensorCoordSyst_drawn = true;
    
    set(SCENE.handles.drawSensorCoordSyst_Button,'CData',SCENE.buttons.sensorcoords,'TooltipString','hide sensor coordinate systems');
    
    hold all;
    
    sensors = fieldnames(SCENE.virtualSensors);
    for i=1:SCENE.nmots
        if SCENE.mots{i}.rotDataAvailable
            mot_tmp             = computeLocalSystems(SCENE.skels{i},SCENE.mots{i},true);
            filterSize          = floor(SCENE.mots{i}.samplingRate/10);
            frameForCalibration = SCENE.status.curFrame;
            
            for j=1:numel(sensors)

                switch sensors{j}
                    case {'leftWrist','rightWrist'}
                        jointID     = SCENE.virtualSensors.(sensors{j}).jointID;
                        offset      = SCENE.virtualSensors.(sensors{j}).offset;
                        q_L2G       = mot_tmp.localSystems{jointID};
                        q_L2G_cal   = q_L2G(:,frameForCalibration);
                        
                        x_local_G   = C_quatrot([1;0;0],q_L2G_cal); % local x in global coordinates
                        y_local_G   = C_quatrot([0;1;0],q_L2G_cal); % local z in global coordinates
                        v1          = normalizeColumns(cross(y_local_G,[0;1;0]));
                        rotOffset   = acos(dot(x_local_G,v1));
                        d           = acos(dot(cross(v1,x_local_G),y_local_G));
                        if d<pi/2, rotOffset = -rotOffset; end
                        q_z = rotquat(-pi/2,'z');
                        q_y = rotquat(rotOffset,'y');

                        q_LC2G = C_quatmult(q_L2G,C_quatmult(q_y,q_z));
                        
                        SCENE.mots{i}.virtualSensors.(sensors{j}).rotation = q_LC2G;
                        
                        if SCENE.status.spread
                            q_LC2G = C_quatmult(SCENE.mots{i}.rotOffset,q_LC2G);
                        end

                        % quaternion transforming global coordinates to (rotation corrected) local coordinates
                        q_G2LC = C_quatinv(q_LC2G(:,SCENE.status.curFrame));
                        
                        % positions of simulated sensor (in global coordinates)
                        pos      = SCENE.mots{i}.vertices{jointID}(end-2:end,:);
                        pos      = pos + C_quatrot([0;0;offset],q_LC2G);
                        % accelerations of simulated sensor (in global coordinates)
                        acc      = diff5point(pos,SCENE.mots{i}.samplingRate,2)*2.54/100;
                        acc      = filterTimeline(acc,filterSize,'bin');
                        acc(2,:) = acc(2,:)+SCENE.gravity;
                        
                        SCENE.mots{i}.virtualSensors.(sensors{j}).globalAcc = acc;
                        
                        pos = pos(:,SCENE.status.curFrame);
                        
                        w   = C_quatrot(acc(:,SCENE.status.curFrame),q_G2LC);
                        p_G = C_quatrot([w(1) 0 0;0 w(2) 0;0 0 w(3)],q_LC2G(:,SCENE.status.curFrame));
                        
                    otherwise
                        fprintf('Unknown sensor name!');
                end
                
                SCENE.handles.sensorCoordSystems(i,j,1) = ...
                    plot3([pos(1) pos(1)+p_G(1,1)],...
                          [pos(2) pos(2)+p_G(2,1)],...
                          [pos(3) pos(3)+p_G(3,1)],'color','red');
                SCENE.handles.sensorCoordSystems(i,j,2) = ...
                    plot3([pos(1) pos(1)+p_G(1,2)],...
                          [pos(2) pos(2)+p_G(2,2)],...
                          [pos(3) pos(3)+p_G(3,2)],'color','green');
                SCENE.handles.sensorCoordSystems(i,j,3) = ...
                    plot3([pos(1) pos(1)+p_G(1,3)],...
                          [pos(2) pos(2)+p_G(2,3)],...
                          [pos(3) pos(3)+p_G(3,3)],'color','blue');
            end
        end
    end
    hold off; 
    
end

end

