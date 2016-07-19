function d = distQuats(P,Q)

	n = size(P,2);
	w = [.5 1 1 .5 1 1 .2 .2 .2 .1 .5 1 1 .5 1 1]; 
	%w = reshape(w,1,1,22);
	d = sum(w.*(distRP3(P,Q,.01).^2));
	
	