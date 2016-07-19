function require_arg(cond, msg)

if ~cond
    error('ann_mwrapper:annquery:invalidarg', msg);
end