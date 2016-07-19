function f = features_combine_robust(f1,f2)

% close all;
% figure
% plot(f1,'r');
% hold;
% plot(f2);

x = zeros(1,length(f1)+1);
I_rises = find((diff([0 f2])>0));
I_descents = find((diff([f1 -1])<0))+1;
pr = 1;
pd = 1;
searching_rise = true;

while (pr<=length(I_rises) & pd<=length(I_descents))
    if (searching_rise)
        while (pd<=length(I_descents) && I_rises(pr)>I_descents(pd)) 
            pd = pd+1; % fast forward through intermediate descents
        end
        if (pd > length(I_descents) || I_rises(pr)<I_descents(pd)) % exclude the case where I_rises(pr)==I_descents(pd) (no singular spikes!)
            x(I_rises(pr)) = 1;
           %plot(I_rises(pr),1,'blue o');
            searching_rise = false;
        else % I_rises(pr)==I_descents(pd)
            pr = pr+1;
            pd = pd+1;
        end
    else % searching descent
        while (pr<=length(I_rises) && I_rises(pr)<=I_descents(pd)) 
            pr = pr+1; % fast forward through intermediate rises
        end
        x(I_descents(pd)) = -1; % arrived at next descent
       %plot(I_descents(pd),1,'red o');
        searching_rise = true; % look for next rise
    end
end

f = logical(cumsum(x(1:end-1)));
% plot(f,'g');