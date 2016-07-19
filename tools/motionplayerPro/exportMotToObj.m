function exportMotToObj(varargin)

    global SCENE;
    
    curFrame = SCENE.status.curFrame;
    
    for i=1:SCENE.nframes
        fprintf('\n\nExporting Frame: %5i\n\n',i);
        setFramePro(i);
        drawnow();
        exportObjFiles();
    end
    
    setFramePro(curFrame)

end