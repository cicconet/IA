% Copyright � 2014 New York University.
% See notice at the end of this file.

function ellipseindices = clusterbyellipse(pairs,iquads,centers,proximitythreshold)

nellipses = size(centers,2);
nquads = size(iquads,1);
ellipseindices = zeros(nquads,1);
for k = 1:nquads
    i = iquads(k,1);
    j = iquads(k,2);
    midp1 = pairs(i,4:5)';
    dirv1 = pairs(i,6:7)';
    midp2 = pairs(j,4:5)';
    dirv2 = pairs(j,6:7)';
    [intp,~] = intertanlin(midp1,midp2,dirv1,dirv2);
    ds = zeros(1,nellipses);
    for iel = 1:nellipses
        ds(iel) = norm(intp-centers(:,iel));
    end
    [m,im] = min(ds);
    if m < proximitythreshold
        ellipseindices(k) = im;
    end
end

end

% Copyright � 2014 New York University.
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