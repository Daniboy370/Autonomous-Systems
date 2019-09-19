% ----------------- dPn vs. time ----------------- %
ind(1) = legend('$\delta \phi$', '$\sigma$');
ind(2) = ylabel('Angle $[^\circ]$');
ind(3) = xlabel('Time [s]');
ind(4) = title('$\delta \phi$ and $\sigma$ vs. time');
set(ind, 'Interpreter', 'latex', 'fontsize', 16 ); clear ind;

% ------------- Dead Estimate vs. GT ------------- %
ind(1) = legend('Estimate', 'Ground Truth', 'location', 'northeast');
ind(2) = xlabel('x [m]');
ind(3) = ylabel('y [m]');
ind(4) = zlabel('z [m]');
ind(5) = title('Estimate vs Ground Truth');
set(ind, 'Interpreter', 'latex', 'fontsize', 16 ); clear ind;

% ------------- dPn vs. time ------------- %
ind(1) = xlabel('Time [s]');
ind(2) = title('$DoO(\phi)$ vs. time');
set(ind, 'Interpreter', 'latex', 'fontsize', 16 ); clear ind;

