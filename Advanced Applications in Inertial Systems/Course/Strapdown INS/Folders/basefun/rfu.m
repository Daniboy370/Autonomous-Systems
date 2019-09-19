function [wm, vm] = rfu(gyro, acc, str)
% 'U': Upper; 'D': Down; 'R': Right; 'L': Left; 'F': Forword; 'B': Back
    wm = gyro; vm = acc;
    for k=1:3
        switch(upper(str(k)))
            case {'R'}
                wm(:,1) = gyro(:,k); vm(:,1) = acc(:,k); 
                Dir(:,k) = [1; 0; 0];
            case {'L'}
                wm(:,1) = -gyro(:,k); vm(:,1) = -acc(:,k); 
                Dir(:,k) = [-1; 0; 0];
            case {'F'}
                wm(:,2) = gyro(:,k); vm(:,2) = acc(:,k);  
                Dir(:,k) = [0; 1; 0];
            case {'B'}
                wm(:,2) = -gyro(:,k); vm(:,2) = -acc(:,k); 
                Dir(:,k) = [0; -1; 0];
            case {'U'}
                wm(:,3) = gyro(:,k); vm(:,3) = acc(:,k);  
                Dir(:,k) = [0; 0; 1];
            case {'D'}
                wm(:,3) = -gyro(:,k); vm(:,3) = -acc(:,k);  
                Dir(:,k) = [0; 0; -1];
           otherwise
                error('Direction character string error !');
        end
    end
    if(norm(cross(Dir(:,1),Dir(:,2))-Dir(:,3))~=0)
        error('Not right hand frame !');
    end
