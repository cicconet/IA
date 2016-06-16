function a = ang(cx,sx)

% cx = cosine of x (adjacent leg)
% sx = sine of x (opposite leg)

if sx >= 0
    a = acos(cx);
else
    a = acos(-cx)+pi;
end

end