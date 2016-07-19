 %% Compile the source codes 
    currentDir = pwd;
    cd('../MEX/src/');
    if ~exist('build', 'dir')
    	% Build directory does not exists...build the project 
        mkdir('build');
        cd('build');
        system('cmake -G"Unix Makefiles" ..');
        system('make');
    end
    cd(currentDir);
