
function require_opt(cond, msg)

if ~cond
    error('ann_mwrapper:annquery:invalidopt', msg);
end
