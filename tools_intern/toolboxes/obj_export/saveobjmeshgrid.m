function saveobjmeshgrid(name,x,y,z,g)
% SAVEOBJMESHGRID Save a x,y,z mesh as a Wavefront/Alias Obj file
%                 as a gridded surface.
% SAVEOBJMESHGRID(fname,x,y,z,g)
%     Saves the mesh to the file named in the string fname
%     x,y,z are equally sized matrices with coordinates.
%     g is the size of the grid lines, 0..1.

l=size(x,1); h=size(x,2);

n=zeros(l,h);

fid=fopen(name,'w');
nn=1;
for i=1:l
    for j=1:h
       n(i,j)=nn; 
       fprintf(fid, 'v %f %f %f\n',x(i,j),y(i,j),z(i,j)); 
       nn=nn+1;
   end
end

n2=zeros(l,h);
for i=1:(l-1)
    for j=1:(h-1)        
        x1=[x(i,j) y(i,j) z(i,j)];
        x2=[x(i+1,j) y(i+1,j) z(i+1,j)];
        x3=[x(i+1,j+1) y(i+1,j+1) z(i+1,j+1)];
        x4=[x(i,j+1) y(i,j+1) z(i,j+1)];
  
        v1=x2-x1; v2=x3-x2; v3=x4-x3; v4=x1-x4;
        if (norm(v1)>0) v1=v1/norm(v1); end
        if (norm(v2)>0) v2=v2/norm(v2); end
        if (norm(v3)>0) v3=v3/norm(v3); end
        if (norm(v4)>0) v4=v4/norm(v4); end
        
        xx1=x1+(v1-v4)*g;
        xx2=x2+(v2-v1)*g;        
        xx3=x3+(v3-v2)*g;       
        xx4=x4+(v4-v3)*g;

        fprintf(fid, 'v %f %f %f\n',xx1(1),xx1(2),xx1(3)); 
        fprintf(fid, 'v %f %f %f\n',xx2(1),xx2(2),xx2(3)); 
        fprintf(fid, 'v %f %f %f\n',xx3(1),xx3(2),xx3(3)); 
        fprintf(fid, 'v %f %f %f\n',xx4(1),xx4(2),xx4(3)); 

        n2(i,j)=nn;
        nn=nn+4;

%        plot3(xx1(1),xx1(2),xx1(3));
%        plot3(xx2(1),xx2(2),xx2(3));
%        plot3(xx3(1),xx3(2),xx3(3));
%        plot3(xx4(1),xx4(2),xx4(3));
    end
end

 
fprintf(fid,'g mesh\n');
       
 for i=1:(l-1)
    for j=1:(h-1)            
        fprintf(fid,'f %d %d %d %d\n',n(i,j),n(i+1,j),n2(i,j)+1,n2(i,j));
        fprintf(fid,'f %d %d %d %d\n',n(i+1,j),n(i+1,j+1),n2(i,j)+2,n2(i,j)+1);
        fprintf(fid,'f %d %d %d %d\n',n(i+1,j+1),n(i,j+1),n2(i,j)+3,n2(i,j)+2);
        fprintf(fid,'f %d %d %d %d\n',n(i,j+1),n(i,j),n2(i,j),n2(i,j)+3);                        
    end
end

fprintf(fid,'g\n\n');
fclose(fid);

