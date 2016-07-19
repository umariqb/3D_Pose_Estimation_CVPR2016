% convert all fig files in current directory to eps, where parameter
% output_height is the desired height of the eps bounding box in cm.
% colorbar and aspect ratio are handled correctly 

output_height = 7.5; % cm

d = dir('*.fig');

for k=1:length(d) 
    open(d(k).name); 
    axis normal; 
    h = get(gcf,'children');
    dar = [];
    for j=1:length(h) % find first pure axes object
        if (strcmp(get(h(j),'type'),'axes') && strcmp(get(h(j),'tag'),''))
            dar = get(h(j),'dataaspectratio');
        end
    end
    if (isempty(dar))
        close;
        continue;
    end
    yxar = dar(1)/dar(2)*1.0969; % magic number: 1 + x, where x is the width of a colorbar including distance from plot (measured in relative coordinates)
    set(gcf,'paperposition',[2 15 output_height*yxar output_height]);
    print('-depsc2',[d(k).name '.eps']); 
    close; 
end
