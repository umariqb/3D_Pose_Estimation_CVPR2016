function [V_out,weights_out] = uniqueWeightedVectorSequence(V_in,weights_in)

V_out = V_in;
weights_out = weights_in;
counter = 0;
pos = 0;
pos1 = 0;
num = size(V_in,2);
while pos < num
    pos = pos+1;
    pos1 = pos;
    while (pos<num) && (sum(V_in(:,pos1)~=V_in(:,pos+1))==0)
        pos = pos+1;
    end
    counter = counter+1;
    V_out(:,counter) = V_in(:,pos1);
    weights_out(counter) = sum(weights_in(pos1:pos));
end
V_out = V_out(:,1:counter);
weights_out = weights_out(1:counter);
