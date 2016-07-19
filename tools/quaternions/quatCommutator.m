function q=quatCommutator(q1,q2)

q = quatmult(q1,quatmult(q2,quatmult(quatinv(q1),quatinv(q2))));