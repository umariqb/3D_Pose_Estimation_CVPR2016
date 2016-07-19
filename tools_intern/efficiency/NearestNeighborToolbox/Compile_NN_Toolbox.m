function Compile_NN_Toolbox()

    % get list of src files to compile
    listOfcpp=wildcardDir('src/*.cpp');
    
    switch mexext
        
        case 'mexa64'
            % We are working on Linux. Don't use libs coming with Matlab,
            % this will cause version problems with libstdc++
           % if ~isempty(getenv('GCC'))
                mex('-Iinclude','-v', '-f','./mexopts.sh','nn_wrapper.cpp', listOfcpp{:});
           % else
           %    fprintf('\n Set enviroment variable $GCC to gcc install Dir\n\n');
           % end
        otherwise
            mex('-Iinclude', 'nn_wrapper.cpp', listOfcpp{:}); 
    end
end