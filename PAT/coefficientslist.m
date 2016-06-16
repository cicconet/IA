function [m,a,x,y] = coefficientslist(I,nangs,stretch,scale,hopsize,halfwindowsize,magthreshold)

[M,A,X,Y] = coefficientsmatrix(I,nangs,stretch,scale,hopsize,halfwindowsize,magthreshold);
s = sum(sum(M > 0));
m = zeros(1,s);
a = zeros(1,s);
x = zeros(1,s);
y = zeros(1,s);
[nr,nc] = size(M);
index = 0;
for i = 1:nr
    for j = 1:nc
        if M(i,j) > 0
            index = index+1;
            m(index) = M(i,j);
            a(index) = A(i,j);
            x(index) = X(i,j);
            y(index) = Y(i,j);
        end
    end
end

end