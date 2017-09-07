%%This solution has one limitation. One node may be used several times, but a path cannot, i.e. the node x can be used several times in a route, but not x-y-z

%First decide at what time a node is serviced. This is necessary, in case a node is visited multiple times
servicedAt(X,V,N) :-	routeOrder(_,X,N,V), services(X,V), not notServicedAt(X,V,N).
notServicedAt(X,V,N) :-	routeOrder(_,X,N,V), not servicedAt(X,V,N).
% Check if each node is serviced
:- services(X,V), not servicedAt(X,V,_).

% Next calculate all possible times, nodes are visited. In case the node is serviced, take time windows into account
% At time 0 we are at the depot. Since we can wait, this is not a problem
leftAt(0,0,V,0) :- vehicle(V).
% Calculate times the nodes are reached. First for non-serviced nodes and then for serviced
reachedAt(Y,T,V,N+1) :- leftAt(X,O,V,N), routeOrder(X,Y,N+1,V), duration(X,Y,D), T = O + D, notServicedAt(Y,V,N+1).
reachedAt(Y,A,V,N+1) :- leftAt(X,O,V,N), routeOrder(X,Y,N+1,V), duration(X,Y,D), T = O + D, servicedAt(Y,V,N+1), available(X,A), A >= T.
% Now calculate when the nodes are left, is serviced simply add the service time.
leftAt(X,T,V,N) :- reachedAt(X,T,V,N), notServicedAt(X,V,N).
leftAt(X,T,V,N) :- reachedAt(X,O,V,N), serviceTime(X,S), T = O + S, servicedAt(X,V,N).
% Now exclude all models where not every node is reached
:- route(_,X,V), not reachedAt(X,_,V,_).


% Check the travel duration
% First use the fixed points, i.e. the service nodes, by using the earliest possible arrival
travelTime(X,T,V,N) :- servicedAt(X,V,N), available(X,T), reachedAt(X,T,V,N).

:- travelTime(X,T1,V,N), travelTime(X,T2,V,N), T1 != T2.

% Now calculate back and forward
travelTime(Y,O,V,N+1) :- routeOrder(X,Y,N+1,V),	travelTime(X,T,V,N), notServicedAt(Y,V,N+1), duration(X,Y,D), O = T+D.
travelTime(X,O,V,N-1) :- routeOrder(X,Y,N,V),	travelTime(Y,T,V,N), notServicedAt(X,V,N-1), duration(X,Y,D), O = T-D.

:- travelTime(0,T1,V,0), travelTime(X,T2,V,_), timeLimit(L), T2 - T1 > L.

% May it be, that using the earliest arrival is not always optimal?
% Assume two nodes are visited, if the first one is visited at the latest possible time and the other one earliest, total time is minimal

% This does not work if an edge is used several times, this might occur in rare cases, e.g. the path 1->2<->3; assume that 3 is available before 2
% therefore the vehicle goes to 3 via 2, but has to go back to service 2, now it has to go through 3 again to reach the depot

#show travelTime/4.