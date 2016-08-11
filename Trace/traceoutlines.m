function [trs, RGB, DRGB, BW] = traceoutlines(I,thr1,thr2)

% I: grayscale, range [0,1] image
% thr1: traces start only at magnitudes above this threshold
%       should be in [0,1]
% thr2: traces end if magnitude below this thr
%       should be < thr1 and in [0,1]
% trs: cell of outlines; trs{i}: n by 2 matrix or (row,col) of trace
% RGB: magnitude/orientation matrix
% DRGB: RGB only on found traces
% BW: black and white edge image of found traces

[M,T,RGB] = mmat(I);

[nr,nc] = size(I);

step = 1; % trace step
hbw = 1; % set to 3 to suppress more nearby gradients

% suppress pixels at the boundary
M = suppressboundary(M,5);

[rs,cs] = find(M > thr1);

T = T/360*2*pi; % angles in [0,2*pi)

% sort rows and columns of selected pixels
m = M(M > thr1);
[~,idx] = sort(m,'descend');
rs = rs(idx);
cs = cs(idx);

% a = T(M > thr1);
% imshow(I), hold on
% quiver(cs,rs,sin(a),cos(a)), hold off
% return

DRGB = zeros(size(RGB)); 
BW = zeros(nr,nc);
V = zeros(nr,nc);

p = [rs(1) cs(1)];
a = T(p(1),p(2));

count = 0;
trs = {};
ms = zeros(1,2*hbw+1);
while 1
    % adjust location of initial point of trace
    for j = -hbw:hbw
        q = round(p+j*[cos(a) sin(a)]);
        aq = T(q(1),q(2));
        if q(1) >= 1 && q(1) <= nr && q(2) >= 1 && q(2) <= nc && ~V(q(1),q(2)) && dot([cos(a) sin(a)],[cos(aq) sin(aq)]) > 0.9
            ms(hbw+1+j) = M(q(1),q(2));
        else
            ms(hbw+1+j) = 0;
        end
        index = find(rs == q(1) & cs == q(2));
        rs(index) = [];
        cs(index) = [];
        V(q(1),q(2)) = 1;
    end
    [m,im] = max(ms);
    j = im-hbw-1;        
    p0 = round(p+j*[cos(a) sin(a)]);
    a0 = T(p(1),p(2));
    m0 = m;
    
    % trace in one direction
    tr = [];
    p = p0;
    a = a0;
    m = m0;
    while m > thr2
        tr = [tr; p];
        
        % advance
        p = round(p+step*[sin(a) -cos(a)]);
        a = T(p(1),p(2));
        
        % adjust
        for j = -hbw:hbw
            q = round(p+j*[cos(a) sin(a)]);
            aq = T(q(1),q(2));
            if q(1) >= 1 && q(1) <= nr && q(2) >= 1 && q(2) <= nc && ~V(q(1),q(2)) && dot([cos(a) sin(a)],[cos(aq) sin(aq)]) > 0.9
                ms(hbw+1+j) = M(q(1),q(2));
            else
                ms(hbw+1+j) = 0;
            end
            index = find(rs == q(1) & cs == q(2));
            rs(index) = [];
            cs(index) = [];
            V(q(1),q(2)) = 1;
        end
        [m,im] = max(ms);
        j = im-hbw-1;        
        p = round(p+j*[cos(a) sin(a)]);
        a = T(p(1),p(2));
    end
    
    % trace other direction
    p = p0;
    a = a0;
    
    % first point already on trace, so first step out of the loop
    
    % advance
    p = round(p-step*[sin(a) -cos(a)]);
    a = T(p(1),p(2));
        
    % adjust
    for j = -hbw:hbw
        q = round(p+j*[cos(a) sin(a)]);
        aq = T(q(1),q(2));
        if q(1) >= 1 && q(1) <= nr && q(2) >= 1 && q(2) <= nc && ~V(q(1),q(2)) && dot([cos(a) sin(a)],[cos(aq) sin(aq)]) > 0.9
            ms(hbw+1+j) = M(q(1),q(2));
        else
            ms(hbw+1+j) = 0;
        end
        index = find(rs == q(1) & cs == q(2));
        rs(index) = [];
        cs(index) = [];
        V(q(1),q(2)) = 1;
    end
    [m,im] = max(ms);
    j = im-hbw-1;        
    p = round(p+j*[cos(a) sin(a)]);
    a = T(p(1),p(2));
        
    while m > thr2
        tr = [p; tr]; % add point to the front of list now
        
        % advance
        p = round(p-step*[sin(a) -cos(a)]);
        a = T(p(1),p(2));
        
        % adjust
        for j = -hbw:hbw
            q = round(p+j*[cos(a) sin(a)]);
            aq = T(q(1),q(2));
            if q(1) >= 1 && q(1) <= nr && q(2) >= 1 && q(2) <= nc && ~V(q(1),q(2)) && dot([cos(a) sin(a)],[cos(aq) sin(aq)]) > 0.9
                ms(hbw+1+j) = M(q(1),q(2));
            else
                ms(hbw+1+j) = 0;
            end
            index = find(rs == q(1) & cs == q(2));
            rs(index) = [];
            cs(index) = [];
            V(q(1),q(2)) = 1;
        end
        [m,im] = max(ms);
        j = im-hbw-1;        
        p = round(p+j*[cos(a) sin(a)]);
        a = T(p(1),p(2));
    end
    
    % suppress neighborhood of trace
    for i = 1:size(tr,1)
        for j = -hbw:hbw
            for k = -hbw:hbw
                q = [tr(i,1)+j tr(i,2)+k];
                M(q(1),q(2)) = 0;
                index = find(rs == q(1) & cs == q(2));
                rs(index) = [];
                cs(index) = [];
                V(q(1),q(2)) = 1;
            end
        end
    end
    
    count = count+1;
    trs{count} = tr;
    tr = [];

    if ~isempty(rs)
        p = [rs(1) cs(1)];
        a = T(p(1),p(2));
    else
        break;
    end
end

if nargout > 2
    for itr = 1:length(trs)
        tr = trs{itr};
        for i = 1:size(tr,1)
            DRGB(tr(i,1),tr(i,2),:) = RGB(tr(i,1),tr(i,2),:);
            BW(tr(i,1),tr(i,2)) = 1;
        end
    end
end

end