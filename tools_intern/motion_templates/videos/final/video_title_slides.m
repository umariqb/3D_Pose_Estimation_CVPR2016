global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end
VARS_GLOBAL_ANIM.video_compression = 'PNG1';

% replicateImage('render/slide_title.tif', 'render/video_slide_title.avi', 30, 3.5);
% replicateImage('render/slide_features.tif', 'render/video_slide_features.avi', 30, 3.5);
% replicateImage('render/slide_WMTs.tif', 'render/video_slide_WMTs.avi', 30, 3.5);
% replicateImage('render/slide_retrieval.tif', 'render/video_slide_retrieval.avi', 30, 3.5);
%replicateImage('render/slide_acknowledgements_review.tif', 'render/video_slide_acknowledgements_review.avi', 30, 3.5);

replicateImage('render/slide_title_final_submission.tif', 'render/video_slide_title_final_submission.avi', 30, 3.5);
%replicateImage('render/slide_acknowledgements_final_submission.tif', 'render/video_slide_acknowledgements_final_submission.avi', 30, 3.5);