function drawSensorCoordinateSystems2(varargin)

global SCENE;

if SCENE.status.sensorCoordSyst2_drawn
    SCENE.status.sensorCoordSyst2_drawn = false;
    set(SCENE.handles.drawSensorCoordSyst2_Button,'CData',SCENE.buttons.sensorcoords+0.5,'TooltipString','draw sensor coordinate systems');
    
    for i=1:SCENE.nmots
        if SCENE.mots{i}.rotDataAvailable
            sensors = fieldnames(SCENE.mots{i}.virtualSensors);
            for j=1:numel(sensors)
                delete(SCENE.handles.sensorCoordSystems2(i,j,1));
                delete(SCENE.handles.sensorCoordSystems2(i,j,2));
                delete(SCENE.handles.sensorCoordSystems2(i,j,3));
            end
        end
    end
else
    SCENE.status.sensorCoordSyst2_drawn = true;
    
    set(SCENE.handles.drawSensorCoordSyst2_Button,'CData',SCENE.buttons.sensorcoords,'TooltipString','hide sensor coordinate systems');
    
    options.frameForCalibration = 0;
    options.gravity             = SCENE.gravity;
    options.sensors             = SCENE.virtualSensors;
    sensors = fieldnames(SCENE.virtualSensors);
    for j=1:numel(sensors);
        options.sensors.(sensors{j}).calibrationPose = 'none';
    end
           
    hold all;
    for i=1:SCENE.nmots
        options.filterSize          = floor(SCENE.mots{i}.samplingRate/10);         
        
        if SCENE.mots{i}.rotDataAvailable
            if SCENE.status.spread
                options.additionalRotOffset = SCENE.mots{i}.rotOffset;
            end
            res = simulateLocalAccsFromAMC2(SCENE.skels{i},SCENE.mots{i},options);
            
            for j=1:numel(sensors);
                SCENE.virtualSensors.(sensors{j}).jointIDs_amc       = res.options.sensors.(sensors{j}).jointIDs_amc;
                SCENE.mots{i}.virtualSensors.(sensors{j}).rotation2  = res.(sensors{j}).q_L2G;
                SCENE.mots{i}.virtualSensors.(sensors{j}).globalAcc2 = res.(sensors{j}).acc_G;
                
                pos = res.(sensors{j}).pos(:,SCENE.status.curFrame);
                q_G2L = res.(sensors{j}).q_G2L(:,SCENE.status.curFrame);
                w   = C_quatrot(res.(sensors{j}).acc_G(:,SCENE.status.curFrame),q_G2L);
                w   = w/SCENE.gravity*30;
                p_G = C_quatrot([w(1) 0 0;0 w(2) 0;0 0 w(3)],C_quatinv(q_G2L));
              
                SCENE.handles.sensorCoordSystems2(i,j,1) = ...
                    plot3([pos(1) pos(1)+p_G(1,1)],...
                          [pos(2) pos(2)+p_G(2,1)],...
                          [pos(3) pos(3)+p_G(3,1)],'color','red');
                SCENE.handles.sensorCoordSystems2(i,j,2) = ...
                    plot3([pos(1) pos(1)+p_G(1,2)],...
                          [pos(2) pos(2)+p_G(2,2)],...
                          [pos(3) pos(3)+p_G(3,2)],'color','green');
                SCENE.handles.sensorCoordSystems2(i,j,3) = ...
                    plot3([pos(1) pos(1)+p_G(1,3)],...
                          [pos(2) pos(2)+p_G(2,3)],...
                          [pos(3) pos(3)+p_G(3,3)],'color','blue');
            end
        end
    end
    hold off; 
    
end

end

