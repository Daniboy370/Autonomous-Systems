%%
% roslaunch acl_ros pioneer3at_world.launch
 rosshutdown

%% Initialization
close all
clear all
clc

rosinit
global robot_path robot_az rate runNum b c
%% Topics
Odom_topic = rossubscriber('/pioneer/odom');
Vel_topic = rospublisher('/pioneer/cmd_vel');
rate = 0.2;
%% Goals
Goal(1).loc = [-0.9 -0.2 0]';
Goal(1).Orien = deg2rad(2.4);
Goal(2).loc = [-0.9 1 0]';
Goal(2).Orien = deg2rad(0);
Goal(3).loc = [1 1 0]';
Goal(3).Orien = deg2rad(-90);
Goal(4).loc = [1 -1 0]';
Goal(4).Orien = deg2rad(90);


%% Execute
SafetyHalt(Vel_topic);
b = 1;
c = 1;
for k=1:length(Goal)
    MyController(Goal(k),Odom_topic,Vel_topic);
end

%% Plot
figure(1)
hold on
box on
grid on
scatter(robot_path(1,:),robot_path(2,:))
set(gca,'FontSize',14)
title('Robot Path','FontSize',20)
xlabel('X [m]','FontSize',14)
ylabel('Y [m]','FontSize',14)

figure(2)
hold on
box on
grid on
plot(robot_az(2,:),rad2deg(robot_az(1,:)),'LineWidth',2)
set(gca,'FontSize',14)
title('Robot Azimuth','FontSize',20)
xlabel('Time [s]','FontSize',14)
ylabel('Azimuth [Deg]','FontSize',14)