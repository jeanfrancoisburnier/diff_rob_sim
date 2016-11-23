clc; clear all; close all;

% turn avi recording ON or OFF
AVI = 0; %1 records, 0 does not
if AVI
    MyMovie = VideoWriter('diff_rob_simulation_9.avi');
    MyMovie.FrameRate = 33;
    open(MyMovie);
end

r_w = 0.03; % wheel radius
h   = 0.18; % distance between wheels

load 9_sim/x_r.res;
load 9_sim/y_r.res;
load 9_sim/theta_r.res;

load 9_sim/x_true.res;
load 9_sim/y_true.res;
load 9_sim/theta_true.res;

load 9_sim/x_path.res;
load 9_sim/y_path.res;

load 9_sim/path_size.res;

m = 50;

t       = x_r(:,1);
x_r     = x_r(:,2);
y_r     = y_r(:,2);
theta_r = theta_r(:,2);

x_true     = x_true(:,2);
y_true     = y_true(:,2);
theta_true = theta_true(:,2);

x_path = x_path(:,2);
y_path = y_path(:,2);

id = find(abs(t-15) < 1e-3);

t       = t(id:m:end);
x_r     = x_r(id:m:end);
y_r     = y_r(id:m:end);
theta_r = theta_r(id:m:end);

x_true     = x_true(id:m:end);
y_true     = y_true(id:m:end);
theta_true = theta_true(id:m:end);

x_path_tmp = x_path(id:m:end);
y_path_tmp = y_path(id:m:end);

id_size = find(path_size(:,2) > 0);
path_size = path_size(id_size(1),2); % only for one path for now -> send path number

for l = 1:length(x_path_tmp)
    if x_path_tmp(l)
        break;
    end
end

x_path = x_path_tmp(l);
y_path = y_path_tmp(l);

for j = l:length(x_path_tmp)
    if x_path(end) == x_path_tmp(j) && y_path(end) == y_path_tmp(j)
        continue;
    else
        x_path = [x_path; x_path_tmp(j)];
        y_path = [y_path; y_path_tmp(j)];
    end
end

if length(x_path) ~= path_size || length(y_path) ~= path_size
    error('Wrong path identification');
end

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

NT = length(T); % number of target

rob_map = map();

% Sim declaration
if AVI
    rob_sim1 = rob_sim_robotran(t, rob_map, AVI, MyMovie);
else
    rob_sim1 = rob_sim_robotran(t, rob_map);
end

thought_pos = [x_r, y_r, theta_r];
true_pos    = [x_true, y_true, theta_true];
desired_pos = [x_path,y_path];

% Robot declaration
rob = robotran_sim(1, T, NT, r_w, h, thought_pos, true_pos, desired_pos, rob_sim1);

while(rob.rob_sim_.getCurrentTime() < t(end))
    rob = rob.update();
    rob.display_sim();
    rob.rob_sim_ = rob.rob_sim_.update();
    pause(0.0001);
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