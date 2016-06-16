function J = waveletinimage(I,stretch,scale)

[m,~] = smorlet(stretch,scale,45,1);
m = m-min(min(m));
m = m/max(max(m));
m(1,:) = 0; m(end,:) = 0; m(:,1) = 0; m(:,end) = 0;
J = I;
J(1:size(m,1),1:size(m,2)) = m;

end