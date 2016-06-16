I = imread('eight.tif'); % rice.png, circuit.tif, circles.png, tire.tif, eight.tif
I = double(I)/255;

nangs = 16; % number of angles (equally distributed in [0,pi))
stretch = 1; % stretch of morlet wavelet
scale = 1; % scale of morlet wavelet
hopsize = 5; % distance between centers of windows
halfwindowsize = 1; % half width of window
magthreshold = 0.01; % magnitude threshold for wavelet consideration

% J = waveletinimage(I,stretch,scale);
% imshow(J)
% return

[m,a,x,y] = coefficientslist(I,nangs,stretch,scale,hopsize,halfwindowsize,magthreshold);
magfactor = 2;
showoriginal = 1;
showcoefficients = 0;
J = drawoutputslist(I,x,y,m,a,hopsize,magfactor,showoriginal,showcoefficients);
imshow(J)