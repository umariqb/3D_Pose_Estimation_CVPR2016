function data = readH5acc(filename)

DEBUG = true;

info = h5info(filename);

nSensors = numel(info.Groups);

for i=1:nSensors
   fieldname = info.Groups(i).Name;
   fieldname = strrep(fieldname,'/','');
   fieldname = strrep(fieldname,'-','');
   
   data.sensor.(fieldname) = h5read(filename, ...
                                       [info.Groups(i).Groups(2).Name '/'  ...
                                        info.Groups(i).Groups(2).Datasets(3).Name]);
   
end

data.samplingRate = info.Groups(1).Attributes(1).Value;

if DEBUG

    figure();
    fields = fieldnames(data.sensor);
    for i=1:nSensors
        subplot(nSensors,1,i);
        plot(data.sensor.(fields{i})');
        grid on;
        title(['Sensor ' fields{i}]);
    end
    
    
    
end

end