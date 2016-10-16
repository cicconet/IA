function loc = symlinpar(t,accwidth,accheight)
% symmetry line parameters

d = t.T_pq;
if d(2) < 0
    d = -d;
end
gamma = atan2(d(2), d(1));
displacement = dot(t.m, d);
x = gamma/pi*accheight;
y = accwidth/2+displacement;
loc = [x; y];

end