function J = paintlines(A,I,locs)

rows = locs(1,:);
cols = locs(2,:);

[accheight,accwidth] = size(A);

nlines = length(rows);

J = repmat(0.5*I,[1 1 3]);
for i = 1:nlines
    gamma = (rows(i)-1)/accheight*pi;
    displacement = cols(i)-(accwidth-1)/2;

    if gamma <= pi/2 % displacement always >= 0
        v = [cos(gamma) sin(gamma)];
        p = displacement*v;
        d = 0;
        vp = [-v(2) v(1)];
        q = round(p+d*vp);
        while q(1) >= 1 && q(2) <= size(I,2)
            if q(1) <= size(I,1) && q(2) >= 1
                J(q(1),q(2),1) = 0;
                J(q(1),q(2),2) = 1;
                J(q(1),q(2),3) = 0;
            end
            d = d+1;
            q = round(p+d*vp);
        end
        d = 0;
        q = round(p-d*vp);
        while q(1) <= size(I,1) && q(2) >= 1
            if q(1) >= 1 && q(2) <= size(I,2)
                J(q(1),q(2),1) = 0;
                J(q(1),q(2),2) = 1;
                J(q(1),q(2),3) = 0;
            end
            d = d+1;
            q = round(p-d*vp);
        end
    else
        v = [cos(gamma) sin(gamma)];
        p = displacement*v;
        d = 0;
        vp = [v(2) -v(1)];
        q = round(p+d*vp);
        while q(1) <= size(I,1) && q(2) <= size(I,2)
            if q(1) >= 1 && q(2) >= 1
                J(q(1),q(2),1) = 0;
                J(q(1),q(2),2) = 0;
                J(q(1),q(2),3) = 1;
            end
            d = d+1;
            q = round(p+d*vp);
        end
    end
end

end