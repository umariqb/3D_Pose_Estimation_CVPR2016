function drawLocalCoordinateSystems(varargin)

global SCENE;

if SCENE.status.localCoordSyst2_drawn
    SCENE.status.localCoordSyst2_drawn = false;
    set(SCENE.handles.drawLocalCoordSyst_Button,'CData',SCENE.buttons.localcoords+0.5,'TooltipString','draw local coordinate systems 1');
    
    for i=1:SCENE.nmots
        if SCENE.mots{i}.rotDataAvailable
            for j=1:SCENE.mots{i}.njoints
                delete(SCENE.handles.localCoordSystems(i,j,1));
                delete(SCENE.handles.localCoordSystems(i,j,2));
                delete(SCENE.handles.localCoordSystems(i,j,3));
            end
        end
    end
    
elseif SCENE.status.localCoordSyst1_drawn
    
    newCData = SCENE.buttons.localcoords;
    newCData(1:8,1:9,:) = newCData(1:8,1:9,:)+0.5;
    
    SCENE.status.localCoordSyst1_drawn = false;
    SCENE.status.localCoordSyst2_drawn = true;
    set(SCENE.handles.drawLocalCoordSyst_Button,'CData',newCData,'TooltipString','hide local coordinate systems');
    
    for i=1:SCENE.nmots
        if SCENE.mots{i}.rotDataAvailable
            for j=1:SCENE.mots{i}.njoints
                
                p = SCENE.mots{i}.vertices{j}(end-2:end,SCENE.status.curFrame);
                
                q_axis  = C_euler2quat(SCENE.skels{i}.nodes(j).axis([3,2,1])*pi/180);
                q_local = SCENE.mots{i}.localSystems{j}(:,SCENE.status.curFrame);
                
                q = C_quatmult(q_local,q_axis);
                
                if SCENE.status.spread
                    q = C_quatmult(SCENE.mots{i}.rotOffset,q);
                end

                xyz = C_quatrot([SCENE.lengthOfLocalCoordSystAxes 0 0; 0 SCENE.lengthOfLocalCoordSystAxes 0; 0 0 SCENE.lengthOfLocalCoordSystAxes]',q);

                set(SCENE.handles.localCoordSystems(i,j,1),'XData',[p(1) p(1)+xyz(1,1)],'YData',[p(2) p(2)+xyz(2,1)],'ZData',[p(3) p(3)+xyz(3,1)]);
                set(SCENE.handles.localCoordSystems(i,j,2),'XData',[p(1) p(1)+xyz(1,2)],'YData',[p(2) p(2)+xyz(2,2)],'ZData',[p(3) p(3)+xyz(3,2)]);
                set(SCENE.handles.localCoordSystems(i,j,3),'XData',[p(1) p(1)+xyz(1,3)],'YData',[p(2) p(2)+xyz(2,3)],'ZData',[p(3) p(3)+xyz(3,3)]);

            end
        end
    end
else
    SCENE.status.localCoordSyst1_drawn = true;
    
    newCData = SCENE.buttons.localcoords;
    newCData(8:end,7:end,:) = newCData(8:end,7:end,:)+0.5;
    
    set(SCENE.handles.drawLocalCoordSyst_Button,'CData',newCData,'TooltipString','draw local coordinate systems 2');
    
    hold all;
    for i=1:SCENE.nmots
        if SCENE.mots{i}.rotDataAvailable
%             if ~isfield(SCENE.mots{i},'localSystems')
                SCENE.mots{i}=computeLocalSystems(SCENE.skels{i},SCENE.mots{i});
%             end
            for j=1:SCENE.mots{i}.njoints
                p = SCENE.mots{i}.vertices{j}(end-2:end,SCENE.status.curFrame);
                q = SCENE.mots{i}.localSystems{j}(:,SCENE.status.curFrame);
                
                if SCENE.status.spread
                    q = C_quatmult(SCENE.mots{i}.rotOffset,q);
                end
                xyz = C_quatrot([1 0 0;...
                                 0 1 0;...
                                 0 0 1] * SCENE.lengthOfLocalCoordSystAxes,q);
                             
                SCENE.handles.localCoordSystems(i,j,1) = plot3([p(1) p(1)+xyz(1,1)],[p(2) p(2)+xyz(2,1)],[p(3) p(3)+xyz(3,1)],'color','red');
                SCENE.handles.localCoordSystems(i,j,2) = plot3([p(1) p(1)+xyz(1,2)],[p(2) p(2)+xyz(2,2)],[p(3) p(3)+xyz(3,2)],'color','green');
                SCENE.handles.localCoordSystems(i,j,3) = plot3([p(1) p(1)+xyz(1,3)],[p(2) p(2)+xyz(2,3)],[p(3) p(3)+xyz(3,3)],'color','blue');
            end
        end
    end
    hold off; 
    
end

end

