I = double(imread('S5.png'))/255;
if size(I,3) > 1
    I = rgb2gray(I);
end

thr1 = 0.2;
thr2 = 0.1;
[trs, RGB, DRGB, BW] = trace(I,thr1,thr2);

Out = [RGB DRGB; repmat(I,[1 1 3]) repmat(BW,[1 1 3])];
imshow(Out);