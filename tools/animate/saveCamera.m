function saveCamera(varargin)

ax = gca;
file = 'camera.m';
if (nargin>1)
    file = varargin{2};
end
if (nargin>0)
    ax = varargin{1};
end

[fid,msg]=fopen(file,'w');
if (fid < 0)
    disp(msg);
    return;
end

fprintf(fid,'function camera(axs)\n\n');
fprintf(fid,'set(gca,''CameraPosition'', [%s],...\n',num2str(get(ax,'CameraPosition')));
fprintf(fid,'        ''CameraPositionMode'',''manual'',...\n');
fprintf(fid,'        ''CameraTarget'', [%s],...\n',num2str(get(ax,'CameraTarget')));
fprintf(fid,'        ''CameraTargetMode'',''manual'',...\n');
fprintf(fid,'        ''CameraUpVector'', [%s],...\n',num2str(get(ax,'CameraUpVector')));
fprintf(fid,'        ''CameraUpVectorMode'',''manual'',...\n');
fprintf(fid,'        ''CameraViewAngle'', [%s],...\n',num2str(get(ax,'CameraViewAngle')));
fprintf(fid,'        ''CameraViewAngleMode'',''manual'');');
fclose(fid);