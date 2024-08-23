% --------------------- Visualizador -----------------------------------
% Mediante la siguiente línea de comandos se ejecutará el programa original con un test antiguo
% Si python3 no funciona, reemplazar por python
% clingo DCCarrera.lp tests/O1.lp -c bound=12 | python3 process.py

% Cabe notar que en caso de obtener un error del estilo: DCCarrera.lp:48:69-77: info: atom does not occur in any rule head:
% baton(B), esto es perfectamente normal y no implica que haya un error en el código, simplemente algunos tests no 
% contienen todos los elementos.

% El resto de los tests deberán ser probados mediante la línea (con N el número máximo de pasos para resolver el problema)
% clingo FILENAME.lp tests/TESTNAME.lp -c bound=N | python3 process.py

% Tiempo desde 1 hasta bound
time(1..bound).

% Acciones disponibles para el olimpicRobot
action(up).
action(down).
action(left).
action(right).
action(wait).
action(liftBaton).
action(jumpHurdle).
action(getDown).
action(lookUp).
action(lookDown).
action(lookLeft).
action(lookRight).

% Un olimpicRobot no puede estar encima de un obstáculo, afuera del mapa o en un bloque móvil.
:- olimpicRobotOn(R, X, Y, T, D, Z), not rangeX(X).
:- olimpicRobotOn(R, X, Y, T, D, Z), not rangeY(Y).
:- olimpicRobotOn(R, X, Y, T, D, Z), obstacle(X, Y).
:- olimpicRobotOn(R, X, Y, T, D, Z), trap(X, Y, E, T), E = 1.


%-------------------------------------------------- Actividad 1 ----------------------------------%

% TO DO Actividad 1: Completar las reglas para que el olimpicRobot se pueda moverse en todas las direcciones al ejecutarse
% Un olimpicRobot puede desplazarse en las direcciones de: arriba, abajo, izquierda, derecha y esperar
olimpicRobotOn(R, X, Y - 1, T + 1, D, Z) :- exec(R, up, T), olimpicRobotOn(R, X, Y, T, D, Z), time(T + 1).
olimpicRobotOn(R, X, Y, T + 1, D, Z) :- exec(R, wait, T), olimpicRobotOn(R, X, Y, T, D, Z), time(T + 1).
% Completar las otras direcciones

% TO DO Actividad 1: 
% Un olimpicRobot puede cambiar su mirada en 90 grados
% Completar para todas las direcciones

% Un olimpicRobot solo puede moverse a dónde mira.
:- exec(R, up, T), olimpicRobotOn(R, X, Y, T, D, Z), D != 1. % mira hacia atras
:- exec(R, down, T), olimpicRobotOn(R, X, Y, T, D, Z), D != 2. % mira hacia adelante
:- exec(R, left, T), olimpicRobotOn(R, X, Y, T, D, Z), D != 3. % mira hacia la izquierda
:- exec(R, right, T), olimpicRobotOn(R, X, Y, T, D, Z), D != 4. % mira hacia la derecha

% Un olimpicRobot ejecuta una acción en cada tiempo.
1 {exec(R, A, T) : action(A)} 1 :- olimpicRobot(R), time(T + 1).

% Minimizar el número de acciones del olimpicRobot
#minimize {1, R, T : exec(R, A, T), action(A), A != wait}.

% No se pueden cruzar olimpicRobots.
:- olimpicRobotOn(R1, X, Y, T, D, Z), olimpicRobotOn(R2, X + 1, Y, T, D, Z), olimpicRobotOn(R2, X, Y, T + 1, D, Z), olimpicRobotOn(R1, X + 1, Y, T + 1, D, Z).
:- olimpicRobotOn(R1, X, Y, T, D, Z), olimpicRobotOn(R2, X, Y + 1, T, D, Z), olimpicRobotOn(R2, X, Y, T + 1, D, Z), olimpicRobotOn(R1, X, Y + 1, T + 1, D, Z).
:- olimpicRobotOn(R, X, Y, T, D, Z), batonOn(B, X, Y, Z, T), Z = 0, baton(B), time(T).

% Un olimpicRobot no puede estar en la misma posición que una valla si es que su coordenada Z es 0
:- olimpicRobotOn(R, X, Y, T, D, 0), hurdleOn(H, X, Y), olimpicRobot(R), hurdle(H).


% OlimpicRobot esta en un objetivo en el tiempo T, para casos en el que no hay testimonio.
at_goal(R, T) :- olimpicRobotOn(R, X, Y, T, D, Z), goal(X, Y).
:- olimpicRobotOn(R, X, Y, T, D, Z), not at_goal(R, bound), olimpicRobot(R).


%-------------------------------------------------- Actividad 2 ----------------------------------%

% TO DO: Actividad 2, completar:
% Se debe definir si olimpicRobot es adyacente a una valla por la izquierda, derecha, arriba o abajo, adicionalmente debe estar mirando hacia la valla.
hurdleAdjacentToRobotToGoRight(H, R, T) :- olimpicRobotOn(R, X - 1, Y, T, 4, Z), hurdleOn(H, X, Y), olimpicRobot(R), time(T), hurdle(H).
hurdleAdjacentToRobotToGoRight(H, R, 0) :- olimpicRobotOn(R, X - 1, Y, 0, 4, Z), hurdleOn(H, X, Y), olimpicRobot(R), hurdle(H).
% Completar para todas las direcciones


% TO DO: Actividad 2
%  Si se ejecuta la acción "jumpHurdle", entonces el robot avanza hacia la posición de la valla adyacente.
% Completar para todas las direcciones


% Una vez un robotOlimpico se encuentra en una valla, entonces se ejecuta la acción "getDown", si es que no hay otra valla en el lugar donde debiese aterrizar.
hurdleAt(X,Y):- hurdleOn(H,X,Y), rangeX(X), rangeY(Y), hurdle(H).
exec(R, getDown, T):- hurdleOn(H, X, Y), olimpicRobotOn(R, X, Y, T, D, 1), time(T+1), time(T), hurdleAdjacentToRobotToGoDown(H,R,T-1), hurdle(H), not hurdleAt(X, Y+1).
exec(R, getDown, T):- hurdleOn(H, X, Y), olimpicRobotOn(R, X, Y, T, D, 1), time(T+1), time(T), hurdleAdjacentToRobotToGoUp(H,R,T-1), hurdle(H), not hurdleAt(X, Y-1).
exec(R, getDown, T):- hurdleOn(H, X, Y), olimpicRobotOn(R, X, Y, T, D, 1), time(T+1), time(T), hurdleAdjacentToRobotToGoRight(H,R,T-1), hurdle(H), not hurdleAt(X+1, Y).
exec(R, getDown, T):- hurdleOn(H, X, Y), olimpicRobotOn(R, X, Y, T, D, 1), time(T+1), time(T), hurdleAdjacentToRobotToGoLeft(H,R,T-1), hurdle(H), not hurdleAt(X-1, Y).

% TO DO: Actividad 2
% Si se ejecuta la acción "getDown", entonces el robot avanza hacia la dirección correspondiente al haber pasado la valla y vuelve a Z = 0
% Completar para todas las direcciones


% Una valla no puede estar en la misma posición que un obstáculo, una trampa o fuera de rango.
:- hurdleOn(H, X, Y), obstacle(X, Y).
:- hurdleOn(H, X, Y), not rangeX(X).
:- hurdleOn(H, X, Y), not rangeY(Y).
:- hurdleOn(H, X, Y), trap(X, Y, E, T).



%-------------------------------------------------- Actividad 3 ----------------------------------%
% Cantidad de testimonios adyacentes
batonsAdjacentToOlimpicRobot(R, T, N) :- olimpicRobot(R), N = #count{B : batonAdjacentToOlimpicRobot(B, R, T)}, time(T).
batonsAdjacentToOlimpicRobot(R, 0, N) :- olimpicRobot(R), N = #count{B : batonAdjacentToOlimpicRobot(B, R, 0)}.

% Se levanta el testimonio
1{olimpicRobotLiftBaton(R, B, T): batonAdjacentToOlimpicRobot(B, R, T)}1 :- exec(R, liftBaton, T), time(T + 1), olimpicRobot(R).

% Si hay un testimonio encima de un robot, hay una testimonio recogido. Si no está recogido el testimonio está en el piso.
batonPickedUp(B, T) :- batonOnOlimpicRobot(B, R, T). 
batonOn(B, X, Y, 0, T + 1) :- batonOn(B, X, Y, Z, T), Z = 0, not batonPickedUp(B, T + 1), time(T + 1), baton(B).

% No puede haber más de un olimpicRobot en la misma casilla y más de un testimonio en la misma casilla.
:- olimpicRobotOn(R1, X, Y, T, D1, Z1), olimpicRobotOn(R2, X, Y, T, D2, Z2), R1 != R2.
:- batonOn(B1, X, Y, Z, T), batonOn(B2, X, Y, Z, T), B1 != B2, Z = 0.

% Si el robot se mueve, el testimonio también.
batonOn(B, X, Y, 1, T) :- olimpicRobotOn(R, X, Y, T, D, Z), batonOnOlimpicRobot(B, R, T), time(T).
batonOnOlimpicRobot(B, R, T + 1) :- batonOnOlimpicRobot(B, R, T), time(T + 1).

% Testimonio esta en un objetivo en el tiempo T.
baton_at_goal(B, T) :- batonOn(B, X, Y, Z, T), goal(X, Y), olimpicRobotOn(R, X, Y, T, D, 0).
:- baton(B), not baton_at_goal(B, bound).

% El testimonio pasa a estar en la posición del olimpicRobot, levantada y este último mantiene su localización. Se indica que el olimpicRobot lleva el testimonio.
3{batonOn(B, X - 1, Y, 1, T + 1); olimpicRobotOn(R, X - 1, Y, T + 1, D, Z); batonOnOlimpicRobot(B, R, T + 1)}3 :- olimpicRobotLiftBaton(R, B, T), olimpicRobotOn(R, X - 1, Y, T, D, Z), time(T + 1), batonOn(B, X, Y, Z, T), olimpicRobot(R), Z = 0. 
3{batonOn(B, X + 1, Y, 1, T + 1); olimpicRobotOn(R, X + 1, Y, T + 1, D, Z); batonOnOlimpicRobot(B, R, T + 1)}3 :- olimpicRobotLiftBaton(R, B, T), olimpicRobotOn(R, X + 1, Y, T, D, Z), time(T + 1), batonOn(B, X, Y, Z, T), olimpicRobot(R), Z = 0.
3{batonOn(B, X, Y - 1, 1, T + 1); olimpicRobotOn(R, X, Y - 1, T + 1, D, Z); batonOnOlimpicRobot(B, R, T + 1)}3 :- olimpicRobotLiftBaton(R, B, T), olimpicRobotOn(R, X, Y - 1, T, D, Z), time(T + 1), batonOn(B, X, Y, Z, T), olimpicRobot(R), Z = 0. 
3{batonOn(B, X, Y + 1, 1, T + 1); olimpicRobotOn(R, X, Y + 1, T + 1, D, Z); batonOnOlimpicRobot(B, R, T + 1)}3 :- olimpicRobotLiftBaton(R, B, T), olimpicRobotOn(R, X, Y + 1, T, D, Z), time(T + 1), batonOn(B, X, Y, Z, T), olimpicRobot(R), Z = 0. 

% TO DO Actividad 3:
% Un robot es capaz de levantar el testimonio únicamente si está adyacente a él. Se define qué es que esté adyacente.
batonAdjacentToOlimpicRobot(B, R, T) :- olimpicRobotOn(R, X - 1, Y, T, D, Z), batonOn(B, X, Y, Z, T), olimpicRobot(R), time(T), baton(B), Z = 0.
batonAdjacentToOlimpicRobot(B, R, 0) :- olimpicRobotOn(R, X - 1, Y, 0, D, Z), batonOn(B, X, Y, Z, 0), olimpicRobot(R), baton(B), Z = 0.
% Completar para las otras direcciones.


% TO DO Actividad 3: 
% No se puede levantar el testimonio si el robot no esta adyacente

% TO DO Actividad 3: 
% Un robot no puede llevar más de un testimonio al mismo tiempo

% TO DO Actividad 3: 
% Un testimonio puede ser llevada por un único robot.


% TO DO Actividad 3: 
% Un olimpicRobot solo puede recoger un testimonio que está mirando
:- olimpicRobotLiftBaton(R, B, T), olimpicRobotOn(R, X, Y, T, D, Z), D != 1, batonOn(B, X, Y-1, Z, T), Z = 0.
% Completar para las otras direcciones.


%-------------------------------------------------- Actividad 4 ----------------------------------%

% -------- Trampas y Botones ------- %

% Regla que define la orden de desactivación de una trampa.
disableTrap(T) :- buttonActivated(X, Y, T), time(T).    

% Si una trampa no se le ha dado la orden de desactivación, seguirá estando activada en el tiempo.
trap(X, Y, S, T2) :- trap(X, Y, S, T1), time(T2), T2 = T1 + 1, not disableTrap(T2).

% TO DO Actividad 4.1: Completar la regla de que una trampa cambia su estado a desactivada cuando se da la orden de desactivación.

% Se define si el botón ha sido activado previamente
activatedEarlier(X, Y, T) :- buttonActivated(X, Y, T1), T1 < T, time(T).

% TO DO Actividad 4.2: Completar la regla de que un botón se activa cuando un olimpicRobot está en la misma posición que el botón y no se ha activado previamente.


% ------------------------- #show ---------------------------------------
#show time/1.
#show olimpicRobotOn/6.
#show batonOn/5.
#show obstacle/2.
#show hurdleOn/3.
#show rangeX/1.
#show rangeY/1.
#show goal/2.
#show exec/3.
#show trap/4.
#show button/2.


