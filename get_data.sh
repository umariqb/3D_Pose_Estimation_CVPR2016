# get normalized 3D pose databases
wget http://pages.iai.uni-bonn.de/iqbal_umar/ds3dpose/data/Data.tar.gz
tar -zxvf Data.tar.gz
rm Data.tar.gz


# get regressors for 2D pose estimate
wget http://pages.iai.uni-bonn.de/iqbal_umar/ds3dpose/data/regressors.tar.gz
tar -zxvf regressors.tar.gz & mv regressors ./MEX/src/ & rm regressors.tar.gz
