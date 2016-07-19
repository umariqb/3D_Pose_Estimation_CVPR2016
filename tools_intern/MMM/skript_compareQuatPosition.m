path='M:\HDM_DB\HDM05_SmallDB\cut_amc';

TENSPosition=buildTensorsFromSubDirs(path,false,'Position');
TENSQuat    =buildTensorsFromSubDirs(path,false,'Quat');
TensExpMap  =buildTensorsFromSubDirs(path,false,'ExpMap');

[resultXQuat    ,resultYQuat    ]=BigClassifyOfMotions(TENSQuat    ,'dir',path,2,'Quat'    );
[resultXPosition,resultYPosition]=BigClassifyOfMotions(TENSPosition,'dir',path,2,'Position');
[resultXExpMap  ,resultYExpMap  ]=BigClassifyOfMotions(TENSExpMap  ,'dir',path,2,'ExpMap'  );

plotCompareCoefficients(resultYPosition,resultYQuat,resultYExpMap);