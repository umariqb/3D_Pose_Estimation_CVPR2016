function explodemesh(fname,x,y,z,d)
%EXPLODEMESH "Explodes" a mesh into polygons and saves it as an Obj file.
%EXPLODEMESH(fname,x,y,z,d)
%      fname: filename
%      x,y,z: mesh coordinates
%      d: degree of shrinkage


l=size(x,1); 
h=size(x,2);  
n=zeros(l,h);

fid=fopen(fname,'w');
nn=1;
for i=1:(l-1)
  for j=1:(h-1)
    cx=(x(i,j)+x(i+1,j)+x(i,j+1)+x(i+1,j+1))/4;
    cy=(y(i,j)+y(i+1,j)+y(i,j+1)+y(i+1,j+1))/4;
    cz=(z(i,j)+z(i+1,j)+z(i,j+1)+z(i+1,j+1))/4;
    n(i,j)=nn; 

    fprintf(fid, 'v %f %f %f\n',d*(x(i,j)-cx)+cx,d*(y(i,j)-cy)+cy,d*(z(i,j)-cz)+cz); 
    fprintf(fid, 'vt %f %f\n',(i-1)/(l-1),(j-1)/(h-1)); 

    fprintf(fid, 'v %f %f %f\n',d*(x(i+1,j)-cx)+cx,d*(y(i+1,j)-cy)+cy,d*(z(i+1,j)-cz)+cz); 
    fprintf(fid, 'vt %f %f\n',i/(l-1),(j-1)/(h-1)); 

    fprintf(fid, 'v %f %f %f\n',d*(x(i+1,j+1)-cx)+cx,d*(y(i+1,j+1)-cy)+cy,d*(z(i+1,j+1)-cz)+cz); 
    fprintf(fid, 'vt %f %f\n',i/(l-1),j/(h-1)); 

    fprintf(fid, 'v %f %f %f\n',d*(x(i,j+1)-cx)+cx,d*(y(i,j+1)-cy)+cy,d*(z(i,j+1)-cz)+cz); 
    fprintf(fid, 'vt %f %f\n',(i-1)/(l-1),j/(h-1)); 

    nn=nn+4;
  end
end
fprintf(fid,'g mesh\n');

for i=1:(l-1)
  for j=1:(h-1)
    fprintf(fid,'f %d/%d %d/%d %d/%d %d/%d\n',n(i,j),n(i,j),n(i,j)+1,n(i,j)+1,n(i,j)+2,n(i,j)+2,n(i,j)+3,n(i,j)+3);
  end
end
fprintf(fid,'g\n\n');
fclose(fid);