function [tp,fp,fn,pr,rc] = tpfpfn(gt,dt,dstthr)
% gt: ground truth centers, one per column
% dt: algorithm output centers, one per column
% dstthr: distance threshold for correct detection

% tp: number of true positives
% fp: number of false positives
% fn: number of false negatives
% pr: precision = tp/(tp+fp)
% rc: recall = tp/(tp+fn)

tp = 0;
fp = 0;
fn = 0;
for gti = 1:size(gt,2) % for all ground truth values
    nhits = 0;
    for dti = 1:size(dt,2) % for all data values
        if norm(dt(:,dti)-gt(:,gti)) < dstthr
            nhits = nhits+1;
        end
    end
    if nhits > 0;
        tp = tp+1;
    else
        fn = fn+1;
    end
end
for dti = 1:size(dt,2) % for all data values
    hitone = 0;
    for gti = 1:size(gt,2) % for all ground truth values
        if norm(dt(:,dti)-gt(:,gti)) < dstthr
            hitone = 1;
            break;
        end
    end
    if hitone == 0
        fp = fp+1;
    end
end

if nargout > 3
    pr = tp/(tp+fp);
    rc = tp/(tp+fn);
end

end