function [M,A,X,Y] = coefficientsmatrix(I,nangs,stretch,scale,hopsize,halfwindowsize,magthreshold)
% I should be double, and in the range [0,1]

orientations = (0:nangs-1)*180/nangs;
norientations = length(orientations);

windowsize = 2*halfwindowsize;

nr = min([floor((size(I,1)-windowsize)/hopsize)+1 size(I,1)]);
nc = min([floor((size(I,2)-windowsize)/hopsize)+1 size(I,2)]);

C = zeros(nr,nc);
A = zeros(nr,nc);
X = zeros(nr,nc);
Y = zeros(nr,nc);

RI3 = zeros(size(I,1),size(I,2),norientations);

for j = 1:norientations
    orientation = orientations(j);

    [mr,~] = smorlet(stretch,scale,orientation,1);

    R = conv2(I,mr,'same');
%     Z = conv2(I,mi,'same');
    
    RI3(:,:,j) = R; % sqrt(R.*R+Z.*Z);
end

rows = round(linspace(halfwindowsize+1,size(I,1)-halfwindowsize,nr));
cols = round(linspace(halfwindowsize+1,size(I,2)-halfwindowsize,nc));

for k = 1:nr
    for l = 1:nc
        row = rows(k);
        col = cols(l);
        M3 = RI3(row-halfwindowsize:row+halfwindowsize,col-halfwindowsize:col+halfwindowsize,:);
        [M,IM] = max(M3,[],3);
        [mC,imC] = max(M);
        [mR,imR] = max(mC);
        C(k,l) = mR;
        rm = imC(imR);
        cm = imR;
        A(k,l) = (IM(rm,cm)-1)*pi/nangs+pi/2;
        X(k,l) = row+rm-(halfwindowsize+1);
        Y(k,l) = col+cm-(halfwindowsize+1);
    end
end

M = zeros(size(C));
t = magthreshold*max(max(C));
for k = 2:nr-1
    for l = 2:nc-1
        bM = C(k-1:k+1,l-1:l+1);
        if C(k,l) > 0.75*max(max(bM)) && min(min(bM)) > t
            M(k,l) = C(k,l);
        end
    end
end

end