function t = triangle(px,py,pa,pm,qx,qy,qa,qm)

p = [px; py];
q = [qx; qy];
taup = [cos(pa); sin(pa)];
tauq = [cos(qa); sin(qa)];

[intp,denom] = intertanlin(p,q,taup,tauq);
if denom ~= 0
    degeneration = 0; % to be corrected below
    x = intp;
else
    degeneration = 1; % means third vertex is at infinity
    x = [Inf; Inf];
end

base = norm(q-p);
d = [0; 0];
m = (p+q)/2;
if degeneration == 0
    d = m-x;
    n = norm(d);
    if n > 0.0
        d = d/n;
    end
    pn = (p-x)/norm(p-x);
    qn = (q-x)/norm(q-x);
    degeneration = abs(dot(pn,qn));
end


T_pq = (q-p)/base;
T_perp_pq = [0 -1; 1 0]*T_pq;

theta = ang(T_perp_pq(1),T_perp_pq(2));
S = [cos(2*theta) sin(2*theta); sin(2*theta) -cos(2*theta)]; % reflection matrix

wmp = abs(tauq'*S*taup); % weak mirror potential (the closer to 1, the more mirror symmetric)
mp = 0.5*(1+tauq'*S*taup); % mirror potential
wpp = abs(tauq'*taup); % weak parallel potential (the closer to 1, the more parallel)
pp = 0.5*(1+tauq'*taup); % parallel potential

weight = pm*qm;

t = struct('p',p,'q',q,'taup',taup,'tauq',tauq,...
    'm',m,'x',x,'d',d,'T_pq',T_pq,'T_perp_pq',T_perp_pq,'base',base,...
    'degeneration',degeneration,'wmp',wmp,'mp',mp,'wpp',wpp,'pp',pp,'weight',weight);

end