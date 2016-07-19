function filename=convertfilenames(oldname)

% Check if we are on Win or Uix

if(filesep=='/')
    %We are on Unix
    filename=strrep(oldname,'\',filesep);
else
    %We are in Win
    filename=strrep(oldname,'/',filesep);
end
