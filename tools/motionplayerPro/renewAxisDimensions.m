function axisDimensions = renewAxisDimensions(bb)
    diagonal = sqrt(sum((bb([1,3,5])-bb([2,4,6])).^2))/2;
    
    % center of the boundingbox's bottom
    xc = bb(1) + (bb(2) - bb(1))/2;
    yc = bb(3) + (bb(4) - bb(3))/2;
%     %zc = bb(5) + (bb(6) - bb(5))/2;
    axisDimensions = [xc-diagonal xc+diagonal yc-diagonal yc+diagonal];
end