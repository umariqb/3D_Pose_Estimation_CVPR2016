function transSkel = translateSkelFrame( skel, v )

for i=1:length(skel)
    transSkel{i} = skel{i} + v;
end
