function mot_new = doOptim( skel, mot, iterations )

mot_new = skelfit(skel, mot, 1000, 1000, iterations);
mot_new.jointTrajectories = test_fK_Quat_frame(mot_new, skel, 1);
animate(skel, mot_new, 1, 0.5, [1:1]);