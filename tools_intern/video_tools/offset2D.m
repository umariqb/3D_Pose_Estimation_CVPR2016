function out = offset2D(in,ofs,padval)

nx = size(in,2);
ny = size(in,1);
dx = ofs(1);
dy = ofs(2);

out = in;

% handle x offset
if (dx>0)
    padded = padarray(in,[0 dx],padval,'pre');
    out = padded(:,1:nx,:);
elseif (dx<0)
    dx = abs(dx);
    padded = padarray(in,[0 dx],padval,'post');
    out = padded(:,dx+1:nx+dx,:);
end

% handle y offset
if (dy<0)
    dy = abs(dy);
    padded = padarray(in,[dy 0],padval,'pre');
    out = padded(1:ny,:,:);
elseif (dy>0)
    padded = padarray(in,[dy 0],padval,'post');
    out = padded(dy+1:ny+dy,:,:);
end