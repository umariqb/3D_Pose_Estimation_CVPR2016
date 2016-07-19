load('R:\HDM05_SmallDB\cut_amc\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_001_120.amc.MAT')

QT=mot.rotationQuat{1};
ET=quatlog(QT);

[QTfactors,QTcore]=tucker(QT,[4 401]);
[ETfactors,ETcore]=tucker(ET,[3 401]);

QTre=modeNproduct(QTcore,QTfactors{2},2);
QTre=modeNproduct(QTre,QTfactors{1},1);

ETre=modeNproduct(ETcore,ETfactors{2},2);
ETre=modeNproduct(ETre,ETfactors{1},1);

ETre2=quatexp(ETre);


