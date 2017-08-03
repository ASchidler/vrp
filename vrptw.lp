%This solution has one limitation. One node may be used several times, but a path cannot, i.e. the node x can be used several times in a route, but not x-y-z
routeLength(V,N) :- vehicle(V), N=#count{X,Y : route(X,Y,V)}.

% order visited nodes
routeOrder(0,0,0,V) :- vehicle(V).
routeOrder(X,Y,N+1,V) :- routeOrder(_,X,N,V), route(X,Y,V), routeLength(V,M), N <= M,
	not ordinalNotUsable(X,Y,N+1,V),
	not ordinalNotUsable(Y,N+1,V).

ordinalNotUsable(X,Y,K,V) :- routeOrder(X,Y,N,V), routeLength(V,M), K = N+1..M.
ordinalNotUsable(Z,N,V) :- routeOrder(X,Y,N,V), node(Z), route(X,Z,V), Z != Y.

% At time 0 we are at the depot. Since we can wait, this is not a problem
leftAt(0,0,V,0) :- vehicle(V).
% Simple adding of travel time for non-serviced nodes
reachedAt(Y,T,V,N+1) :- leftAt(X,O,V,N), routeOrder(X,Y,N+1,V), duration(X,Y,D), T = O + D, notServicedAt(Y,V,N+1).
% Use the time windows for serviced nodes
reachedAt(Y,A,V,N+1) :- leftAt(X,O,V,N), routeOrder(X,Y,N+1,V), duration(X,Y,D), T = O + D, servicedAt(Y,V,N+1), available(X,A), A >= T.


% If no service required, leave immediately, otherwise add both options
leftAt(X,T,V,N) :- reachedAt(X,T,V,N), notServicedAt(X,V,N).
leftAt(X,T,V,N) :- reachedAt(X,O,V,N), serviceTime(X,S), T = O + S, servicedAt(X,V,N).

servicedAt(X,V,N) :-	routeOrder(_,X,N,V), services(X,V), not notServicedAt(X,V,N).
notServicedAt(X,V,N) :-	routeOrder(_,X,N,V), not servicedAt(X,V,N).

% Check if each node is serviced
:- services(X,V), not servicedAt(X,V,_).
