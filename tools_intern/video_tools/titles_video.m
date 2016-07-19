% replicateImage('01_title.tif', '01_title.avi', 30, (75+56)/30);
% replicateImage('01_title_submission_version.tif', '01_title_submission_version.avi', 30, (75+56)/30);
%replicateImage('01_title_copyright.tif', '01_title_copyright.avi', 30, (75+56)/30);
blendImages('01_title_copyright.tif', 'emptyGray512x384.tif', '01_title_copyright_fadeout.avi', 30, 1);

% replicateImage('title_geometric_features.tif', 'title_geometric_features.avi', 30, 1.5);
% replicateImage('title_adaptive_segmentation.tif', 'title_adaptive_segmentation.avi', 30, 1.5);
% replicateImage('title_retrieval.tif', 'title_retrieval.avi', 30, 1.5);