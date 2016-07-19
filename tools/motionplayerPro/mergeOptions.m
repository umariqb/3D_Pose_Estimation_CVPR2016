function options = mergeOptions(options, optionsDefault)

if isempty(options)
    options = optionsDefault;
elseif ~isstruct(options)
  error('Parameter input argument must be struct.');
else
  % set default values where fields are missing
  fieldNames = fieldnames(optionsDefault);
  for k=1:length(fieldNames)
      if isstruct(optionsDefault.(fieldNames{k}))
          if isfield(options,fieldNames{k}) && isstruct(options.(fieldNames{k}))
            options.(fieldNames{k}) = mergeOptions(options.(fieldNames{k}),optionsDefault.(fieldNames{k}));
          else
              options.(fieldNames{k}) = optionsDefault.(fieldNames{k});
          end
      else
        if ~isfield(options, fieldNames{k})
            options.(fieldNames{k}) = optionsDefault.(fieldNames{k});
        end
      end
  end
end