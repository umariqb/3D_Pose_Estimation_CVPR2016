function featuredata = BK_get_column_from_csv(mot,colName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function loads additional data for a motion, that are stored in a
% given CSV-file.
% 
% Possible call:
% featuredata=BK_get_column_from_csv(mot,colName);
%
% author: Björn Krüger (kruegerb@cs.uni-bonn.de)

if(isempty(mot.Labels)||isempty(mot.Data))
    % not all csv-Data are appended to the mot object 
    % -> Load from file and append
    [Labels,Data]=BK_load_csv(mot.csvFile);
    mot.Labels=Labels;
    mot.Data  =Data;
else
    % Get Data from mot object
    Labels=mot.Labels;
    Data  =mot.Data;
end

% Search asked column and return featuredata
column=strmatch(colName,Labels,'exact');
featuredata=Data(:,column);


