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


%% complex-valued hough tranform for circles

I = imread('eight.tif'); % tire.tif, eight.tif
I = double(I)/255;

radrange = [30 40];
scale = 1;

A = cvhtc(I,radrange,'WavScale',scale,'BlurFlag',1,'BlurScale',3);

bw = imregionalmax(A).*(A > 0.5);

figure
subplot(1,2,1)
imshow(A), title('circle center likelihood')
subplot(1,2,2)
imshow(0.5*I), hold on
spy(bw), title('circle centers')
