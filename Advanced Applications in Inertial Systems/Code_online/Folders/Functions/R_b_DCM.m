function [r1, r2, r3] = R_b_DCM( Rot_Mat )
% -------------------------- Description ------------------------- %
%                                                                  %
%               Convert DCM to body Navigatgion frame              %
%                                                                  %
% --------------------------- Content ---------------------------- %

lim = 'default';

[r1, r2, r3] = threeaxisrot( -Rot_Mat(3,2,:), Rot_Mat(3,3,:), Rot_Mat(3,1,:), ...
    -Rot_Mat(2,1,:), Rot_Mat(1,1,:), ...
    Rot_Mat(2,3,:), Rot_Mat(2,2,:));

    function [r1,r2,r3] = threeaxisrot(r11, r12, r21, r31, r32, r11a, r12a)
        % find angles for rotations about X, Y, and Z axes
        r1 = atan2( r11, r12 );
        r21(r21 < -1) = -1;
        r21(r21 > 1) = 1;
        r2 = asin( r21 );
        r3 = atan2( r31, r32 );
        if strcmpi( lim, 'zeror3')
            for i = find(abs( r21 ) == 1.0)
                r1(i) = atan2( r11a(i), r12a(i) );
                r3(i) = 0;
            end
        end
    end
end
