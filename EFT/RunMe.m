clear
clc

% --------------------------------------------------
% setup
% --------------------------------------------------

I = normalize(double(imread('Cells.png')));
I = imresize(I,0.5);

radrange = [20 50]; % the estimated semi-minor and semi-major axis should be in this interval

% --------------------------------------------------
fprintf('finding centers...\n')
% --------------------------------------------------

[m,a,x,y] = coefficientslist(I,'WavScale',3,'MagThreshold',0.05);
% J = drawoutputslist(I,x,y,m,a,hopsize,2,1,0);
% imshow(J)
% return

nquadsfactor = 8; % number of pairs of triangles used: nquadsfactor*npairs
mindist = 0.25*radrange(1);
maxdist = 2*radrange(2);
[A,pairs,iquads] = eftacc(m,a,x,y,size(I,1),size(I,2),nquadsfactor,mindist,maxdist,radrange);
A = normalize(imfilter(A,fspecial('gaussian',[8 8],2)));

bw = imregionalmax(A).*(A > 0.5);
[r,c] = find(bw);
centers = [r c]';

% --------------------------------------------------
fprintf('finding remaining parameters...\n')
% --------------------------------------------------

proximitythreshold = 2;
ellipseindices = clusterbyellipse(pairs,iquads,centers,proximitythreshold);

[K,L,parameters] = remparameters(I,m,a,x,y,centers,pairs,iquads,ellipseindices);
Output = [repmat(I,[1 1 3]) L K];
imshow(Output)