function switchbetween(I,J,ntimes)

s = 0;
i = -1;
while i < ntimes
    i = i+1;
    if s == 0
        imshow(I), title('first'), pause
        s = 1;
    else
        imshow(J), title('second'), pause
        s = 0;
    end
end
close all

end