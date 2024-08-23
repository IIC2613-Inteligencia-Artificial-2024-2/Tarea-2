% >> Definición del problema <<
% Se resuelve con bound = 7.
rangeY(0..3).
rangeX(0..4).

obstacle(2,3).
obstacle(3,1).
obstacle(4,1).

olimpicRobot(0..1).
hurdle(0..1).
hurdleOn(0,2,0).
hurdleOn(1,2,2).

olimpicRobotOn(0,0,1,0,2,0).
olimpicRobotOn(1,4,2,0,2,0).


goal(3,0).
goal(0,3).