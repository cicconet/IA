I = imread('circuit.tif');
I = I(1:200,:);
I = double(I)/255;

%%

C = I;%1-I;

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

P = 0.5*I;

for j = 1:nCols
    P(rPath(j),j) = 1;
end

imshow(P)