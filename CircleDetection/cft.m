function A = cft(I,radrange,m,a,x,y,alpha)

s = length(m);
rp = randperm(s);
[imgheight,imgwidth] = size(I);
A = zeros(imgheight,imgwidth);
s = alpha*s;
for jj = 1:s-1
    for kk = jj+1:s
        j = rp(jj);
        k = rp(kk);
        t = triangle(x(j),y(j),a(j),m(j),x(k),y(k),a(k),m(k));
        center = cftcenter(t);
        radius = norm(center-t.p);
        if radius >= radrange(1) && radius <= radrange(2)
            rc = round(center);
            if rc(1) >= 1 && rc(1) <= imgheight && rc(2) >= 1 && rc(2) <= imgwidth
                A(rc(1),rc(2)) = A(rc(1),rc(2))+t.wmp*t.weight;
            end
        end
    end
end

A = A/max(max(A));

end