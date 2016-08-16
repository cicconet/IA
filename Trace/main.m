I = double(imread('S3.png'))/255;
if size(I,3) > 1
    I = rgb2gray(I);
end

thr1 = 0.2;
thr2 = 0.1;
[trs, RGB, DRGB, BW] = traceoutlines(I,thr1,thr2);

Out = [RGB DRGB; repmat(I,[1 1 3]) repmat(BW,[1 1 3])];
imshow(Out);

figure
I = 0.25*repmat(I,[1 1 3]);
for i = 1:length(trs)
    tr = trs{i};
    f = i/length(trs);
    c = hsv2rgb([2/3*f, 1, 1]);
    for j = 1:size(tr,1)
        I(tr(j,1),tr(j,2),:) = reshape(c,[1 1 3]);
    end
    imshow(I)
    title(sprintf('%.02f',f))
    pause((1-f)*0.1)
end
title('traced outlines')