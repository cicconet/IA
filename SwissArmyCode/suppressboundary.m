function J = suppressboundary(I,bd)
    % sets boundary pixels to zero
    % I: grayscale image
    % bd: boundary
    J = I;
    J(1:bd,:) = 0;
    J(end-bd+1:end,:) = 0;
    J(:,1:bd) = 0;
    J(:,end-bd+1:end) = 0;
end