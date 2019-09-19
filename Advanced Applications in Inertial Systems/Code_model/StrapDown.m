function [X,Y,Z] = StrapDown(Acc, Omega, Ref_data, Time)

RefTrajectory   = ReadTrajectoryData(Ref_data);
lat = RefTrajectory.Lat(1);
long = RefTrajectory.Long(1);
alt = RefTrajectory.Alt(1);
V_l = RefTrajectory.V_NED(:,1);
psi = RefTrajectory.Euler(3,1)';
teta = RefTrajectory.Euler(2,1)';
phi = RefTrajectory.Euler(1,1)';
C_bl(:,:,1) = Euler2DCM([phi,teta,psi]);
dt = Time(2)-Time(1);
for i=1:length(Time)-1
    w_ei       = [0;0;7.292115e-5];
    [RN, RM, Re]=Radius(lat(i));
    g_l   = [0;0;9.780318*(Re/(Re+alt(i)))^2*(1+0.0052884*sin(lat(i))^2-0.0000059*sin(2*lat(i))^2)];
    C_el = [-sin(lat(i))*cos(long(i)), -sin(lat(i))*sin(long(i)), cos(lat(i))
        -sin(long(i)), cos(long(i)), 0
        -cos(lat(i))*cos(long(i)), -cos(lat(i))*sin(long(i)), -sin(lat(i))];
    w_le = [cos(lat(i))*V_l(2,i)/((RN + alt(i))*cos(lat(i))); -V_l(1,i)/ (RM + alt(i)); -sin(lat(i))*V_l(2,i)/((RN + alt(i))*cos(lat(i)))];
    w_li = C_el*w_ei + w_le;
    C_pqr2l = [1, sin(phi(i))*tan(teta(i)), cos(phi(i))*tan(teta(i)); 0, cos(phi(i)), -sin(phi(i)); 0, sin(phi(i))/cos(teta(i)), cos(phi(i))/cos(teta(i))];
    w_bl = C_pqr2l * (Omega(i,2:4)' - C_bl(:,:,i)' * w_li);
    phi(i+1) = phi(i) + w_bl(1)*dt;
    teta(i+1) = teta(i) + w_bl(2)*dt;
    psi(i+1) = psi(i) + w_bl(3)*dt;
    %     dC_bl(:,:,i) = -skew(w_li)*C_bl(:,:,i) + C_bl(:,:,i)*skew(Omega(i,2:4)); % C_bl (i-1)
    C_bl(:,:,i+1) =  Euler2DCM([phi(i+1),teta(i+1),psi(i+1)])';
    
    
    
    dV_l = C_bl(:,:,i+1)*Acc(i,2:4)' + g_l - skew(w_le+2*C_el*w_ei)*V_l(:,i);
    V_l(:,i+1) = V_l(:,i) + dV_l*dt;
    
    dlat = V_l(1,i+1)/ (RM + alt(i));
    dlong =  V_l(2,i+1)/((RN + alt(i))*cos(lat(i)));
    dalt = -V_l(3,i+1);
    lat(i+1) = lat(i) + dlat*dt;
    long(i+1) = long(i) + dlong*dt;
    alt(i+1) = alt(i) + dalt*dt;
    [Pn(i),Pe(i),Pd(i),X(i),Y(i),Z(i)] =  LLLN2NED(lat(i+1),alt(i+1),(lat(i+1)-lat(1)),long(i+1)-long(1),alt(i+1)-alt(1),RN,RM);
    
end
% Error = [lat-RefTrajectory.Lat(2:end);long-RefTrajectory.Long(2:end);alt-RefTrajectory.Alt(2:end);V_l-RefTrajectory.V_NED(:,2:end);[psi;teta;phi]-RefTrajectory.Euler(:,2:end)];
% figure;
% plot3(X,Y,Z,'r')
% hold on
% plot3(RefTrajectory.X,RefTrajectory.Y,RefTrajectory.Z,'b')
% title('strapdown vs Grount truth')
% legend('strapdown','Grount truth')
end

