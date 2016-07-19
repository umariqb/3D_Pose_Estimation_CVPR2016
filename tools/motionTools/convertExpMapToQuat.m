function mot=convertExpMapToQuat(mot)

for i=1:mot.njoints
    mot.rotationQuat{i,1}=quatexp(mot.rotationExpMap{i});
end

end