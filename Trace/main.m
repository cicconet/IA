I = double(imread('S1.png'))/255;
if size(I,3) > 1
    I = rgb2gray(I);
end

thr1 = 0.2;
thr2 = 0.1;
[trs, RGB, DRGB, BW] = traceoutlines(I,thr1,thr2);

Out = [RGB DRGB; repmat(I,[1 1 3]) repmat(BW,[1 1 3])];
imshow(Out);

figure
imshow(0.25*I), hold on
for i = 1:length(trs)
    tr = trs{i};
    plot(tr(:,2),tr(:,1))
end
hold off