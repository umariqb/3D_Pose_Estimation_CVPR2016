function assert_bgl(condition,varargin)

if condition, return;
else
  error(varargin{:});
end
