function [A,centers,C] = wcht(I,sc,nor,rad,thr)
% I shoudl be double in [0,1]

A = wchtacc(I,rad,sc,nor);

if nargout > 1
    LocMax = imregionalmax(A);

    [lm_rows, lm_cols] = find(LocMax.*(A > thr));

    centers = zeros(numel(lm_rows),2);
    for i = 1:numel(lm_rows)
        centers(i,:) = [lm_rows(i) lm_cols(i)];
    end
end

if nargout > 2
    C = zeros(size(A));
    for n = 1:size(centers,1)
        C(centers(n,1),centers(n,2)) = 1;
        for alpha = linspace(0,2*pi,100)
            x = centers(n,1)+rad*cos(alpha);
            y = centers(n,2)+rad*sin(alpha);
            C(round(x),round(y)) = 1;
        end
    end
end

end