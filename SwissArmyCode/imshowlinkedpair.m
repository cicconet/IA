function imshowlinkedpair(I,J)
    scsz = get(0,'ScreenSize'); % scsz = [left botton width height]
    figure('Position',[scsz(3)/4 scsz(4)/4 scsz(3)/2 scsz(4)/2])

    ax1 = subplot(1,2,1);
    imshow(I)

    ax2 = subplot(1,2,2);
    imshow(J)

    linkaxes([ax1,ax2],'xy')
end