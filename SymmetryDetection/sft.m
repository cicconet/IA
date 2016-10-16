function A = sft(I,m,a,x,y,alpha)

s = length(m);
rp = randperm(s);

accwidth = 2*ceil(sqrt(size(I,1)^2+size(I,2)^2))+1; % displacement
accheight = 360; % angle

A = zeros(accheight,accwidth);

s = alpha*s;
for jj = 1:s-1
    for kk = jj+1:s
        j = rp(jj);
        k = rp(kk);
        t = triangle(x(j),y(j),a(j),m(j),x(k),y(k),a(k),m(k));
        loc = round(symlinpar(t, accwidth, accheight));
        row = loc(1); col = loc(2);
        if row >= 1 && row <= accheight && col >= 1 && col <= accwidth && t.degeneration < 0.9
            A(row,col) = A(row,col)+t.wmp*t.weight;
        end
    end
end

A = A/max(max(A));