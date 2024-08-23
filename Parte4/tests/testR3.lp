% >> Definición del problema <<
% Se resuelve con bound = 21.

rangeY(0..4).
rangeX(0..4).

olimpicRobot(0..1).

olimpicRobotOn(0,0,3,0,2,0).
olimpicRobotOn(1,4,4,0,2,0).

obstacle(1,4).
obstacle(1,3).
obstacle(1,2).
obstacle(1,1).
obstacle(2,1).
obstacle(3,1).
obstacle(4,1).

trap(4,3,1,0).
trap(3,3,1,0).
trap(3,4,1,0).

button(4,0).

goal(0,4).
goal(2,2).