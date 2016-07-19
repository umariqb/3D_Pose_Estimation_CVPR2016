function [V_out,weights_out] = contractWeightedVectorSequenceLogicalAnd(V_in,weights_in)
% example: [V,w] = contractWeightedVectorSequence([1 1 1 1 1 1 1],[1 0.5 0.125 0.125 1 0.25 0.4])
%          output : [1 1 1],[1 0.75 1.65]

V_out = zeros(size(V_in));
dimV = size(V_in,1);
n = size(V_in,2);
weights_out = zeros(1,n);

counter_in = 1;
counter_out = 0;
while counter_in <= n
    counter_out = counter_out+1;
    s = weights_in(counter_in);
    if s>=0.75
        V_out(:,counter_out) = V_in(:,counter_in);
        weights_out(counter_out) = s;
        counter_in = counter_in+1;
    else
        hit_right_border = false;
        counter_right = counter_in;
        while s<0.75
            counter_right = counter_right+1;
            if counter_right<=n
                s = s+weights_in(counter_right);
            else
                hit_right_border = true;
                counter_right = counter_right-1;
                break;
            end
        end
        if (hit_right_border)
            counter_in = counter_in-1;
            counter_out = counter_out-1;
            s = s+weights_in(counter_in);
        end
        V_out(:,counter_out) = logical_and_sum(V_in(:,counter_in:counter_right),2);
        weights_out(counter_out) = s;
        
        counter_in = counter_right+1;
    end
end
V_out = V_out(:,1:counter_out);
weights_out = weights_out(1:counter_out);

