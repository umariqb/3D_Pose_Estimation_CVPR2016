function vertface2obj(v,f,filename)

    fid = fopen(filename, 'w');
    
    if fid>0
        fprintf(fid,'# vertices:\n');
        for i=1:size(v,1)
            fprintf(fid,'v %f %f %f\n',v(i,1),v(i,2),v(i,3));
        end
        fprintf(fid,'# faces:\n');
        for i=1:size(f,1)
            fprintf(fid,'f %i %i %i\n',f(i,1),f(i,2),f(i,3));
        end
        fprintf(fid,'# end\n');
        
    else
        error('Can not open obj file.');
    end
    
    fclose(fid);
    
end