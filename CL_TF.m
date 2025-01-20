% Define the Laplace variable 's'
s = tf('s');

% PID controller parameters
Kp = 2.05;
Ki = 0.001;
Kd = 0.2;

% PID controller transfer function
C_s = Kp + Ki/s + Kd*s;

% Plant transfer function (given)
P_ball_s = 0.3923 / s^2;

% Closed-loop transfer function
T_s = (C_s * P_ball_s) / (1 + C_s * P_ball_s);

% Canonical transfer function (with matching poles and DC gain)
Canonical = Ki / (s^2 + (1 + Kp)*s + Ki);

% Display the transfer functions
disp('Closed-loop Transfer Function (T_s):');
T_s

disp('Canonical Transfer Function (Canonical):');
Canonical

% Step response of the closed-loop system with zero
figure;
step(T_s);
hold on;

% Step response of the canonical system
step(Canonical, 'r--');

% Labeling the plot
ylabel('Output Voltage (Volts)');
title('Closed-loop Step Response');
legend('With Zero', 'Without Zero');
