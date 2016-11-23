clc; clear all; close all;

% turn avi recording ON or OFF
AVI = 0; %1 records, 0 does not
if AVI
    MyMovie = VideoWriter('path_regulation.avi');
    MyMovie.FrameRate = 20;
    open(MyMovie);
end

r_w = 0.03; % wheel radius
h   = 0.18; % distance between wheels
dt = 0.05;
t_max = 60;

N = floor(t_max/dt);

gamma = zeros(1,N);
t     = zeros(1,N);

xr = zeros(1,N);
yr = zeros(1,N);
tr = zeros(1,N);

% Robot initial position initialization
xr(1) = 0.67;
yr(1) = 1.15;
tr(1) = -pi/2;

% Target declaration
t1 = target(0.7,0.6);
t2 = target(0.1,0.0);
t3 = target(0.7,-0.6);
t4 = target(0.25,-1.25);
t5 = target(-0.4,-0.6);
t6 = target(-0.8,0.0);
t7 = target(-0.4,0.6);
t8 = target(0.25,1.25);

T = [t1,t2,t3,t4,t5,t6,t8];
% x = 0.08:0.08:4;
% T = [];
% for i = 1:length(x)
%     ti = target(x(i),sin(x(i)*2*pi));
%     T = [T , ti];
% end

NT = length(T); % number of target

rob_map = map();

% Sim declaration
if AVI
    rob_sim1 = rob_sim(dt,t, t_max, rob_map, AVI, MyMovie);
else
    rob_sim1 = rob_sim(dt,t, t_max, rob_map);
end

% Robot declaration
rob = diff_rob(1,T,NT,r_w,h,xr,yr,tr, gamma, rob_sim1);

while(rob.rob_sim_.getCurrentTime() <= t_max)
    rob = rob.compute_new_speed();
    rob.display_sim();
    rob = rob.update();
    pause(0.05);
end

% adds a new frames to the movie and close it
if AVI
    for k = 1:20
        frame = getframe(1);
        writeVideo(MyMovie,frame);
    end
    close(MyMovie);
end

disp('Sim end');