function c = get_name_code(optname, name, names)

require_opt(ischar(name), ['The option ' optname ' should be a string indicating a name.']);

cidx = find(strcmp(name, names));
require_opt(~isempty(cidx), ['The option ' optname ' cannot be assigned to be ' name]);

c = int32(cidx - 1);