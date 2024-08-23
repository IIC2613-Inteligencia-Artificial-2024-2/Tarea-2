% >> Definición del problema <<
% Se resuelve con bound = 5.

rangeY(0..3).
rangeX(0..3).

obstacle(1,1).
obstacle(1,0).

olimpicRobot(0..1).
hurdle(0..1).
hurdleOn(0,0,1).
hurdleOn(1,3,3).

olimpicRobotOn(0,0,0,0,2,0).
olimpicRobotOn(1,3,0,0,2,0).

goal(1,2).
goal(1,3).