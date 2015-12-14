function qnew = quatinv(q)

qnorm = sum(q .* q);
qnew  = [q(1) , -q(2:4)] / qnorm;