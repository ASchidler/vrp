routeLength(V,N) :- vehicle(V), N=#count{X,Y : route(X,Y,V)}.

% order visited nodes
routeOrder(0,0,0,V) :- vehicle(V).
routeOrder(X,Y,N+1,V) :- routeOrder(_,X,N,V), route(X,Y,V), routeLength(V,M), N <= M,
	not ordinalNotUsable(X,Y,N+1,V),
	not ordinalNotUsable(Y,N+1,V).

ordinalNotUsable(X,Y,K,V) :- routeOrder(X,Y,N,V), routeLength(V,M), K = N+1..M.
ordinalNotUsable(Z,N,V) :- routeOrder(X,Y,N,V), node(Z), route(X,Z,V), Z != Y.

% Add all possibilities, where the timewindow is reachable
reachedAt(X,T,V,1) :- vehicle(V), routeOrder(0,X,1,V), available(X,T), duration(0,X,D), DT = T - D, DT >= 0.
reachedAt(Y,T,V,N+1) :- leftAt(X,O,V,N), routeOrder(X,Y,N+1,V), duration(X,Y,D), T = O + D.

% If no service required, leave immediately, otherwise add both options
leftAt(X,T,V,N) :- reachedAt(X,T,V,N), notServicedAt(X,V,N).
leftAt(X,T,V,N) :- reachedAt(X,O,V,N), serviceTime(X,S), T = O + S, servicedAt(X,V,N).

servicedAt(X,V,N) :-	reachedAt(X,T,V,N), services(X,V), not notServicedAt(X,V,N), available(X,T).
notServicedAt(X,V,N) :-	reachedAt(X,T,V,N), not servicedAt(X,V,N).

% Check if each node is serviced
:- services(X,V), not servicedAt(X,V,_).

% Verify that the taken time is consistent. I.e. that it is not calculated in a way, such that a node is never serviced.
% This may occur, if a node is used more than once. The time may have then been calculated in a way, s.t. the node is never serviced
% Note that the opposite case, where a node is serviced more than once is not a problem, since we are searching for an optimal solution, the model is optimal nonetheless

% Try to establish one timing, not define all possible timings -> easier to kill wrong solutions.