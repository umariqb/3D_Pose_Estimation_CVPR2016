 % TEST_SPLIT tests the SPLIT function
% Last revision date: 08-Mar-2004

% raw data
data = 1:10;
assig1 = [1 1 NaN 5 5 3 3 1 3 5];
assig2 = [1 1 NaN 5 5 3 4 1 4 5];
names1 = {'up_1','up_3','up_5'};
names2 = {'up_1','up_3','up_4','up_5'};

% grouping
gr = grouping(assig1,names1,assig2,names2);
clear assig1 names1 assig2 names2

% variable
vr = variable('name','test','data',data,'level','numerical');
clear data

% vsmatrix
ds = dataset('name','testing split','variables',vr,'samples',...
    {'s1','s2','s3','s4','s5','s6','s7','s8','s9','s10'},...
    'labeling',gr);
clear gr vr
dm = getmatrix(ds,1,'all',{1});

% split
%[train test]=split(dm,'fraction',0.875);
%[train test]=split(dm,'specific',[1 4 5 6 8 10]);
%[train test]=split(dm,'no_samples',3);
[train test]=split(dm,'specific',[4:7 9:10]);