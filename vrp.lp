%
%
%%%%%%%%%%%%%%%%%%%%%%% Introduce aux variables from instance
% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).
% introduce edge variables
node(X) :- cost(X,_,_).
node(Y) :- cost(_,Y,_).

% Finding a tight heuristic minimizes grounding
num(1..L) :- timeLimit(T), T / 2 = L.
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

% Set a goal for each new cycle. Use minimum to make it deterministic.
unvisited(X,V-1) :- leave(V), node(X), not visited(X,V-1).
goal(X,V) :-  #min{X': unvisited(X',V-1)} = X, leave(V).
:- goal(X,V-1), leave(V), not visited(X,V-1).

%
%
%%%%%%%%%%%%%%%%%%%%%% Vehicle assignment, instroduces symmetries
assign(C,V) :- leave(C), vehicle(V), not notAssign(C,V).
notAssign(C,V') :- assign(C,V), vehicle(V'), V != V'.

%
%
%%%%%%%%%%%%%%%%%%%%%%%%% Check

% Make sure every node is serviced, instroduces symmetries
services(X,V) :- routeOrder(_,X,_,C), assign(C,V), not notServices(X,V).
notServices(X,V) :- services(X,V'), vehicle(V), V' != V.
:- node(X), not services(X,_), X != 0.

% Check that the travel duration does not exceed the allowed duration
travelTime(0,0,V) :- leave(V).
travelTime(N,D,V) :- travelTime(N-1,D',V), num(N), routeOrder(X,Y,N,V), duration(X,Y,T), D = D' + T. 
travelTime(D,V) :- routeOrder(_,0,N,V), travelTime(N,D,V).

:- vehicle(V), 
	#sum{ST,X : serviceTime(X,ST), services(X,C), assign(C,V)} = S, 
	#sum{D,C : travelTime(D,V), assign(C,V)} = T, 
	timeLimit(L), 
	S + T > L.
	
% Optimize for costs
#minimize{C,Y,N,V : routeOrder(X,Y,N,V), cost(X,Y,C)}.

#show routeOrder/4.
#show services/2.


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