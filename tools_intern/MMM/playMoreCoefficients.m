function matrices=playMoreCoefficients(Tensor)

for a=1:8
    for b=1:8
        fprintf('a: %2i b: %2i\n',a,b);
        matrices{a,b}=playCoefficients(Tensor,a,b);
    end
end

