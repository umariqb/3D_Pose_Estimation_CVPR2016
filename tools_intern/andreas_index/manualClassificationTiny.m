function [ classification ] = manualClassificationTiny()

%%%%%%%%%%%%%%%%%%% classification for HDM05 documents:
newClassInfo = struct('cartwheel', 1, 'grabDepR', 2, 'kick', 3, ...
                                     'move', 4, ...
                                     'punch', 5, 'rotateArms', 6,  'sitLieDown', 7, ...
                                     'standUp', 8, 'throwR', 9, 'jump', 10, 'hopOneLeg', 11, ...
                                     'neutral', 12, 'tpose', 13, 'others', 14, 'exercise', 15, 'turn', 16);


                                
idx = 1;

classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep 'HDM_bd_01-01_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...                                     
    []; ... %cartwheel
    [ ]; ... %grabDepositR
    [; ]; ... %kick
    [231 500; 670 1115; 1408 1882; 2622 3160; 3232 3505; 5967 6542; 6735 7387; 7625 8273; 8512 9098; 9336 9609; 3532 4465; 4466 4900; 5066 5730 ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    [ 2126 2390; 3120 3215; 4366  4487; 4877 5133; 5648 5834; 9098 9242;]; ... %neutral
    [1 120; 9670 9842 ]; ... %tpose
    [;  ]; ... %others
    [];... %exercise
    [147 253; 478 671; 1118 1344; 1888 2126; 2390 2642; 3181 3312; 5796 5967; 6540 6715; 7448 7623; 8305 8502; 9211 9418; ];... %turn
 }    ;                                  

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-01_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ ]; ... %grabDepositR
    [; ]; ... %kick
    [147 556; 667 1091; 1361 1836; 1919 2440; 2524 3240; 3286 3706;  3787 4327;  4639 5126; 5368 6017; 6212 6864; 7046 7581; ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    [2401 2530; 4328 4461; ]; ... %neutral
    [1 92; 7990 8091 ]; ... %tpose
    [;  ]; ... %others
    [];... %exercise
    [145 243; 469 658; 1176 1318; 4432 4647; 5143 5346; 5992 6226; 6835 7042; 7596 7777;  ];... %turn
 }    ;                                  

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-01_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ ]; ... %grabDepositR
    [; ]; ... %kick
    [302 679; 763 1208; 1382 1908; 1913 2364; 2445 3091; 3218 3621; 3850 4403; 4461 5037; 5205 5951; 6042 6824; 6922 7523; ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    [2350 2440; 3082 3218; 3645 3849;  ]; ... %neutral
    [1 224;   7819 7965]; ... %tpose
    [;  ]; ... %others
    [];... %exercise
    [307 449; 568 716; 1190 1346; 4380 4503; 5028 5198; 5880 6037; 6733 6899; 7493 7670;   ];... %turn
 }    ;         
                
idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-02_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ ]; ... %grabDepositR
    [; ]; ... %kick
    [172 456; 2514 2781]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    [513 575; ]; ... %neutral
    [1 126; 2782 2900]; ... %tpose
    [;  ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;   
 
                                                         
                             
idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-03_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ ]; ... %grabDepositR
    [; ]; ... %kick
    [259 598; 634 1134; 1381 1893; 1936 2397; 2570 2901; 3099 3516; 3618 3825;   ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    [  ]; ... %neutral
    [1 140; 3980 4025 ]; ... %tpose
    [;  ]; ... %others
    [];... %exercise
    [179 319; 488 635; 1141 1319; 1810 1985; 2394 2540; 2916 3099; 3564 3675;    ];... %turn
 }    ;                                                            
                             
                            
idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-03_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ ]; ... %grabDepositR
    [; ]; ... %kick
    [115 430; 479 994; 1185 1712; 1917 2288; 2496 2848; 3062 3415; 3521 3836;  ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    []; ... %neutral
    [3949 4089 ]; ... %tpose
    [;  ]; ... %others
    [];... %exercise
    [76 231; 342 502; 998 1188; 1731 1875; 2259 2448; 2870 3046; 3482 3620;  ];... %turn
 }    ;                      

                         
idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-03_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ ]; ... %grabDepositR
    [; ]; ... %kick
    [229 520; 614 1134; 1304 1802; 1960 2328; 2510 2910; 3152 3542; 3661 3944;    ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    []; ... %neutral
    [1 155; 4027 4166 ]; ... %tpose
    [;  ]; ... %others
    [];... %exercise
    [188 294; 455 611; 1175 1307; 1814 1969; 2327 2503; 2948 3129; 3633 3757; 3888 3950; ];... %turn
 }    ;                    

                        
idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-03_04_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ ]; ... %grabDepositR
    [; ]; ... %kick
    [258 540; 659 1168; 1354 1899; 1972 2348; 2532 2911; 3103 3491; 3634 3868;   ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    []; ... %neutral
    [1 191; 3946 4086 ]; ... %tpose
    [;  ]; ... %others
    [];... %exercise
    [236 361; 500 651; 1207 1378; 1834 1978; 2357 2505; 2922 3105; 3556 3676; ];... %turn
 }    ;                    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-04_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [275 501; 3168  3427;]; ... %grabDepositR
    [; ]; ... %kick
    [502 890; 1068 1494 ; 1904 2295; 2439 2867; 3500 3885; 4049 4444; 5012 5364; 5618  6011;  ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    [1576 1704; 3392 3490;  ]; ... %neutral
    [1 210; 6360 6461 ]; ... %tpose
    [1705 1856; 4732 4942;  ]; ... %others
    [];... %exercise
    [880 1075; 1464 1599; 2355 2486; 3888 4046; 4489 4656; 5413 5607; ];... %turn
 }    ;                         

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-04_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [153 457;   ]; ... %grabDepositR
    [; ]; ... %kick
    [ 468 847; 1053 1426; 1986 2357; 2581 3001; 3757 4145; 4402 4742; 5467 5835; 6085 6470;   ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    [ 3657 3742  ]; ... %neutral
    [1 175; 7026 7098 ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [856 1037; 1458 1608; 2394 2568; 4267 4372; 4795 5025; 5887 6080;   ];... %turn
 }    ;                         


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-04_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [157 411; 3188 3441;   ]; ... %grabDepositR
    [; ]; ... %kick
    [475 816; 1095 1425; 1969 2317;  2559  2890; 3497 3860;  4045 4369; 4913 5248; 5450 5844;    ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    [  ]; ... %neutral
    [1 156; 6312 6454 ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [682 1041; 1441 1603; 2338 2518; 3856 4038; 4429 4569; 5241 5419;  ];... %turn
 }    ;                         

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-04_04_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [189 407;   ]; ... %grabDepositR
    [; ]; ... %kick
    [465 807; 1107 1410;1809 2125; 2376 2707; 3373 3733; 3921 4244; 4614 4930; 5143 5548;     ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    []; ... %jump
    []; ... %hop1leg
    [  ]; ... %neutral
    [1 188; 5983 6117 ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [844 1056; 1418 1556; 2165 2330; 3775 3929; 4262 4416; 4948 5125; ];... %turn
 }    ;     




idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-05_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    []; ... %grabDepositR
    [; ]; ... %kick
    [224 582;  3075 3641  ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [2489 2868;3824 4023;  ]; ... %jump
    [652 1034; 1331 1652;]; ... %hop1leg
    [608 651;    ]; ... %neutral
    [1 142; 4352 4457 ]; ... %tpose
    [ ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;                         


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-05_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    []; ... %grabDepositR
    [; ]; ... %kick
    [293 566; 3237 3885;   ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [2551 3042; 3982 4234; ]; ... %jump
    [696 1071; 1308 1697;  ]; ... %hop1leg
    [  ]; ... %neutral
    [1 158; 4548 4655  ]; ... %tpose
    [ ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;                         

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-05_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    []; ... %grabDepositR
    [; ]; ... %kick
    [234 537; 3299 4081    ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [2698 3218; 4210 4457; ]; ... %jump
    [659 1030; 1290 1720;     ]; ... %hop1leg
    [  ]; ... %neutral
    [1 114; 4702 4851  ]; ... %tpose
    [ ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;             

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-05_04_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    []; ... %grabDepositR
    [; ]; ... %kick
    [192 612; 3294 3946;    ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [2654 3182; 4039 4316; ]; ... %jump
    [ 684 1101; 1364 1766;     ]; ... %hop1leg
    [  ]; ... %neutral
    [1 140; 4527 4633]; ... %tpose
    [ ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;            
 
  

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-05_05_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    []; ... %grabDepositR
    [; ]; ... %kick
    [271 564; 3268 3908;   ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [2642 3201; 3997 4284; ]; ... %jump
    [683 1072; 1390 1852;      ]; ... %hop1leg
    [  ]; ... %neutral
    [1 140; 4459 4518  ]; ... %tpose
    [ ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;            
 
   
  

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-06_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    []; ... %grabDepositR
    [; ]; ... %kick
    [250 1943; ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 130; 2029 2219]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [217 349; 1796 1967];... %turn
 }    ;                                   


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-06_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    []; ... %grabDepositR
    [; ]; ... %kick
    [119 1666 ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 61; 1768 1886]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [1590 1751];... %turn
 }    ;                    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_01-06_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    []; ... %grabDepositR
    [; ]; ... %kick
    [306 1766 ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 281; 1893 2046]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [1700 1859];... %turn
 }    ;           

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_02-01_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [813 1018; 1392 1673; 1863 2061; 2388 2739; 2992 3220;   ]; ... %grabDepositR
    [; ]; ... %kick
    [545 813; 1150 1391; 1674 1862; 2201 2387; 2740 3042; 3246 3452; ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 160; ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [196 285; 373 493; 1010 1162; 2090 2242; 3199 3306  ];... %turn
 }    ;                              

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_02-01_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [946 1137; 1456 1666; 1830 2048; 2457 2836; 3036 3288;     ]; ... %grabDepositR
    [; ]; ... %kick
    [297 521; 634 977; 1217 1467; 1694 1855;  2293 2490; 2782 3092;3311 3529  ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 197; 3571 3670  ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [257 314; 446 631; 1098 1230; 2082 2262; 3221 3374;  ];... %turn
 }    ;                              

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_02-01_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [1173 1329; 1524 1733; 1849 2020; 2347 2657; 2841 3027;    ]; ... %grabDepositR
    [; ]; ... %kick
    [668 899; 952 1244; 1375 1583; 1693 1902; 2177 2394; 2621 2904;  3095 3256    ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 272; 531 664; 3291 3457 ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [696 771; 808 947; 1277 1402; 2016 2169; 3019 3133;   ];... %turn
 }    ;               


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_02-02_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [742 964; 1614 1901; 2586 2864; 3608 3889; 4607 4876;  5613 5867;   ]; ... %grabDepositR
    [; ]; ... %kick
    [223 385; 544 791; 971 1310; 1381 1658; 1901 2258; 2331 2585; 2865 3210; 3362 3672; 4020 4266; 4359 4646; 4990  5218;  5357  5612; 5863 6136  ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 130; 6197 6324 ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [209 296; 353 512; 924 1051; 1258 1381; 1909 2000; 2190 2349; 2851 2986; 3219 3361; 3907 4020; 4235 4361; 4910 4999; 5278 5398; 5841 5971;       ];... %turn
 }    ;                   
 
idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_02-02_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [778 958; 1654 1903; 2582 2842; 3555  3803; 4517 4789; 5435 5717;   ]; ... %grabDepositR
    [; ]; ... %kick
    [204 451; 557 836; 959  1323; 1446 1724; 1914 2290; 2339 2734; 2851 3220; 3283 3622; 3861 4200; 4269 4604; 4768 5125; 5169 5518; 5684 5905]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 172; 5976 6080 ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [390 514; 901 1026; 1269 1406; 1871 1973; 2252 2395; 2825 2945; 3172 3314; 3806 3927; 4167 4297; 4742 4851; 5088 5226; 5644 5764;   ];... %turn
 }    ;              
 
idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_02-03_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [397 577; 615 861; 917 1138; 1183 1474; 1480 1791; 1808 2078;    ]; ... %grabDepositR
    [; ]; ... %kick
    [ 225  453; 2153 2377 ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [];...%[ 590 638; 871 911; 1165 1219; 1452 1532; 2070 2134;  ]; ... %neutral
    [1 187; 2418 2684  ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [ 2094 2240;];... %turn
 }    ;                             


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_02-03_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [294 502; 653 924; 986 1198; 1201 1502; 1619 1911; 1912 2155   ]; ... %grabDepositR
    [; ]; ... %kick
    [191 391; 2177 2386 ]; ... %move
    []; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 124; 2427 2539  ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [132 225; 2098 2233];... %turn
 }    ;                             


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-02_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [  ]; ... %grabDepositR
    [266 432; 486 651; 747 890; 915 1104; 1186 1344; 1345 1560; 1602 1758; 1778 1949;  ]; ... %kick
    [ ]; ... %move
    [2053 2203; 2305 2468; 2518 2651; 2693 2799; 2890 3064; 3065 3232; 3260 3387; 3425 3581;   ]; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [ ]; ... %neutral
    [ 1 131; 3869 3958  ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;             

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-02_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [  ]; ... %grabDepositR
    [267 414; 491 702; 773 943; 1043 1201; 1323 1451; 1455 1661; 1767 1924; 1930 2135;   ]; ... %kick
    [3645 3876 ]; ... %move
    [2208 2377; 2445 2636; 2687 2848; 2859 2989; 3061 3197; 3232 3358; 3405 3540; 3541 3682;  ]; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 170; 3956 4084  ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;              

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-02_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [  ]; ... %grabDepositR
    [ 219 451; 452 691; 692 900; 901 1138; 1224 1375; 1376 1528; 1651 1801; 1784 1978;    ]; ... %kick
    [3445 3659 ]; ... %move
    [2138 2283; 2345 2546; 2547 2680; 2681  2835; 2884 3030; 3075 3226; 3247 3473;   ]; %punch
    []; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 141; 3772 4046    ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;             


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-03_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [  ]; ... %grabDepositR
    [     ]; ... %kick
    [2570 2851;  ]; ... %move
    [ ]; %punch
    []; ... %rotateArms
    [259 485;  ]; ... %'sit
    [900 1139;  ]; ... %standUp
    [486 689; 690 887; 1203 1443; 1525 1746;]; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 210; 2978 3134  ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;             

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-03_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [  ]; ... %grabDepositR
    [     ]; ... %kick
    [2271 2569]; ... %move
    [ ]; %punch
    []; ... %rotateArms
    [170 423 ]; ... %'sit
    [862 1074; ]; ... %standUp
    [370 599; 654 837; 1073 1326;  1371 1620;]; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 124;  2633 2764  ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;             

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-03_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [  ]; ... %grabDepositR
    [     ]; ... %kick
    [2254 2510;  ]; ... %move
    [ ]; %punch
    []; ... %rotateArms
    [188 454;  ]; ... %'sit
    [860 1082; ]; ... %standUp
    [496 673; 674 858; 1123 1328; 1387 1574; ]; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 168; 2604 2765  ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;             


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-04_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [2015 2299; 2306 2705; 3563 3849; 4730 5203; 5412 5852; 5976 6128;    ]; ... %move
    []; %punch
    [103 919; 951 1897; 2306 2807; 3070 3435; 4730 5203; 5412 5852; ]; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [6195 6334;   ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [5215 5356; 5891 6046];... %turn
 }    ;                             

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-04_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [4051 4359; 4441  5033;  5171 5656; 5810 5998;  ]; ... %move
    []; %punch
    [335 718; 813 1189; 1278 1651; 1743 2170; 2218 2776; 2864 3298;4441 4883; 5171 5656; ]; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [ ]; ... %neutral
    [ 1 256; 6035 6190]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [4959 5089; 5679 5828];... %turn
 };            

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-04_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [3161 3507; 4417 4969; 5051 5546; 5656 5933;  ]; ... %move
    []; %punch
    [169 531; 684 1078; 1130 1523; 1605 1987; 2145 2524; 2632 3140; 4417 4837; 5106 5546;   ]; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 119; 5934 6126 ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [4879 5027; 5582 5738];... %turn
 }    ;                      

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-04_04_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [4085 4412; 4443 4983; 5107 5584; 5645 5938; ]; ... %move
    []; %punch
    [185 630; 660 1099; 1130 1587; 1669 2107; 2286 2802; 2827 3273; 4443 4839;  5107  5584;   ]; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [ ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 136; 5939 6073 ]; ... %tpose
    [  ]; ... %others
    [];... %exercise
    [4919 5041; 5538 5698];... %turn
 }    ;                      




idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-05_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move
    []; %punch
    [ ]; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [345 952;  ]; ... %jump
    [ ]; ... %hop1leg
    [952 1033; 1654 1760;  ]; ... %neutral
    [1 193; 3206 3316 ]; ... %tpose
    [1038 1647;  1777 2368; 2436 3067 ]; ... %others
    [1047 1644;  1766 2368; 2436 3067 ];... %exercise
    [];... %turn
 }    ;                             



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-05_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move
    []; %punch
    [ ]; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [232 845; ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 154; 3548 3707]; ... %tpose
    [ ]; ... %others
    [1728 2509; 2599 3319; ];... %exercise
    [];... %turn
 }    ;        

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-05_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move
    []; %punch
    [ ]; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    []; ... %throwR
    [193 807; ]; ... %jump
    [ ]; ... %hop1leg
    [1622 1757;  ]; ... %neutral
    [1 110; 3278 3458]; ... %tpose
    [ ]; ... %others
    [1826 2379;2501 3118;];... %exercise
    [];... %turn
 }    ;                       


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_03-11_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [ 1108 1334;1401 1765; ]; ... %move
    []; %punch
    [ ]; ... %rotateArms
    []; ... %'sit
    []; ... %standUp
    [350 575; 1820 1992; 3141 3338;   ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [635 949; 2362 2501;]; ... %neutral
    [1 169; 3951 4210 ]; ... %tpose
    []; ... %others
    [];... %exercise
    [];... %turn
 }    ;                             



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_04-01_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [ 331 593; 1293 1617; 1759 2017; 2694 3151; 3648 4004; 4051 4385; 4837  5376; 6180 6890; 7641 8418;  9646 10463; 11510 11700; ]; ... %move   
    []; %punch
    [ ]; ... %rotateArms
    [792 1047; 2207 2404; 5490 5840;  6958 7358; 8615 9162; 10555  11128;    ]; ... %'sit
    [1137 1292; 2533 2693; 5924 6167; 7376 7641; 9323 9658;  11093 11567 ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [ 721 791; 2145 2206; 3224 3639; 4572 4801; 5397 5489; 8520 8609; 10444 10586;     ]; ... %neutral
    [1 270; 11700 11844]; ... %tpose
    [8610 9200; 9283 9652; 10587 11173; 11216 11546;   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;                             


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_05-01_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move   
    []; %punch
    [ ]; ... %rotateArms
    [     ]; ... %'sit
    [  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [ 1705 1770;    ]; ... %neutral
    [1 632; 787 1189; 5785 5920]; ... %tpose
    [4090 4849; 4979 5554;     ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;                             


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_05-02_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move   
    []; %punch
    [ ]; ... %rotateArms
    [ 720 870;     ]; ... %'sit
    [ 1053 1215;  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [    ]; ... %neutral
    [1 148; 1618 1713]; ... %tpose
    [ 1237 1357; ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;                             


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_05-03_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    [2429 2784;]; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [ 183 458; 574 983; 1145 1851; 2009 2309;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [      ]; ... %'sit
    [  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [    ]; ... %neutral
    [1 137; 3119 3280 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [458 574; 996 1125; 1858 1977; 2303 2424; 2950 3053; ];... %turn
 }    ;                

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_05-03_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    [2533 2950; 3174 3550;]; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [212 552; 570 1077;1123 2015;  2132 2459; 3571 3855; ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [      ]; ... %'sit
    [  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [    ]; ... %neutral
    [1 163; 3860 3992]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [500 592; 979 1091; 1964 2096; 2426 2553; 3047 3227; ];... %turn
 }    ;                  

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_05-03_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    [2547 2914;  ]; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [156 498; 604 1052; 1163 1937; 2006 2318; 2428 2593; 2917 3279;  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [      ]; ... %'sit
    [  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [    ]; ... %neutral
    [1 123; 3343 3501]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [453 569 ; 999  1128; 1873 2039; 2330 2460;  3157 3306 ];... %turn
 }    ;           

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bd' filesep  'HDM_bd_06-01_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [1191 1349; 1574 1730; 1804  1970; 2100 2227; ]; ... %kick
    []; ... %move  
    [297 411; 471 562;  529 636; 594 781; 911 1021;  2356 2476; 2476 2587; 2670 2719; 2720 2761;]; %punch
    [ ]; ... %rotateArms
    [      ]; ... %'sit
    [  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [    ]; ... %neutral
    [1 102; 3020 3133 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [ ];... %turn
 }    ;           

     


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%        TR           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'tr' filesep  'HDM_tr_01-05_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [572 811;  3521 4012;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [ ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [2797 3463;4160 4453;   ]; ... %jump
    [1004 1363; 1564 1916; ]; ... %hop1leg
    [     ]; ... %neutral
    [1 419; 4696 4792 ]; ... %tpose
    [   ]; ... %others
    [   ];... %exercise
    [486 619; 757 876; 1359 1452; 1919 2034; 2638 2752; 3402 3495; 3986 4097; 4514 4610;   ];... %turn
 }    ;                            

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'tr' filesep  'HDM_tr_01-05_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [307 465; 3285 3822;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [ ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [2527 3095; 3883 4163;  ]; ... %jump
    [643 1128; 1287 1721;  ]; ... %hop1leg
    [  4164 4353;  ]; ... %neutral
    [1 172; 4498 4638 ]; ... %tpose
    [   ]; ... %others
    [   ];... %exercise
    [212 308; 467 563; 1084 1201; 1692 1827; 2381 2507; 3056 3176; 3772 3899; 4377 4485    ];... %turn
 }    ;                            

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'tr' filesep  'HDM_tr_01-05_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [446 698; 3221 3840;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [ ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [2573 3204; 3937 4391;    ]; ... %jump
    [849 1279; 1396 1835;      ]; ... %hop1leg
    [ 748 830;  ]; ... %neutral
    [1 311; 4446 4548 ]; ... %tpose
    [   ]; ... %others
    [   ];... %exercise
    [360 445; 654 774; 1247 1357; 1815 1919; 2489 2574; 3209 3291; 3803 3901; 4298 4406;   ];... %turn
 }    ;                 


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'tr' filesep  'HDM_tr_03-05_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [ ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [587 1177;   ]; ... %jump
    [ ]; ... %hop1leg
    [438 586; 1919  2249; 2940 3209; 4502 4686;     ]; ... %neutral
    [1 344;  4869 4999]; ... %tpose
    [   ]; ... %others
    [ 2260 2939; 3210 4315;    ];... %exercise
    [];... %turn
 }    ;                

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'tr' filesep  'HDM_tr_03-05_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [ ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [495 1078;    ]; ... %jump
    [ ]; ... %hop1leg
    [314 494; 1091 1284;  ]; ... %neutral
    [1 249; 4360 4500]; ... %tpose
    [   ]; ... %others
    [ 1994 2746; 3016  4104;   ];... %exercise
    [];... %turn
 }    ;          

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'tr' filesep  'HDM_tr_03-05_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [ ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [451 1067;    ]; ... %jump
    [ ]; ... %hop1leg
    [302 450; 1153 1260; 1888 2046;]; ... %neutral
    [1 262; 4307 4357 ]; ... %tpose
    [   ]; ... %others
    [2047 2718; 3017 4083;   ];... %exercise
    [];... %turn
 }    ;           


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'tr' filesep  'HDM_tr_04-01_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [ 420 634; 1290 1517; 1638 1924; 2560 2953;  3465  3730; 3851 4218; 4740 5316; 6159 6926; 7630 8305; 9291 9702 ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [791 1050;  2044  2294;  5317 5640;   6927 7262;  8320 8800; 9989 10353;   ]; ... %'sit
    [1119 1289; 2451 2583; 5850 6095;7339 7613; 8931 9225; 10489 10882;   ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [ 3013 3465; 4294 4739; 9843 9988;       ]; ... %neutral
    [1 273; 11022 11202]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [335 403; 580 704; 1518 1640; 1850 1988; 2875 3024; 3738 3816; 4151 4277;   ];... %turn
 }    ;                         



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'tr' filesep  'HDM_tr_05-02_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [631 1150;  ]; ... %'sit
    [1151 1332]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 240; 1593 1691 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;                           



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'tr' filesep  'HDM_tr_05-02_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [582 1138;  ]; ... %'sit
    [1139 1315]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 95; 1517 1726 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;                  

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'tr' filesep  'HDM_tr_05-02_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [598 1127;  ]; ... %'sit
    [1128 1328 ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 117; 1584 1705]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;                      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%        BK           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-01_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [ 256 545; 771 1243; 1603 2143;  2353 2938;3344 3772; 4015 4821; 5095 5751; 6780 7351;  7601 8229; 8691 9601; 9905 10110;   ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [ 2925 3344; 4780 5095; 5817 6699; 8244 8459; 9589 9796;  ]; ... %neutral
    [1 178; 10111 10283]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [1304 1496; 7391 7588; 8470 8683; 9820 9976;  ];... %turn
 }    ;                             


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-01_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [273 552; 692 1191; 1561 2106;  2283 2795; 3035 3799; 3805 4425; 4583 5283; 5422 6012; 6239 6850; 7315 8150; 8386 8579;   ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [1398 1560; 2094  2282; 2846 3034; 4430 4582;  ]; ... %neutral
    [1 241; 8625 8747 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [266 380; 498 593; 1219 1390; 6037 6213; 7072 7239; 8249 8378;  ];... %turn
 }    ;                             



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-01_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [247 490; 724 1255; 1405 2047; 2113 2727;  2905 3547; 3648 4400; 4478 5207; 5422 6061; 6316 7057; 7411 8390;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [8363 8493;   ]; ... %neutral
    [1 211; 8836 8969]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [1234 1403; 5357 5484; 6141 6311; 7228 7406; 8470 8620;  ];... %turn
 }    ;                          



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-03_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [229 544; 1331 1983; 2136 2695; 3707 4134; 5110 5562; 5717 6171;6237 6514   ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [762 1330; 2996 3295; 4663  5090;   ]; ... %neutral
    [1 175; 6588 6707 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [503 627; 1910 2164; 2790 2880; 4543 4737; 5512 5680;  ];... %turn
 }    ;                          

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-03_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [514 1056; 1450 2022; 2032 2399; 2680 3065; 3508 4204; 4328 4780; 4981  5431; 5679 5978;       ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [1295 1447;  2510 2640;  ]; ... %neutral
    [1  168; 6031 6211]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [1066 1254; 2356 2516; 3257 3431; 4117 4240; 4724 4835; 5668 5759;    ];... %turn
 }    ;    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-03_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [645 1132; 1386  1906; 1975 2258; 2490 2803;  3308 3767; 4019  4489; 4572 4900;  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [423 644; 2293 2489;  ]; ... %neutral
    [1 269; 4980 5115]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [1192 1349; 2191 2339 ; 3076 3221; 3807 3953; 4552 4674; 4842 4958;   ];... %turn
 }    ;    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-03_04_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [355 794; 1017 1528; 1617 1890; 2088 2431; 2775 3215; 3456 3883; 3987 4338;      ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 224; 4439 4562 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [806 989; 1859 1990; 2603 2729; 3266 3435; 3984  4093;   ];... %turn
 }    ;    


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-03_05_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [355 862; 996 1512; 1547 1816; 1948 2357; 2775 3227; 3415 3942; 4018 4244;         ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [ ]; ... %neutral
    [1 171; 4350 4467 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [846 1010; 1762 1844; 2520 2676; 3235 3341; 3949 4067; 4166 4261;  ];... %turn
 }    ;    


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-04_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [231  456; 3867 4180; 7050 7471;   ]; ... %grabDepositR
    [; ]; ... %kick
    [503 943; 1223 1633; 2241 2599; 2974  3359;  4322 4816; 5032 5362; 6044 6409; 6690 7053  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [2027 2218; 2582 2746; 5945 6035; ]; ... %neutral
    [1 192; 7550 7677]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [1007 1162; 1678 1822; 2705 2926; 4765 4954; 5492 5692; 6500 6681;   ];... %turn
 }    ;    



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-04_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ 277 511; 3377 3911;  ]; ... %grabDepositR
    [; ]; ... %kick
    [685 1091; 1411 1753; 2192 2541; 2858 3226; 4028 4403; 4748 5108; 5588 6115; 6282 6635; 6781 7037;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 160; 7618 7752]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [1125 1312; 1821 1975; 2599 2788; 4425 4587; 5347 5488; 6079 6231; 6618 6802; 7431 7576; ];... %turn
 }    ;    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-04_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [220 427; 3099 3472; 6004 6369;     ]; ... %grabDepositR
    [; ]; ... %kick
    [525 897; 1129 1522; 1896 2248; 2503 2877; 3572 3987; 4275 4604; 5017 5354; 5626 6032;      ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [ ]; ... %neutral
    [1 196; 6578 6722 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [897 1066; 1563 1742; 2229 2444; 4047 4233; 4701 4978; 5443 5582; ];... %turn
 }    ;    


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-06_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [291 1435; 1884 2744;      ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 164; 2792 2964]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [1473 1799; ];... %turn
 }    ;    


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-06_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [281 2787;  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 225; 2249 2345 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-06_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [238  2008 ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1  185; 2038 2222]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_01-06_04_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [232 1934;  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 204; 2003 2117]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_04-01_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [ 604 1065; 1768 2389; 3043 3359; 3845 4682; 5074  5727; 6621 7301; 8305 9017; 10323 10980; ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [1065 1415; 2405 2755; 5651 6093; 7209 7822; 8986  9718; 10980 11774;     ]; ... %'sit
    [1532 1768; 2867 3076; 6250 6621; 7927 8334; 9820 10334; 11847 12366;  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [     ]; ... %neutral
    [1 397; 12493 12640 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [1025 1121; 2349 2458; 3312 3632; 4595 4718; ];... %turn
 }    ;    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'bk' filesep  'HDM_bk_05-02_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [1258  1694; 2948 3478;    ]; ... %'sit
    [1695 1934; 3479 3655;  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [2000 2120; 2730 2930    ]; ... %neutral
    [1 179; 3967 4163]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%        DG           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_02-01_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ 597 806;  987 1240; 1407 1617; 1907 2215; 2410 2582;   ]; ... %grabDepositR
    [; ]; ... %kick
    [ 156 674; 807  1057; 1203 1474; 1770 1961; 2210 2491; 2581 2814; ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 130; 2869 3034 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [289 403 ; 810 893; 1609 1775; 2561 2709; 2750 2821;  ];... %turn
 }    ;    


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_02-01_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [574 863; 991 1295; 1603 1887; 2318 2682; 2862 3078;   ]; ... %grabDepositR
    [; ]; ... %kick
    [175 703;840 1083; 1319  1626; 2127 2420; 2632 2862;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 92; 3433 3526;]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [221 383; 801 947; 1864 2053; 3022 3170; 3250 3400];... %turn
 }    ;    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_02-01_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [491 664; 871 1157; 1380 1629; 1938 2278; 2461 2674;     ]; ... %grabDepositR
    [; ]; ... %kick
    [274 558; 661 954; 1147 1469; 1683 1991; 2250 2506;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 191; 2902 3108 ]; ... %tpose
    [   ]; ... others
    [];... %exercise
    [216 350; 629 794; 1620 1775; 2636 2767; ];... %turn
 }    ;    



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_02-02_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ 731 978; 1674  1894; 2615 2833; 3451 3682; 4446 4710; 5321 5556;   ]; ... %grabDepositR
    [; ]; ... %kick
    [239 801; 1015 1685; 1960 2614; 2837  3451; 3780  4491; 4679 5360; 5557  5907;  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 204; 5993 6087]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [408 509; 953 1080; 1320 1431; 1932 2046; 2813 2926;  3752 3867; 4689 4804; 5547 5691; 5760 5874; ];... %turn
 }    ;    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_02-02_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [ 723  1053; 1341 1479;  1971 2122;  ]; ... %grabDepositR %this doc contains grabDepositL
    [; ]; ... %kick
    [ 278 438; 564 799; 1054 1340; 1700 2013; 2147  2324; 2446 2655   ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 255; 4091 4198]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [497 605; 980 1119; 1560 1700; 2059 2186; 2293 2429; 2985 3131; 3190 3309; ];... %turn
 }    ;    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_02-02_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [751 919; 1356 1552; 2038 2270; 2724 2931; 3452 3641; 4119 4320;     ]; ... %grabDepositR
    [; ]; ... %kick
    [379  791; 912 1093; 1221 1440; 1581 1753; 1886 2091; 2243 2446; 2564 2769; 2888 3144; 3296 3496; 3604 3834; 3990 4189; 4353 4549; ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 262; 4667 4750;]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [860 946; 1093 1219; 1511 1601; 1741 1877; 2185 2279; 2447 2574; 2854 2998; 3123 3279; 3571 3681; 3813 3974; 4308 4382;4398 4508;  ];... %turn
 }    ;    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_02-02_04_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [698 908; 1535 1737; 2297 2542; 3114 3308; 3931 4148; 4795 4960;    ]; ... %grabDepositR
    [; ]; ... %kick
    [477 748; 942 1162; 1302 1540; 1762 2009; 2117 2349; 2495 2766; 2787 3114; 3302 3559; 3701 3964; 4117 4416; 4571 4816; 4932 5253;  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 232; 5367 5461 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [261 367; 891 1041; 1156 1291; 1712 1835; 1982 2108; 2469 2588; 2722 2865; 3286 3406; 3583 3693; 4149 4257; 4415 4542; 4906 5046; ];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_02-03_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [561 953; 957 1230; 1231 1418; 1452 1689 ; 1690 1876;       ]; ... %grabDepositR
    [; ]; ... %kick
    [ 316 554;]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 147;2315 2436 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [221 323; 1944 2077; 2109 2210];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_02-03_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [329 523; 639 908; 964 1274; 1347 1650; 1780 2087; 2184 2468;      ]; ... %grabDepositR
    [; ]; ... %kick
    [88 372;   ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [1650 1779; 2097 2174;  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [103 228; 2538 2819;  ];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_02-03_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [419 722; 754 1185; 1301 1686;      ]; ... %grabDepositR
    [; ]; ... %kick
    [249 493;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [1196 1300; 1688 1788;    ]; ... %neutral
    [1 156; 2114 2225]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [215 330; 1803 2085; ];... %turn
 }    ;    



idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_03-02_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [403 650; 766 1052; 1146 1460 ; 1523 1818; 1938 2210; 2379 2624; 2761 2992; 3104 3354;   ]; ... %kick
    [6264 6675;  ]; ... %move  
    [3564 3725; 3941 4127; 4305 4489; 4663 4857; 5038 5231; 5403 5640; 5732 5911; 6051 6290;  ]; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 138; 6704 6823]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    



idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_03-02_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [368 818; 925 1220; 1446 1641; 1642 1803; 2106 2261; 2262 2412;  2657 2848; 2849 3015;     ]; ... %kick
    [162 367; 3041 3257; 5480 5630   ]; ... %move  
    [3445 3690; 4077 4249; 4591 4777; 5085 5299;   ]; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 123; 5622 5861]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_03-02_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [368 597; 682 989; 1116 1255; 1256 1419; 1489 1799;   ]; ... %kick
    [  ]; ... %move  
    [1974 2195; 2316 2541; 2608 2835; 2882 3100;  ]; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 206; 3251 3454]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_03-04_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [4715 5066; 5238 5861; 5998 6577; 6669 6960;   ]; ... %move  
    []; %punch
    [316 684; 829 1187; 1288 1711; 1886 2234; 2624 3185; 3254  3623; 5238 5772; 6055 6531;  ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 155; 6994 7101]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [5820 5975; 6582 6731; ];... %turn
 }    ;    

idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_03-04_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [4202 4529; 4691 5226; 5400 5946; 6067 6268 ]; ... %move  
    []; %punch
    [258 645; 722 1161; 1259 1687; 1761 2180; 2246 2783; 2889 3223; 4724 5140; 5400 5837;   ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 122; 6268 6444]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [5156 5347; 5890 6067; ];... %turn
 }    ;    








idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_05-03_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    [2306  2692]; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [217 550; 610 1038; 1088 1800; 1887 2126;     ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 184; 3143 3276 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [458 569; 1015 1154; 1745 1889; 2167 2282; 2772 2958;  ];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'dg' filesep  'HDM_dg_05-03_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    [2435 2888]; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [185 454; 582 958; 1064 1670; 1884 2151;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 122; 3302 3425]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [374 561; 972 1133; 1644 1793; 2193 2355; 2882 3007; 3085 3190;   ];... %turn
 }    ;    




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%        MM           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'mm' filesep  'HDM_mm_01-05_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [185 456; 3393 3933;   ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [   ]; ... %'sit
    [ ]; ... %standUp
    [  ]; ... %throwR
    [2672 3202; 4030 4365;   ]; ... %jump
    [625 999; 1254 1647;   ]; ... %hop1leg
    [1780 1957;   ]; ... %neutral
    [1 132; 4630 4673 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [161 280; 414 544; 1017 1164; 1630 1799; 2477 2623; 3221 3356; 4391 4475; ];... %turn
 }    ;    



idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'mm' filesep  'HDM_mm_03-03_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [2476 2781;   ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [ 235 522;   ]; ... %'sit
    [ 1135 1427;  ]; ... %standUp
    [581 874; 934 1173; 1465 1776; 1818 2106;    ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [    ]; ... %neutral
    [1 202; 3757 3900 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'mm' filesep  'HDM_mm_03-03_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [ 2966 3178;   ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [265 560;   ]; ... %'sit
    [1283 1592;  ]; ... %standUp
    [561 958; 1006 1334; 1543 1948; 2012 2395;     ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [4181 4299    ]; ... %neutral
    [1 247;  ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'mm' filesep  'HDM_mm_03-05_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [ ]; ... %standUp
    [    ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [    ]; ... %neutral
    [1894 1994  ]; ... %tpose
    [   ]; ... %others
    [36 305;  461 906; 1058 1730; ];... %exercise
    [];... %turn
 }    ;    



idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'mm' filesep  'HDM_mm_03-05_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [ ]; ... %standUp
    [    ]; ... %throwR
    [514 1121;    ]; ... %jump
    [ ]; ... %hop1leg
    [   ]; ... %neutral
    [1 328; 4210 4290 ]; ... %tpose
    [   ]; ... %others
    [1336 2181; 2317 2938; 3090 4082; ];... %exercise
    [];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'mm' filesep  'HDM_mm_03-05_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [ ]; ... %standUp
    [    ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [    ]; ... %neutral
    [1 242; 3316 3485 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'mm' filesep  'HDM_mm_04-01_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [529 1004; 1620 2515; 3312 3989; 4584  5398; 6001 6538; 7194 8008; 8699 9427; 10542 11364;    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [1037  1305; 2629 3073; 6538 6965; 7973 8484; 9363 10130; 11324 12004;   ]; ... %'sit
    [1420 1620; 3074 3311; 6966 7228; 8485 8765; 10131 10604; 12005 12402; ]; ... %standUp
    [    ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [4220 4504; 5770 5877    ]; ... %neutral
    [1 506; 12681 12894  ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [3903 4131; 5345 5500; ];... %turn
 }    ;    



idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'mm' filesep  'HDM_mm_04-01_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [423 738; 1053 1677; 2010 2359; 2575 3179; 3356 3759; 4095 4634; 5037 5544; 6066 6536; 7131 7386;     ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [738 915; 1678 1837; 3456 3956; 4635 4827; 5548 5813; 6536 6870;  ]; ... %'sit
    [916 1052; 1837 2009; 3957 4218; 4846 5011; 5816 6065; 6889 7131;  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [2442 2538; 3243 3355;   ]; ... %neutral
    [1 386; 7486 7535 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [2347 2434; 3142 3236;  ];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'mm' filesep  'HDM_mm_05-02_01_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [1103 1785;   ]; ... %'sit
    [1786 2007;  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 318; 2352 2428 ]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    


idx = idx + 1;
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'mm' filesep  'HDM_mm_05-02_02_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [     ]; ... %grabDepositR
    [; ]; ... %kick
    [    ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [1088 1736;   ]; ... %'sit
    [1737 2029;  ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [  ]; ... %neutral
    [1 297; 2334 2428]; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%        C M U        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                           
idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_01_jumping_01forwardMultiple+_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [165 302; 352 521; 539 662; 717 898; 1219 1363; 1491 1624; 1712 1859; 2127 2291; 2378 2502; 2577 2723;    ]; ... %jump
    [ ]; ... %hop1leg
    [     ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [1009 1194; 1964 2095; ];... %turn
 }    ;  

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_02_martial_05punchStrike_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    [1 1854]; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [  ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
};

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_03_walking_04unevenTerrain_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [ ]; ... %kick
    [1 4722   ]; ... %move  
    [ ]; %punch
    []; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [    ]; ... %jump
    [  ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [ ];... %exercise
    [1202 1289; ];... %turn
 }    ;        
    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_08_walking_04slow_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [ ]; ... %kick
    [1 484]; ... %move  
    [ ]; %punch
    []; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [    ]; ... %jump
    [  ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [ ];... %exercise
    [ ];... %turn
 }    ;        

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_15_walking_01wander_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [ ]; ... %kick
    [1 470; 601 1280;  1521 2050; 2190 2920; 3221 3980; 4120 4780; 4910 5524   ]; ... %move  
    [ ]; %punch
    []; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [    ]; ... %jump
    [  ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [ ];... %exercise
    [471 600; 1281 1420; 2050 2200; 3020 3220; 3980 4120; 4780 4910];... %turn
 }    ;        

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_17_walking_05hobbleNavigate_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [ ]; ... %kick
    [1 6339   ]; ... %move  
    [ ]; %punch
    []; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [    ]; ... %jump
    [  ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [ ];... %exercise
    [];... %turn
 }    ;        



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_17_sneaking_03_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [ ]; ... %kick
    [1 6353]; ... %move  
    [  ]; %punch
    []; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [   ]; ... %jump
    [  ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [ ];... %exercise
    [];... %turn
 }    ;        



idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_38_running_03circle_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [ ]; ... %kick
    [1 761]; ... %move  
    [  ]; %punch
    []; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [   ]; ... %jump
    [  ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [ ];... %exercise
    [];... %turn
 }    ;    

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_47_walking_01forwardTurnBack_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [ ]; ... %kick
    [39 1288]; ... %move  
    [  ]; %punch
    []; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [   ]; ... %jump
    [  ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [ ];... %exercise
    [];... %turn
 }    ;    


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_49_cartwheel_08twoTimes_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    [1 575]; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [  ]; ... %jump
    [ ]; ... %hop1leg
    [     ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;                


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_49_jumping_02upward+oneFoot_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [ 105 944; 1913 2085    ]; ... %jump
    [ 945 1901;  ]; ... %hop1leg
    [1 104     ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;        


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_49_jumping_03upward+oneFoot_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [; ]; ... %kick
    [  ]; ... %move  
    []; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [91 458; 915 1504   ]; ... %jump
    [459 880;  ]; ... %hop1leg
    [1 90;      ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [];... %turn
 }    ;        

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_56_vignettes_06punchGrabSkipYawnStretchLeapLiftWalkJump_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [ ]; ... %kick
    [ 1235 1744; 3302 3509; 3657 4845; 5491 5845; 6103 6385; 6548 6784;    ]; ... %move  
    [ 337 924; 2789 2960 ]; %punch
    []; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [2159 2408;   ]; ... %throwR
    [2565 2803; 4966 5259; 6386 6579;    ]; ... %jump
    [  ]; ... %hop1leg
    [ 1 292; 2409 2564; 5832 6007;  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [ ];... %exercise
    [2926 3037; 3452 3638; 4204 4308; 4470 4544; 5403 5527; 6014 6145; 6295 6413; 6720 6748 ];... %turn
 }    ;        

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_86_mixed_01walkingJumpingMartial_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [3196 3496; 3522 3771; 3805 4070;   ]; ... %kick
    [ 28 484; 1299 1979; 2527 3142;   ]; ... %move  
    [ 2000 2502; 4092 4579 ]; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [516 1184;   ]; ... %jump
    [  ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [];... %exercise
    [417 553; 1156 1303; 1782 1967; 3084 3263; ];... %turn
 }    ;        

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_86_mixed_02walkingJumpingMartial_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [  ]; ... %kick
    [ 1 985; 1873  2719; 4683 5942; 9629  10617   ]; ... %move  
    [ 8840 9628;  ]; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [5943 7239;   ]; ... %jump
    [  ]; ... %hop1leg
    [2720 3165;  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [ 986 1872; ];... %exercise
    [342 522; ];... %turn
 }    ;        

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_86_mixed_03walkingJumpingMartial_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [ 3405 4693;   ]; ... %kick
    [ 1 1931; 2419 3404;  7082 8401  ]; ... %move  
    [  ]; %punch
    [6237 7076;  ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [ 1932 2418;   ]; ... %jump
    [ 4694  6180; ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [  ];... %exercise
    [];... %turn
 }    ;        

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_86_mixed_05walkingJumpingMartial_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [  ]; ... %kick
    [1 788; 3909 4593; 7350 8340 ]; ... %move  
    [4536 5899;    ]; %punch
    []; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [789 1577; 1578 2284; 2307  2866;    ]; ... %jump
    [3284 3908; ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [  ];... %exercise
    [2857 2959; ];... %turn
 }    ;        


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_86_mixed_06walkingJumpingMartial_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [3190 3339;  3448 3606; 3717 3904;   ]; ... %kick
    [1 981; 1595 2534; 8913 9939;]; ... %move  
    [ 3954 4159; 4171 4347; 4380 4544;]; %punch
    [ ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [     ]; ... %jump
    [ ]; ... %hop1leg
    [1093 1581; 2676 3134;   ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [  ];... %exercise
    [955 1111;];... %turn
 }    ;        


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_86_mixed_07walkingJumpingMartial_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [  ]; ... %kick
    [1 1098; 6040 8702 ]; ... %move  
    [   ]; %punch
    [1910 2532; 3678 4425;  ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [ 5202 5807;    ]; ... %jump
    [ 4478 5106; ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [  ];... %exercise
    [ 5929 6061;  ];... %turn
 }    ;        


idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_86_mixed_08walkingJumpingMartial_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [3963 4714; ]; ... %kick
    [1 1109; 8147 9206; 4808 5683;]; ... %move  
    [ 7137 8103;   ]; %punch
    [2716 3407; ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [   ]; ... %jump
    [  ]; ... %hop1leg
    [3460 3947; 5741 6335;  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [1110 1884;  ];... %exercise
    [  ];... %turn
 }    ;        

idx = idx + 1;                                 
classification(idx).filename = [filesep 'HDM05_CMU_EG08_tiny' filesep 'cmu' filesep  'CMU_86_mixed_11walkingJumpingMartial_120.amc'];
classification(idx).classInfo = newClassInfo;
classification(idx).classification = {...
    []; ... %cartwheel
    [   ]; ... %grabDepositR
    [ ]; ... %kick
    [1 1182; 4613 5674]; ... %move  
    [  ]; %punch
    [1183 4612; ]; ... %rotateArms
    [  ]; ... %'sit
    [   ]; ... %standUp
    [  ]; ... %throwR
    [   ]; ... %jump
    [  ]; ... %hop1leg
    [  ]; ... %neutral
    []; ... %tpose
    [   ]; ... %others
    [ ];... %exercise
    [];... %turn
 }    ;        

  

