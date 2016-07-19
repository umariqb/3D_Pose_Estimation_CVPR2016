function mot=addExpMapToMot(mot)

for i=1:mot.njoints
   if ~isempty(mot.rotationQuat{i})
       mot.rotationExpMap{i,1}=quatlog(mot.rotationQuat{i});
   else
       mot.rotationExpMap{i,1}=zeros(3,mot.nframes);
   end
end

end