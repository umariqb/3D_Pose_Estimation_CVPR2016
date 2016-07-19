function buttons = MPPbuttons()

goto_First = [...
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
0    0    nan  nan  nan  nan  nan  0    nan  nan  nan  nan  nan  0  
0    0    nan  nan  nan  nan  0    0    nan  nan  nan  nan  0    0  
0    0    nan  nan  nan  0    0    0    nan  nan  nan  0    0    0  
0    0    nan  nan  0    0    0    0    nan  nan  0    0    0    0  
0    0    nan  0    0    0    0    0    nan  0    0    0    0    0  
0    0    0    0    0    0    0    0    0    0    0    0    0    0  
0    0    0    0    0    0    0    0    0    0    0    0    0    0  
0    0    nan  0    0    0    0    0    nan  0    0    0    0    0  
0    0    nan  nan  0    0    0    0    nan  nan  0    0    0    0  
0    0    nan  nan  nan  0    0    0    nan  nan  nan  0    0    0  
0    0    nan  nan  nan  nan  0    0    nan  nan  nan  nan  0    0  
0    0    nan  nan  nan  nan  nan  0    nan  nan  nan  nan  nan  0  ];

goto_Last = fliplr(goto_First);

play_reverse = [...
nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  nan  nan  nan  0    nan  nan
nan  nan  nan  nan  0    0    nan  nan
nan  nan  nan  0    0    0    nan  nan
nan  nan  0    0    0    0    nan  nan
nan  0    0    0    0    0    nan  nan
0    0    0    0    0    0    nan  nan
0    0    0    0    0    0    nan  nan
nan  0    0    0    0    0    nan  nan
nan  nan  0    0    0    0    nan  nan
nan  nan  nan  0    0    0    nan  nan
nan  nan  nan  nan  0    0    nan  nan
nan  nan  nan  nan  nan  0    nan  nan];

play = fliplr(play_reverse);

pause = [...
nan  nan  nan  nan  nan  nan  nan  nan
0    0    0    nan  nan  0    0    0  
0    0    0    nan  nan  0    0    0  
0    0    0    nan  nan  0    0    0  
0    0    0    nan  nan  0    0    0  
0    0    0    nan  nan  0    0    0  
0    0    0    nan  nan  0    0    0  
0    0    0    nan  nan  0    0    0  
0    0    0    nan  nan  0    0    0  
0    0    0    nan  nan  0    0    0  
0    0    0    nan  nan  0    0    0  ];


slower = [...
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  nan  nan  nan  0    nan  nan  nan  nan  nan  0  
nan  nan  nan  nan  0    0    nan  nan  nan  nan  0    0  
nan  nan  nan  0    0    0    nan  nan  nan  0    0    0  
nan  nan  0    0    0    0    nan  nan  0    0    0    0  
nan  0    0    0    0    0    nan  0    0    0    0    0  
0    0    0    0    0    0    0    0    0    0    0    0  
0    0    0    0    0    0    0    0    0    0    0    0  
nan  0    0    0    0    0    nan  0    0    0    0    0  
nan  nan  0    0    0    0    nan  nan  0    0    0    0  
nan  nan  nan  0    0    0    nan  nan  nan  0    0    0  
nan  nan  nan  nan  0    0    nan  nan  nan  nan  0    0  
nan  nan  nan  nan  nan  0    nan  nan  nan  nan  nan  0  ];

faster = fliplr(slower);

unlooped = [...
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0
0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0
0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0
0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0
0    0    nan  nan  0    0    0    0    nan  nan  0    0    0    0    nan  nan  0    0
0    0    nan  nan  0    0    0    0    nan  nan  0    0    0    0    nan  nan  0    0
0    0    nan  nan  0    0    0    0    nan  nan  0    0    0    0    nan  nan  0    0
0    0    nan  nan  0    0    0    0    nan  nan  0    0    0    0    nan  nan  0    0
0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0
0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0
0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0
0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0];


looped = [...
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  nan  nan  nan  0    0    0    nan  nan  nan  nan  nan  nan  0    0    0    nan  nan  nan  nan  nan
nan  nan  nan  nan  0    0    0    nan  nan  nan  nan  nan  nan  nan  nan  0    0    0    nan  nan  nan  nan
nan  nan  nan  0    0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0    0    nan  nan  nan
nan  nan  0    0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0    0    nan  nan
nan  0    0    0    nan  nan  0    0    0    0    nan  nan  0    0    0    0    nan  nan  0    0    0    nan
0    0    0    nan  nan  nan  0    0    0    0    nan  nan  0    0    0    0    nan  nan  nan  0    0    0  
0    0    0    nan  nan  nan  0    0    0    0    nan  nan  0    0    0    0    nan  nan  nan  0    0    0  
nan  0    0    0    nan  nan  0    0    0    0    nan  nan  0    0    0    0    nan  nan  0    0    0    nan
nan  nan  0    0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0    0    nan  nan
nan  nan  nan  0    0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0    0    nan  nan  nan
nan  nan  nan  nan  0    0    0    nan  nan  nan  nan  nan  nan  nan  nan  0    0    0    nan  nan  nan  nan
nan  nan  nan  nan  nan  0    0    0    nan  nan  nan  nan  nan  nan  0    0    0    nan  nan  nan  nan  nan];

quit = [...
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  nan  nan  nan  0    0    nan  nan  nan  nan  nan
nan  nan  nan  nan  nan  0    0    nan  nan  nan  nan  nan
nan  nan  0    nan  nan  0    0    nan  nan  0    nan  nan
nan  0    0    nan  nan  0    0    nan  nan  0    0    nan
0    0    nan  nan  nan  0    0    nan  nan  nan  0    0  
0    0    nan  nan  nan  0    0    nan  nan  nan  0    0  
0    0    nan  nan  nan  0    0    nan  nan  nan  0    0  
0    0    nan  nan  nan  nan  nan  nan  nan  nan  0    0  
nan  0    0    nan  nan  nan  nan  nan  nan  0    0    nan
nan  nan  0    0    nan  nan  nan  nan  0    0    nan  nan
nan  nan  nan  0    0    0    0    0    0    nan  nan  nan
nan  nan  nan  nan  0    0    0    0    nan  nan  nan  nan];

spread = [...
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  0    0    nan  nan  nan  nan  nan  0    0    nan  nan  nan  nan  nan  0    0    nan  nan
nan  0    0    0    0    nan  nan  nan  0    0    0    0    nan  nan  nan  0    0    0    0    nan
0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  
nan  0    0    0    0    nan  nan  nan  0    0    0    0    nan  nan  nan  0    0    0    0    nan
nan  nan  0    0    nan  nan  nan  nan  nan  0    0    nan  nan  nan  nan  nan  0    0    nan  nan
];

% spread = [...
% nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
% nan  0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0    nan
% 0    0    0    0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0    0    0  
% 0    0    0    0    nan  nan  nan  nan  0    0    nan  nan  nan  nan  0    0    0    0  
% 0    0    0    0    nan  nan  nan  0    0    0    0    nan  nan  nan  0    0    0    0  
% nan  0    0    nan  nan  nan  nan  0    0    0    0    nan  nan  nan  nan  0    0    nan
% nan  nan  nan  nan  nan  nan  nan  0    0    0    0    nan  nan  nan  nan  nan  nan  nan
% nan  nan  nan  nan  nan  nan  nan  nan  0    0    nan  nan  nan  nan  nan  nan  nan  nan];

coords = [...
nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   0     0     0     nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   0     0     0     0     0     nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan   0     nan   nan
nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan   0     0     nan
nan   nan   nan   nan   nan   nan   0     0     0     0     0     0     0     0     0  
nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan   nan   0     0     nan
nan   0     nan   nan   0     nan   nan   nan   nan   nan   nan   nan   0     nan   nan
nan   0     0     0     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   0     0     0     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   0     0     0     0     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan];

localcoords = [...
nan   nan   nan   nan   0     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   0     0     0     nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   0     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   0     nan   nan   0     nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   0     0     0     0     0     nan   nan   nan   nan   nan   nan
nan   nan   nan   0     nan   nan   nan   0     nan   nan   nan   nan   nan   nan   nan
nan   0     0     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   0     0     nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   nan   nan   0     0     0     nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   nan   nan   nan   0     nan   nan   0     nan   nan
nan   nan   nan   nan   nan   nan   nan   nan   nan   0     0     0     0     0     nan
nan   nan   nan   nan   nan   nan   nan   nan   0     nan   nan   nan   0     nan   nan
nan   nan   nan   nan   nan   nan   0     0     nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   0     0     nan   nan   nan   nan   nan   nan   nan];

sensorcoords = [...
nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   0     0     0     nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   nan   0     nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   nan   nan   nan   0     0     0     0     0     0     nan   nan   nan
nan   nan   nan   nan   nan   0     nan   0     nan   nan   0     0     nan   nan   nan
nan   nan   nan   nan   0     0     0     0     0     0     nan   0     nan   nan   nan
nan   nan   nan   nan   0     nan   nan   nan   nan   0     nan   0     nan   0     nan
nan   nan   nan   nan   0     nan   nan   nan   nan   0     0     0     0     0     0  
nan   nan   nan   nan   0     nan   nan   nan   nan   0     nan   0     nan   0     nan
nan   nan   nan   nan   0     nan   0     nan   nan   0     nan   0     nan   nan   nan
nan   nan   nan   nan   0     0     nan   nan   nan   0     0     nan   nan   nan   nan
nan   nan   nan   nan   0     0     0     0     0     0     nan   nan   nan   nan   nan
nan   nan   0     0     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   0     0     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan];

groundPlane = [...
nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
nan   nan   nan   0     0     0     nan   nan   nan   0     0     0     nan   nan   nan
nan   nan   nan   0     0     0     nan   nan   nan   0     0     0     nan   nan   nan
nan   nan   nan   0     0     0     nan   nan   nan   0     0     0     nan   nan   nan
0     0     0     nan   nan   nan   0     0     0     nan   nan   nan   0     0     0  
0     0     0     nan   nan   nan   0     0     0     nan   nan   nan   0     0     0  
0     0     0     nan   nan   nan   0     0     0     nan   nan   nan   0     0     0  
nan   nan   nan   0     0     0     nan   nan   nan   0     0     0     nan   nan   nan
nan   nan   nan   0     0     0     nan   nan   nan   0     0     0     nan   nan   nan
nan   nan   nan   0     0     0     nan   nan   nan   0     0     0     nan   nan   nan
0     0     0     nan   nan   nan   0     0     0     nan   nan   nan   0     0     0  
0     0     0     nan   nan   nan   0     0     0     nan   nan   nan   0     0     0  
0     0     0     nan   nan   nan   0     0     0     nan   nan   nan   0     0     0  ];

jointIDs = [...
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  nan  nan  0    0    0    0    nan  nan  nan  nan
nan  nan  nan  0    nan  nan  nan  nan  0    nan  nan  nan
nan  nan  0    nan  nan  0    0    nan  nan  0    nan  nan
nan  0    nan  nan  nan  0    0    nan  nan  nan  0    nan
0    nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0  
0    nan  nan  nan  nan  0    0    nan  nan  nan  nan  0  
0    nan  nan  nan  nan  0    0    nan  nan  nan  nan  0  
0    nan  nan  nan  nan  0    0    nan  nan  nan  nan  0  
nan  0    nan  nan  nan  0    0    nan  nan  nan  0    nan
nan  nan  0    nan  nan  0    0    nan  nan  0    nan  nan
nan  nan  nan  0    nan  nan  nan  nan  0    nan  nan  nan
nan  nan  nan  nan  0    0    0    0    nan  nan  nan  nan];

renderScene = [...
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  0  
0    0    0    0    0    0    0    0    0    0    0    0    nan  nan  nan  0    0    
0    0    0    0    0    0    0    0    0    0    0    0    nan  nan  0    0    0  
0    0    0    0    0    0    0    0    0    0    0    0    nan  0    0    0    0  
0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  
0    0    0    0    0    0    0    0    0    0    0    0    nan  0    0    0    0  
0    0    0    0    0    0    0    0    0    0    0    0    nan  nan  0    0    0  
0    0    0    0    0    0    0    0    0    0    0    0    nan  nan  nan  0    0  
nan  nan  nan  nan  0    0    0    0    nan  nan  nan  nan  nan  nan  nan  nan  0  
nan  nan  nan  0    0    0    0    0    0    nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  0    0    nan  0    0    nan  0    0    nan  nan  nan  nan  nan  nan  nan
nan  0    0    nan  nan  0    0    nan  nan  0    0    nan  nan  nan  nan  nan  nan
0    0    nan  nan  nan  0    0    nan  nan  nan  0    0    nan  nan  nan  nan  nan
];

exportFrame = [...
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
nan  nan  nan  nan  nan  nan  nan  nan  nan  0    0    0    0    0    0    0    0  
nan  nan  nan  nan  nan  nan  nan  nan  0    0    nan  nan  nan  nan  nan  0    0    
nan  nan  nan  nan  nan  nan  nan  0    nan  0    nan  nan  nan  nan  0    nan  0  
nan  nan  nan  nan  nan  nan  0    nan  nan  0    nan  nan  nan  0    nan  nan  0  
nan  nan  0    nan  nan  0    0    0    0    0    0    0    0    nan  nan  nan  0  
nan  nan  0    0    nan  0    nan  nan  nan  0    nan  nan  0    nan  nan  nan  0  
0    0    0    0    0    0    nan  nan  nan  0    nan  nan  0    nan  nan  nan  0  
nan  nan  0    0    nan  0    nan  nan  nan  0    0    0    0    0    0    0    0  
nan  nan  0    nan  nan  0    nan  nan  0    nan  nan  nan  0    nan  nan  0    nan
nan  nan  nan  nan  nan  0    nan  0    nan  nan  nan  nan  0    nan  0    nan  nan
nan  nan  nan  nan  nan  0    0    nan  nan  nan  nan  nan  0    0    nan  nan  nan
nan  nan  nan  nan  nan  0    0    0    0    0    0    0    0    nan  nan  nan  nan
nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan  nan
];

rgb_dims = [1,1,3];

buttons.goto_First    = repmat(goto_First,rgb_dims);
buttons.goto_Last     = repmat(goto_Last,rgb_dims);
buttons.play_reverse  = repmat(play_reverse,rgb_dims);
buttons.play          = repmat(play,rgb_dims);
buttons.pause         = repmat(pause,rgb_dims);
buttons.slower        = repmat(slower,rgb_dims);
buttons.faster        = repmat(faster,rgb_dims);
buttons.unlooped      = repmat(unlooped,rgb_dims);
buttons.looped        = repmat(looped,rgb_dims);
buttons.quit          = repmat(quit,rgb_dims); %#ok<UNRCH>
buttons.spread        = repmat(spread,rgb_dims);
buttons.renderScene   = repmat(renderScene,rgb_dims);
buttons.exportFrame   = repmat(exportFrame,rgb_dims);
buttons.coords        = repmat(coords,rgb_dims);
buttons.localcoords   = repmat(localcoords,rgb_dims);
buttons.sensorcoords  = repmat(sensorcoords,rgb_dims);
buttons.groundPlane   = repmat(groundPlane,rgb_dims);
buttons.jointIDs      = repmat(jointIDs,rgb_dims);