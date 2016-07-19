function recmotDewarped = dewarpSteps(skel,recmot,stepsize,w)


c=0;
for i=1:stepsize:recmot.nframes-stepsize+1
    c=c+1;
    if i==1
        recmotDewarped = warpMotion(fliplr(w{c}),skel,cutMotion(recmot,i,i+stepsize-1));
    else
        recmotDewarped = addFrame2Motion(recmotDewarped,warpMotion(fliplr(w{c}),skel,cutMotion(recmot,i,i+stepsize-1)));
    end
end