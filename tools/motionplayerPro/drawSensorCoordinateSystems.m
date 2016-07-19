function drawSensorCoordinateSystems(varargin)

global SCENE;

if SCENE.status.sensorCoordSyst_drawn
    SCENE.status.sensorCoordSyst_drawn = false;
    set(SCENE.handles.drawSensorCoordSyst_Button,'CData',SCENE.buttons.sensorcoords+0.5,'TooltipString','draw sensor coordinate systems');
    
    for i=1:SCENE.nmots
        sensors = fieldnames(SCENE.mots{i}.virtualSensors);
        for j=1:numel(sensors)
            delete(SCENE.handles.sensorCoordSystems(i,j,1));
            delete(SCENE.handles.sensorCoordSystems(i,j,2));
            delete(SCENE.handles.sensorCoordSystems(i,j,3));
        end
    end
else
    SCENE.status.sensorCoordSyst_drawn = true;
    
    set(SCENE.handles.drawSensorCoordSyst_Button,'CData',SCENE.buttons.sensorcoords,'TooltipString','hide sensor coordinate systems');
    
    hold all;
    for i=1:SCENE.nmots
        options.filterSize          = floor(SCENE.mots{i}.samplingRate/10);         
        options.frameForCalibration = SCENE.status.curFrame;
        options.gravity             = SCENE.gravity;
        options.sensors             = SCENE.virtualSensors;
        
        if SCENE.status.spread && isfield(SCENE.mots{i},'rotOffset')
            options.additionalRotOffset = SCENE.mots{i}.rotOffset;
        end
        
        if SCENE.mots{i}.rotDataAvailable
            extension   = 'amc';
            res         = simulateLocalAccsFromAMC2(SCENE.skels{i},SCENE.mots{i},options);
        else
            extension   = 'c3d';
            res         = simulateLocalAccsFromC3D2(SCENE.mots{i},options);
        end
            
        sensors = fieldnames(SCENE.virtualSensors);
        
        s = 0;
        for j=1:numel(sensors);
            if isfield(res,sensors{j})
                s=s+1;
                SCENE.virtualSensors.(sensors{j}).(['jointIDs_' extension]) = res.options.sensors.(sensors{j}).(['jointIDs_' extension]);
                SCENE.mots{i}.virtualSensors.(sensors{j}).rotation  = res.(sensors{j}).q_L2G;
                SCENE.mots{i}.virtualSensors.(sensors{j}).globalAcc = res.(sensors{j}).acc_G;

                pos = res.(sensors{j}).pos(:,SCENE.status.curFrame);
                q_G2L = res.(sensors{j}).q_G2L(:,SCENE.status.curFrame);
                w   = C_quatrot(res.(sensors{j}).acc_G(:,SCENE.status.curFrame),q_G2L);
                w   = w/SCENE.gravity*30;
                p_G = C_quatrot([w(1) 0 0;0 w(2) 0;0 0 w(3)],C_quatinv(q_G2L));

                SCENE.handles.sensorCoordSystems(i,s,1) = ...
                    plot3([pos(1) pos(1)+p_G(1,1)],...
                          [pos(2) pos(2)+p_G(2,1)],...
                          [pos(3) pos(3)+p_G(3,1)],'color','red');
                SCENE.handles.sensorCoordSystems(i,s,2) = ...
                    plot3([pos(1) pos(1)+p_G(1,2)],...
                          [pos(2) pos(2)+p_G(2,2)],...
                          [pos(3) pos(3)+p_G(3,2)],'color','green');
                SCENE.handles.sensorCoordSystems(i,s,3) = ...
                    plot3([pos(1) pos(1)+p_G(1,3)],...
                          [pos(2) pos(2)+p_G(2,3)],...
                          [pos(3) pos(3)+p_G(3,3)],'color','blue');
            end
        end
    end
    hold off; 
    
end

end

