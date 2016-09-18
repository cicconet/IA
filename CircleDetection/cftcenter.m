function c = cftcenter(t)

tau_perp_p = [0 -1; 1 0]*t.taup;
numerator = t.m(2)-t.p(2)-(t.m(1)-t.p(1))*tau_perp_p(2)/tau_perp_p(1);
denominator = t.T_perp_pq(1)*tau_perp_p(2)/tau_perp_p(1)-t.T_perp_pq(2);
beta = numerator/denominator;
c = t.m+beta*t.T_perp_pq;

end