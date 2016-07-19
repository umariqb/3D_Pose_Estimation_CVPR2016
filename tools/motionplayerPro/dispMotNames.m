function dispMotNames(varargin)

global SCENE;

%collect filenames
fnames = cell(numel(SCENE.mots),1);
for i=1:numel( SCENE.mots)
    fnames{i}=SCENE.mots{i}.filename;
end

for i=1:numel(fnames)
    
    x = [0.025 0.1];
    y = [1-(i+2)*0.025 1-(i+3)*0.025];
    
    th = annotation('textbox',[x y],'String',fnames{i},'FontSize',14,...
                    'Interpreter','none','EdgeColor','none', ...
                    'FitBoxToText','on');
                
    if numel(fnames)==1
        set(th,'textcolor',SCENE.colors.singleSkel_FaceColor);
    else
        
        c = (i-1) / (SCENE.nmots-1);
        interpolated_color = ...
                       c     * SCENE.colors.multipleSkels_FaceVertexData_end...
                     + (1-c) * SCENE.colors.multipleSkels_FaceVertexData_start;
        
        set(th,'textcolor',hsv2rgb(interpolated_color));
    end
    
end


end