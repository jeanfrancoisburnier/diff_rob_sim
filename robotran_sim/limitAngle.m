function new_angle = limitAngle(angle)
%LIMITANGLE

    if (angle > pi)
        new_angle = angle - 2*pi;
    elseif (angle < -pi)
        new_angle = angle + 2*pi;
    else
        new_angle = angle;
    end
end