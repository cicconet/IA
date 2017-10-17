I = zeros(2,100);

s = randi(100,[1 5]);

flag0 = rand < 0.5;
flag = flag0;
for j = 1:100
    if min(abs(s-j)) == 0
        flag = not(flag);
    end
    if flag && rand < 0.95
        I(1,j) = normrnd(1,0.1);
        I(2,j) = normrnd(0,0.1);
    else
        I(1,j) = normrnd(0,0.1);
        I(2,j) = normrnd(1,0.1);
    end
end

I = I-min(I(:));
I = I/max(I(:));

% imshow(imresize(I,10,'nearest'))


%%


C = 1-I;

[nRows, nCols] = size(C);

if nRows < 2
    error('not enough rows')
end
if nCols < 2
    error('not enough cols')
end

pathCosts = zeros(size(C));

pathCosts(:,1) = C(:,1);
predecessors = nan(size(C));

for j = 2:nCols
    for i = 1:nRows
        if i == 1
            localCosts = [Inf; pathCosts(i:i+1,j-1)];
        elseif i == nRows
            localCosts = [pathCosts(i-1:i,j-1); Inf];
        else
            localCosts = pathCosts(i-1:i+1,j-1);
        end
        localCosts = localCosts.*[1.3; 1; 1.3];
        [m,im] = min(localCosts);
        updatedCost = m+C(i,j);
        pathCosts(i,j) = updatedCost;
        predecessors(i,j) = i+im-2;
    end
end

%%

[~,im] = min(pathCosts(:,nCols));

rPath = zeros(1,nCols);
rPath(nCols) = im;
for j = nCols-1:-1:1
    rPath(j) = predecessors(rPath(j+1),j+1);
end

%%

P = zeros(size(I));

for j = 1:nCols
    P(rPath(j),j) = 1;
end

% imshow(P)

%%

imshow(imresize([I; P],10,'nearest'))