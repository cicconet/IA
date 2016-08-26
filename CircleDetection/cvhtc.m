function A = cvhtc(I,radrange,varargin)

% complex-valued hough transform for circles
% ----------
% INPUTS
% expects double, range [0,1], grayscale image input I
% varargin:
%   'BlurFlag', default 1: flag (0 or 1) to blur accumulator space
%   'BlurScale', default 3: sigma of gaussian blur kernel
%   all remaining arguments are passed to 'corfficientslist'
%   see that function for details
% ----------
% OUTPUTS
% A: accumulator space (circle center likelihood)
% ----------
% EXAMPLE
% see RunMe.m at this function's directory
% ----------
% REFERENCE
% M. Cicconet, D. Geiger, and M. Werman. Complex-Valued Hough Transforms for Circles.
% IEEE International Conference on Image Processing, 2015, Quebec City, Canada
%   
% Marcelo Cicconet, 2016 Aug 24

ip = inputParser;
ip.addParameter('BlurFlag',1);
ip.addParameter('BlurScale',3);

ip.KeepUnmatched = true;
ip.parse(varargin{:});
param = ip.Results;
pp = ip.Unmatched; % pass any unrecognized argument to the coefficientslist function

[m,a,x,y] = coefficientslist(I,pp);

s = length(m);
[nr,nc] = size(I);
A = complex(zeros(nr,nc));
nu = pi/mean(radrange);
for j = 1:s
    p0 = [x(j); y(j)];
    v = [-sin(a(j)); cos(a(j))];
    for d = radrange(1):radrange(2)
       p = round(p0+d*v);
        if p(1) >= 1 && p(1) <= nr && p(2) >= 1 && p(2) <= nc
            A(p(1),p(2)) = A(p(1),p(2))+exp(1i*nu*d);
        end
    end
end

A = A.*conj(A);

if param.BlurFlag
    A = filterGauss2D(A,param.BlurScale);
end

A = A/max(max(A));

end