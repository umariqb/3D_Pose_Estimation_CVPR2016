function [v_rle,runs_start] = runLengthEncode(v)

% Assumption: every vector begins with a run of "1". (If not, => first run length is zero.)

if (~islogical(v))
    warning('Expected logical vector as input. Converting input to logical.');
    v = logical(v);
end

if (size(v,1)~=1)
    v = v';
end

runs_start = [1 find(diff([logical(1) v])~=0)];
v_rle = diff([runs_start length(v)+1]);

if (max(v_rle)<2^8)
    v_rle = uint8(v_rle);
elseif (max(v_rle)<2^16)
    v_rle = uint16(v_rle);
elseif (max(v_rle)<2^32)
    v_rle = uint32(v_rle);
end