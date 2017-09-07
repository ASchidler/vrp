% This solution has one limitation. One node may be used several times, but a path cannot, i.e. the node x can be used several times in a route, but not x-y-z

%First decide at what time a node is serviced. This is necessary, in case a node is visited multiple times
servicedAt(X,N,V) :-	routeOrder(_,X,N,V), services(X,V), not notServicedAt(X,N,V).
%notServicedAt(X,N,V) :-	routeOrder(_,X,N,V), not servicedAt(X,N,V).
notServicedAt(X,N2,V) :- servicedAt(X,N1,V), routeOrder(_,X,N2,V), N1 != N2.
notServicedAt(X,N,V) :- routeOrder(_,X,N,V), not services(X,V).
% Check if each node is serviced
:- services(X,V), not servicedAt(X,_,V).

% Next calculate all possible times, nodes are visited. In case the node is serviced, take time windows into account
% At time 0 we are at the depot. Since we can wait, this is not a problem
leftAt(0,0,0,V) :- vehicle(V).
% Calculate times the nodes are reached. First for non-serviced nodes and then for serviced
reachedAt(Y,T,N,V) :- routeOrder(X,Y,N,V), leftAt(X,O,N-1,V), duration(X,Y,D), T = O + D, notServicedAt(Y,N,V).
reachedAt(Y,A,N,V) :- routeOrder(X,Y,N,V), leftAt(X,O,N-1,V), duration(X,Y,D), T = O + D, servicedAt(Y,N,V), available(Y,A), A >= T, not alreadyReached(Y,A,N,V).
alreadyReached(X,T2,N,V) :- reachedAt(X,T1,N,V), available(X,T2), T1 != T2.
% Now calculate when the nodes are left, is serviced simply add the service time.
leftAt(X,T,N,V) :- reachedAt(X,T,N,V), notServicedAt(X,N,V).
leftAt(X,T,N,V) :- reachedAt(X,O,N,V), serviceTime(X,S), T = O + S, servicedAt(X,N,V).
% Now exclude all models where not every node is reached
:- routeOrder(_,X,N,V), not reachedAt(X,_,N,V),X != 0.
% This are just sanity statements, this should not affect anything
:- reachedAt(X,T1,N,V), reachedAt(X,T2,N,V), T1 != T2.

% Check the travel duration. As the statements above start from time 0, this may skew the total travel time.
% Here the serviced nodes are fixed in time, and then the starting time is calculated from there
% First use the fixed points, i.e. the service nodes, by using the earliest possible arrival
travelTime(X,T,N,V) :- servicedAt(X,N,V), reachedAt(X,T,N,V).
% Now calculate back and forward
travelTime(Y,O,N+1,V) :- travelTime(X,T,N,V), notServicedAt(Y,N+1,V), routeOrder(X,Y,N+1,V),	duration(X,Y,D), O = T+D.
travelTime(X,O,N-1,V) :- travelTime(Y,T,N,V), notServicedAt(X,N-1,V), routeOrder(X,Y,N,V),		duration(X,Y,D), O = T-D.
% Now verify that it does not take too long
:- travelTime(0,T1,0,V), travelTime(X,T2,_,V), timeLimit(L), T2 - T1 > L.

% This does not work if an edge is used several times, this might occur in rare cases, e.g. the path 1->2<->3; assume that 3 is available before 2
% therefore the vehicle goes to 3 via 2, but has to go back to service 2, now it has to go through 3 again to reach the depot

#show travelTime/4.