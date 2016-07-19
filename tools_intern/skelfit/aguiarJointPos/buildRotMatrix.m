function A = buildRotMatrix( v, alpha )

x = 1-cos(alpha);

A = [ cos(alpha) + v(1)*v(1)*x      v(1)*v(2)*x - v(3)*sin(alpha)  v(1)*v(3)*x + v(2)*sin(alpha); ...
      v(2)*v(1)*x + v(3)*sin(alpha) cos(alpha) + v(2)*v(2)*x       v(2)*v(3)*x - v(1)*sin(alpha); ...
      v(3)*v(1)*x - v(2)*sin(alpha) v(3)*v(2)*x + v(1)*sin(alpha)  cos(alpha) + v(3)*v(3)*x];