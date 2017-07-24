routeLength(V,N) :- vehicle(V), N=#count{X,Y : route(X,Y,V)}.

% order visited nodes
routeOrder(0,0,0,V) :- vehicle(V).
routeOrder(X,Y,N+1,V) :- routeOrder(_,X,N,V), route(X,Y,V), routeLength(V,M), N <= M,
	not ordinalNotUsable(X,Y,N+1,V),
	not ordinalNotUsable(Y,N+1,V).

ordinalNotUsable(X,Y,K,V) :- routeOrder(X,Y,N,V), routeLength(V,M), K = N+1..M.
ordinalNotUsable(Z,N,V) :- routeOrder(X,Y,N,V), node(Z), route(X,Z,V), Z != Y.

%{ route(X,Y,V): edge(X,Y),vehicle(V)} >= 1 :- node(Y), Y != 0.
%track time, vehicle starts at depot
timePassed(0,0,V,0) :- vehicle(V).

% Non-serviced nodes
timePassed(Y,T,V,N+1) :- timePassed(X,O,V,N), routeOrder(X,Y,N+1,V), duration(X,Y,D),
	not services(Y,V), 
	T = O + D.

%serviced nodes
timePassed(Y,T,V,N+1) :- timePassed(X,O,V,N), routeOrder(X,Y,N+1,V), duration(X,Y,D),
	services(Y,V),
	serviceTime(Y,S), 
	T = O + D + S.

% Use the first serviced node as a baseline as to when the vehicle may leave the depot
startsAt(V,DT) :- vehicle(V), #min{DS: services(XS,V), timePassed(XS,DS,V,_)} = D, timePassed(X,D,V,_), available(X,T), DT = T - D, DT >= 0.

% Calculate at which points the vehicles may reach the different nodes
reachedAt(X,T,V) :- vehicle(V), timePassed(X,D,V,_), startsAt(V,ST), available(X,T), T = ST + D.

%time window constraints
:- node(X), not reachedAt(X,_,_), X != 0.