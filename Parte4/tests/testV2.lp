% >> Definición del problema <<
% Se resuelve con bound = 5.
rangeY(0..3).
rangeX(0..3).

obstacle(2,1).
obstacle(2,0).
obstacle(1,1).

olimpicRobot(0..1).
hurdle(0..1).
hurdleOn(0,0,1).
hurdleOn(1,3,1).

olimpicRobotOn(0,0,0,0,2,0).
olimpicRobotOn(1,3,3,0,2,0).


goal(3,0).
goal(1,3).