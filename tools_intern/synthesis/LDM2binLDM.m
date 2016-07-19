function [binLDM]=LDM2binLDM(LDM,dist)

[c,r]=size(LDM);

for col=1:c
    for row=1:r
        if(LDM(col,row)<dist)
            binLDM(col,row)=1;
        else
            binLDM(col,row)=0;
        end
    end
end

            