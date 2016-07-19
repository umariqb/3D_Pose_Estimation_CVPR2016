function v = runLengthDecode(v_rle)

% Assumption: every vector begins with a run of "1". (If not, => first run length is zero.)

if (~isa(v_rle,'double'))
    v_rle = double(v_rle);
end

if (size(v_rle,1)~=1)
    v_rle = v_rle';
end

n = sum(v_rle);
v = logical(zeros(1,n));

runs_start = [1 cumsum(v_rle)+1];
ones_start = runs_start(1:2:end-1);
v_rle = v_rle(1:2:end);

for k=1:length(v_rle)
    v(ones_start(k):ones_start(k)+v_rle(k)-1) = ones(1,v_rle(k));
end