function outJ = getShapeJointNum(inJ,inputDB)
switch inputDB
    case 'Human80K'
        if(isnumeric(inJ))
            switch inJ
                case 17
                    outJ = 'pose';                                             % pose 14/upper 10/lower 6/left 8/right 8/ 5 / 9 / 11 / 14
                case 13
                    outJ = 'upper';
                case 7
                    outJ = 'lower';
                case 11
                    outJ = 'left/right';
                    disp('Please identify left or right part');
                otherwise
                    disp('Select right joints number');
            end
        else
            switch inJ
                case 'pose'
                    outJ = 17;                                             % pose 14/upper 10/lower 6/left 8/right 8/ 5 / 9 / 11 / 14
                case 'upper'
                    outJ = 13;
                case 'lower'
                    outJ = 7;
                case 'left'
                    outJ = 11;
                case 'right'
                    outJ = 11;
                otherwise
                    outJ = 17;
            end % switch else
        end % if
    case {'HumanEva', 'Human36Mbm','JHMDB','LeedSports'}
         if(isnumeric(inJ))
            switch inJ
                case 14
                    outJ = 'pose';                                             % pose 14/upper 10/lower 6/left 8/right 8/ 5 / 9 / 11 / 14
                case 10
                    outJ = 'upper';
                case 6
                    outJ = 'lower';
                case 8
                    outJ = 'left/right';
                    disp('Please identify left or right part');
                otherwise
                    disp('Select right joints number');
            end
        else
            switch inJ
                case 'pose'
                    outJ = 14;                                             % pose 14/upper 10/lower 6/left 8/right 8/ 5 / 9 / 11 / 14
                case 'upper'
                    outJ = 10;
                case 'lower'
                    outJ = 6;
                case 'left'
                    outJ = 8;
                case 'right'
                    outJ = 8;
                otherwise
                    outJ = 14;
            end % switch else
        end % if
end
end