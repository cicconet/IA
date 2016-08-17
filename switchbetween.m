function switchbetween(I,J)

s = 0;
while 1
    if s == 0
        imshow(I), title('first'), pause
        s = 1;
    else
        imshow(J), title('second'), pause
        s = 0;
    end
end

end