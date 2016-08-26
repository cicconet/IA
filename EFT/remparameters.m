% Copyright © 2014 New York University.
% See notice at the end of this file.

function [K,L,parameters] = remparameters(Image,m,a,x,y,centers,pairs,iquads,ellipseindices)
% remaining parameters

nellipses = size(centers,2);
K = repmat(0.5*Image,[1 1 3]);
L = zeros(size(Image,1),size(Image,2),3);
parameters = [];
for i = 1:nellipses
    I = find(ellipseindices == i);
    npi = numel(I);
    xy = [];
    P = [];
    for ii = 1:npi % for each triangle in this ellipse
        for t = 1:2
            j = pairs(iquads(I(ii),t),2);
            k = pairs(iquads(I(ii),t),3);
            p = [x(j); y(j)];
            q = [x(k); y(k)];
            taup = [cos(a(j)); sin(a(j))];
            tauq = [cos(a(k)); sin(a(k))];
            r = intertanlin(p,q,taup,tauq);
            v = q-p;
            w = r-0.5*(p+q);
            for index = [j k]
                if m(index) > 0.1
                    if numel(xy) == 0
                        xy = [xy; [x(index) y(index)]-centers(:,i)'];
                    else
                        DS = sqrt(xy(:,1).^2+xy(:,2).^2);
                        if min(DS) > 0
                            xy = [xy; [x(index) y(index)]-centers(:,i)'];
                        end
                    end
                end
            end
            P = [P; [v(1)*w(1) v(1)*w(2)+v(2)*w(1) v(2)*w(2)]];
        end
    end
    
    [V,~] = eig(P'*P);
    v = V(:,1);
    T = [v(1) v(2); v(2) v(3)];
    e = eig(T);
    if e(1) < 0
        T = -T;
    end
    
    if prod(eig(T)) > 0 % for robustness to numerical errors
        [V,D] = eig(T);
        sqrtD = [sqrt(D(1,1)) 0; 0 sqrt(D(2,2))];
        C = sqrtD*V;
        
        for ii = 1:size(xy,1)
            row = centers(1,i)+xy(ii,1);
            col = centers(2,i)+xy(ii,2);
            if row > 0 && row <= size(L,1) && col > 0 && col <= size(L,2)
                L(row,col,1) = 1;
                L(row,col,2) = 1;
                L(row,col,3) = 1;
            end
        end
        xy = C*xy';
        for ii = 1:size(xy,2)
            xyii = round(xy(:,ii));
            row = centers(1,i)+xyii(1);
            col = centers(2,i)+xyii(2);
            if row > 0 && row <= size(L,1) && col > 0 && col <= size(L,2)
                L(row,col,1) = 1;
                L(row,col,2) = 1;
                L(row,col,3) = 0;
            end
        end
        c = [0; 0];
        ds = xy-repmat(c,[1 size(xy,2)]);
        rs = sqrt(ds(1,:).^2+ds(2,:).^2);
        b = median(rs);
        bp = b(1); % radius of transformed circle (semi-minor axis of ellipse)
        ap = sqrtD(2,2)/sqrtD(1,1)*bp;
        phi = atan2(V(2,1),V(1,1));
        
        [xs,ys] = pointsfromparam(centers(1,i),centers(2,i),ap,bp,phi,1000);
        parameters = [parameters; [centers(1,i),centers(2,i),ap,bp,phi]];
        for ii = 1:length(xs)
            if xs(ii) > 0 && xs(ii) <= size(K,1)
                if ys(ii) > 0 && ys(ii) <= size(K,2)
                    K(xs(ii),ys(ii),1) = 1;
                    K(xs(ii),ys(ii),2) = 1;
                    K(xs(ii),ys(ii),3) = 0;
                end
            end
        end
    end
end

end

% Copyright © 2014 New York University.
% 
% All Rights Reserved. A license to use and copy this software and its documentation
% solely for your internal research and evaluation purposes, without fee and without a signed licensing agreement,
% is hereby granted upon your download of the software, through which you agree to the following:
% 1) the above copyright notice, this paragraph and the following paragraphs
% will prominently appear in all internal copies;
% 2) no rights to sublicense or further distribute this software are granted;
% 3) no rights to modify this software are granted; and
% 4) no rights to assign this license are granted.
% Please Contact The Office of Industrial Liaison, New York University, One Park Avenue, 6th Floor,
% New York, NY 10016 (212) 263-8178, for commercial licensing opportunities,
% or for further distribution, modification or license rights.
%  
% Created by Marcelo Cicconet.
%  
% IN NO EVENT SHALL NYU, OR ITS EMPLOYEES, OFFICERS, AGENTS OR TRUSTEES (?COLLECTIVELY ?NYU PARTIES?)
% BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES OF ANY KIND ,
% INCLUDING LOST PROFITS, ARISING OUT OF ANY CLAIM RESULTING FROM YOUR USE OF THIS SOFTWARE AND ITS DOCUMENTATION,
% EVEN IF ANY OF NYU PARTIES HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH CLAIM OR DAMAGE.
%  
% NYU SPECIFICALLY DISCLAIMS ANY WARRANTIES OF ANY KIND REGARDING THE SOFTWARE,
% INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, THE IMPLIED WARRANTIES OF  MERCHANTABILITY
% AND FITNESS FOR A PARTICULAR PURPOSE, OR THE ACCURACY OR USEFULNESS,
% OR COMPLETENESS OF THE SOFTWARE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION,
% IF ANY, PROVIDED HEREUNDER IS PROVIDED COMPLETELY "AS IS".
% NYU HAS NO OBLIGATION TO PROVIDE FURTHER DOCUMENTATION, MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
% 
% Please cite the following reference if you use this software in your research:
% 
% Marcelo Cicconet, Kristin Gunsalus, Davi Geiger, and Michael Werman.
% Ellipses From Triangles. IEEE International Conference on Image Processing.
% Paris, France. 2014.