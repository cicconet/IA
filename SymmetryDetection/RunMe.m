I = imread('S.jpg');

resizingfactor = 200/max(size(I)); % max dimension will be 200 after resizing
I = imresize(I,resizingfactor);
I = double(rgb2gray(I))/255;

I = adapthisteq(I,'NumTiles',[8 8]);
% I = imrotate(I,90); % transform I to test robustness
I = fliplr(I); % transform I to test robustness

[m,a,x,y] = coefficientslist(I,'HopSize',5,'WavStretch',1,'WavScale',1);
% J = drawoutputslist(I,x,y,m,a,5,2,1,0); imshow(J), return

alpha = 0.5; % only pairs from alpha*'total number of tangents' tangents are considered
A = sft(I,m,a,x,y,alpha);
% imshow(A), return

A = normalize(imfilter(A,fspecial('gaussian',32,8)));

bw = imregionalmax(A).*(A > 1-1e-6);
% imshow(bw), return

[r,c] = find(bw);
locs = [r c]';

figure
subplot(1,2,1)
imshow(A), hold on
spy(bw,'ob'), title('acc space')

J = paintlines(A,I,locs);

subplot(1,2,2)
imshow(J), title('sym line')