function J = drawoutputslist(I,x,y,m,a,hopsize,magfactor,showoriginal,showcoefficients)

if showoriginal
    J = imresize(0.5*I,magfactor);
else
    J = imresize(zeros(size(I)),magfactor);
end
J = repmat(J,[1 1 3]);
s = length(m);
k0 = floor(magfactor*hopsize/3);
for j = 1:s
    for k = -k0:k0
        row = magfactor*x(j)+round(k*cos(a(j)));
        col = magfactor*y(j)+round(k*sin(a(j)));
        if row > 0 && col > 0 && row <= size(J,1) && col <= size(J,2)
            value = showcoefficients*m(j)+(1-showcoefficients);
            J(row,col,1) = value;
            J(row,col,2) = value;
            J(row,col,3) = 0;
        end
    end
end

end