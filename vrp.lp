%
%
%%%%%%%%%%%%%%%%%%%%%%% Introduce aux variables from instance
% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).
% introduce edge variables
node(X) :- cost(X,_,_).
node(Y) :- cost(_,Y,_).

% Finding a tight heuristic minimizes grounding
num(1..L) :- timeLimit(T), T * 3/ 2 = L.
vehicleNum(1..M) :- #count{V:vehicle(V)} = C, 3 * C = M.

%
%
%%%%%%%%%%%%%%%%%%%%%%%% Guess routes

% Avoid that the vehicle leaves the depot without need. Therefore explore both options: Leaving and staying at the depot after each cycle (also explore a vehicle never leaving)
leave(1).
routeOrder(0,Y,1,V) :- leave(V), edge(0,Y), not dontOrder(0,Y,1,V).
% If not at the depot, simply choose a successor
routeOrder(X,Y,N,V) :- routeOrder(_,X,N-1,V), X != 0, edge(X,Y), num(N), not dontOrder(X,Y,N,V).
% Avoid that the same ordinal is used twice
dontOrder(X,Y',N,V) :- routeOrder(X,Y,N,V), edge(X,Y'), Y != Y'.

% If route ends at the depot, start new cycle, if there are unvisited nodes
leave(V) :- node(X), vehicleNum(V), visited(0,V-1), V > 1, not visited(X,V-1).
visited(X,V) :- routeOrder(_,X,_,V).
visited(X,V) :- visited(X,V-1), leave(V).

% Each route must terminate
:- leave(V), not visited(0,V).

%
%
%%%%%%%%%%%%%%%%%%%%%% Vehicle assignment, instroduces symmetries
assign(C,V) :- leave(C), vehicle(V), not notAssign(C,V).
notAssign(C,V') :- assign(C,V), vehicle(V'), V != V'.

%
%
%%%%%%%%%%%%%%%%%%%%%%%%% Check

% Make sure every node is serviced, instroduces symmetries
servicesC(X,C) :- routeOrder(_,X,_,C), X != 0, not notServices(X,C).
notServices(X,C) :- servicesC(X,C'), leave(C), C' != C.
:- node(X), not servicesC(X,_), X != 0.

% This is needed to avoid counting the service time multiple times
servicesAt(X,N,C) :- servicesC(X,C), routeOrder(_,X,N,C), not notServicesAt(X,N,C).
notServicesAt(X,N,C) :- servicesAt(X,N',C), routeOrder(_,X,N,C), N != N'.
% Kill Symmetry, i.e. always choose the first time entering as servicing time
:- servicesAt(X,N,C), notServicesAt(X,N',C), N' < N.

% Calculate the travel time for each cycle
travelTime(0,0,C) :- leave(C).
travelTime(N,D,C) :- travelTime(N-1,D',C), num(N), routeOrder(X,Y,N,C), duration(X,Y,T), timeLimit(L), L >= D, D = D' + T, not servicesAt(Y,N,C).
travelTime(N,D,C) :- travelTime(N-1,D',C), num(N), routeOrder(X,Y,N,C), duration(X,Y,T), timeLimit(L), L >= D, D = D' + T + ST, servicesAt(Y,N,C), serviceTime(Y,ST).
travelTime(D,C) :- routeOrder(_,0,N,C), travelTime(N,D,C).
% This occurs whenever a cycle exceeds the time limit
:- leave(C), not travelTime(_,C).

% Aggregate times for vehicles
vehicleTime(0,0,V) :- vehicle(V).
vehicleTime(T,C,V) :- vehicleTime(T',C-1,V), vehicleNum(C), assign(C,V), travelTime(D,C), T = T' + D, timeLimit(L), T <= L.
vehicleTime(T,C,V) :- vehicleTime(T,C-1,V), vehicleNum(C), not assign(C,V).
% Time limit exceeded
:- leave(C), vehicle(V), not vehicleTime(_,C,V).

% Optimize for costs
#minimize{C,N,V : routeOrder(X,Y,N,V), cost(X,Y,C)}.

% For display
services(X,V) :- servicesC(X,C), assign(C,V).

#show routeOrder/4.
#show services/2.
#show assign/2.

%
%
%%%%%%%%%%%% Symmetry Breaking
% The first vehicle goes first.
drives(V) :- assign(C,V).
:- drives(V), vehicle(V'), V > V', not drives(V').

% Order entering the first node by vehicle ordering
:- routeOrder(0,X,1,V), routeOrder(0,X',1,V'), V < V', X > X'.

% No edge should be used twice, that makes no sense in the VRP scenario (but may be useful in the time window extension)
:- routeOrder(X,Y,N,V), routeOrder(X,Y,N',V), N != N'.

% Set a goal for each new cycle. Use minimum to make it deterministic.
unvisited(X,V-1) :- leave(V), node(X), X != 0, not visited(X,V-1).
goal(X,V) :-  #min{X': unvisited(X',V-1)} = X, leave(V).
% The leave check is just so the aggregate above is guaranteed to be calculated at this point
:- goal(X,V-1), not visited(X,V-1), leave(V).