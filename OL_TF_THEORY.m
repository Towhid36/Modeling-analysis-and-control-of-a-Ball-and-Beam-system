m = 0.01;
R = 0.025;
g = -9.8;
L = .3;
d = 0.02;
J = 4.16*10^-6;


s = tf('s');
P_ball = -m*g*d/L/(J/R^2+m)/s^2
step(P_ball)