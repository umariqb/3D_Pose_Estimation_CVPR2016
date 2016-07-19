function spreadResults(classify_cell)

spreadMotions(classify_cell.res.skel,classify_cell.res.origMotCut,classify_cell.res.recMotUnwarped,...
fitMotFrameWise(classify_cell.res.skel,classify_cell.res.origMotCut,classify_cell.res.recMotUnwarped));