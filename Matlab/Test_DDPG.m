%% Quadcopter Trajectory Evaluation Script
% This script demonstrates a cascaded DDPG control framework implemented in Simulink
% for autonomous drone trajectory tracking.
%
% Note:
% Trained agent files are not included in this repository.
% Please build your prefer Actor and Critc Network.
% Please use your own trained agents to run the simulation.

clear; clc; close all;

%% Reproducibility
rng(5, 'twister');

%% Simulation Parameters
TsSim = 0.01;          % Simulation sample time
Tf    = 50;            % Final time (s)
m     = 1;             % Vehicle mass (kg)
g     = 9.81;          % Gravity (m/s^2)

%% Load Simulink Model
mdl = 'Sim_DDPG';
open_system(mdl)

%% Load Trained Agents
% Replace with your own trained agent files
load('YOUR_POSITION_AGENT.mat', 'agent');
agent.SampleTime = TsSim;

load('YOUR_ATTITUDE_AGENT.mat', 'agent2');
agent2.SampleTime = TsSim;

%% Select Initial Condition
% Available conditions are defined below in the IC matrix
condIdx = 9;

IC = [ ...
     0   0;
     0   5;
     5   0;
     5   5;
    -5  -5;
    -5   0;
     0  -5;
    -5   5;
     5  -5];

x0 = IC(condIdx, 1);
y0 = IC(condIdx, 2);
z0 = 0;

u0 = 0; v0 = 0; w0 = 0;
phi0 = 0; theta0 = 0; psi0 = 0;
p0 = 0; q0 = 0; r0 = 0;

%% Load Saved Trajectory Results
% Replace these with your own saved evaluation result files
load('cond1.mat');
load('cond2.mat');
load('cond3.mat');
load('cond4.mat');
load('cond5.mat');
load('cond6.mat');
load('cond7.mat');
load('cond8.mat');
load('cond9.mat');

trajectorySet = {cond1, cond2, cond3, cond4, cond5, cond6, cond7, cond8, cond9};

%% Reference Trajectory
refX = cond1.X_ref(:,1);
refY = cond1.X_ref(:,2);
refZ = -cond1.X_ref(:,3);

%% Labels for Initial Conditions
trajLabels = { ...
    '(0,0)', '(0,5)', '(5,0)', ...
    '(5,5)', '(-5,-5)', '(-5,0)', ...
    '(0,-5)', '(-5,5)', '(5,-5)'};

plotColors = lines(numel(trajectorySet));

%% 3D Trajectory Plot
figure;
plot3(refX, refY, refZ, 'b', 'LineWidth', 2);
hold on;

for k = 1:numel(trajectorySet)
    x = trajectorySet{k}.X(:,1);
    y = trajectorySet{k}.X(:,2);
    z = -trajectorySet{k}.X(:,3);

    plot3(x, y, z, '--', ...
        'LineWidth', 1.8, ...
        'Color', plotColors(k,:));
end

grid on;
box on;
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('3D Trajectory Tracking Performance');
xlim([-6 6]);
ylim([-6 6]);
zlim([0 50]);
view(3);
legend(['Reference', trajLabels], 'Location', 'best');
hold off;
