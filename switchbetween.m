function switchbetween(I,J)

s = 0;
while 1
    if s == 0
        imshow(I), pause
        s = 1;
    else
        imshow(J), pause
        s = 0;
    end
end

end