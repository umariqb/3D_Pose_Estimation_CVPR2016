global VARS_GLOBAL
load Variables.mat
parameter.paperPositionPartDTW = [1,1,4.21,2.5];
parameter.paperPositionClassification = [1,1,4.4,2.5];
parameter.filenamePrefix = '../../../figures/tensorClassification_';
parameter.printFigure = 1;
parameter.omitTitle = 1;
plotMultiLayerResult2Fig(annotation,h4File, parameter)
close all;