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

% Check the travel duration
% First use the fixed points, i.e. the service nodes, by using the earliest possible arrival
travelTime(X,T,V,N) :- servicedAt(X,V,N), available(X,T), reachedAt(X,T,V,N).

:- travelTime(X,T1,V,N), travelTime(X,T2,V,N), T1 != T2.

% Now calculate back and forward
travelTime(Y,O,V,N+1) :- routeOrder(X,Y,N+1,V),	travelTime(X,T,V,N), notServicedAt(Y,V,N+1), duration(X,Y,D), O = T+D.
travelTime(X,O,V,N-1) :- routeOrder(X,Y,N,V),	travelTime(Y,T,V,N), notServicedAt(X,V,N-1), duration(X,Y,D), O = T-D.

:- travelTime(0,T1,V,0), travelTime(X,T2,V,_), timeLimit(L), T2 - T1 > L.

#show travelTime/4.