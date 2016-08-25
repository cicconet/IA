I = imread('coins.png');
I = double(I)/255;

sc = 2; % scale
nor = 8; % norientations
thr = 0.75; % loc max threshold

rad = 23:30;

if numel(rad) == 1
    [A,~,C] = wcht(I,sc,nor,rad,thr);
    imshow([I A C])
else
    A = zeros(size(I));
    for i = 1:numel(rad)  
        A = A+wcht(I,sc,nor,rad(i),thr);
    end
    A = A/max(max(A));
    imshow([I A])
end