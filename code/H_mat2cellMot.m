function mot = H_mat2cellMot(pos, mot)

t = 1;
for i = 1:mot.njoints
    mot.jointTrajectories{i,1}(:,:) = pos(t:t+2,:);     
    t = t+3;
end

end