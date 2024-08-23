% >> Definición del problema <<
% Se resuelve con bound = 23.

rangeY(0..4).
rangeX(0..4).

olimpicRobot(0..1).

olimpicRobotOn(0,0,0,0,2,0).
olimpicRobotOn(1,4,0,0,2,0).

obstacle(0,1).
obstacle(0,2).
obstacle(0,3).
obstacle(2,2).
obstacle(2,3).
obstacle(2,4).
trap(3,2,1,0).
trap(4,2,1,0).
button(0,4).
goal(3,4).
goal(4,4).