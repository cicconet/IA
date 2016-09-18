%% wavelet based hough transform

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
title('wbht')


%% complex-valued hough tranform for circles

I = imread('eight.tif'); % tire.tif, eight.tif
I = double(I)/255;

radrange = [30 40];
scale = 1;

A = cvhtc(I,radrange,'WavScale',scale,'BlurFlag',1,'BlurScale',3);

bw = imregionalmax(A).*(A > 0.5);

figure
subplot(1,2,1)
imshow(A), title('circle center likelihood (cvhtc)')
subplot(1,2,2)
imshow(0.5*I), hold on
spy(bw,'w'), title('circle centers')


%% circles from triangles

I = imread('coins.png');
I = double(I)/255;

radrange = [10 40];

[m,a,x,y] = coefficientslist(I,'HopSize',5,'WavStretch',1,'WavScale',2);

% J = drawoutputslist(I,x,y,m,a,5,2,1,0); imshow(J), return

alpha = 0.5; % only pairs from alpha*'total number of tangents' tangents are considered
A = cft(I,radrange,m,a,x,y,alpha);

A = normalize(imfilter(A,fspecial('gaussian',8,2)));

bw = imregionalmax(A).*(A > 0.1);

figure
subplot(1,2,1)
imshow(A), title('circle center likelihood (cft)')
subplot(1,2,2)
imshow(0.5*I), hold on
spy(bw,'w'), title('circle centers')