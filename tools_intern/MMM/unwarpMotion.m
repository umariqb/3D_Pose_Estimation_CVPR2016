function mot=unwarpMotion(wp,skel,mot)

    % Invert Path
    wp_i=wp(:,[2 1]);
    % Warp
    mot=warpMotion(wp_i,skel,mot);
    
end