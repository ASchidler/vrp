%First decide at what time a node is serviced. This is necessary, in case a node is visited multiple times
{servicedAtTw(N,C) : routeOrder(_,Y,N,C), servicesC(Y,C)} = 1 :- node(Y), Y != 0.

% This solution has one limitation. One node may be used several times, but a path cannot, i.e. the node x can be used several times in a route, but not x-y-z
% Choose which cycle to use next
useVehicle(0,0,C,V) :- assign(C,V), not notUseVehicle(0,C,V).
useVehicle(N,T,C,V) :- assign(C,V), not notUseVehicle(N,C,V), useVehicle(N-1,_,C',V), reachedAt(0,T,_,C'), vehicleNum(N), T > 0.
notUseVehicle(N,C,V) :- useVehicle(N,_,C',V), assign(C,V), C != C'.
notUseVehicle(N+1,C,V) :- useVehicle(N,_,C,V).
notUseVehicle(N'+1,C,V) :- useVehicle(N,_,C,V), useVehicle(N',_,C',V), N' > N.

% Never choose a cycle twice
:- useVehicle(N,_,C,V), useVehicle(N',_,C,V), N != N'.

% Start cycle
leftAt(0,T,0,C) :- useVehicle(_,T,C,_).

% Calculate times the nodes are reached. First for non-serviced nodes and then for serviced. For serviced nodes several time windows may be possible, choose just one
reachedAt(Y,T,N,C) :- routeOrder(X,Y,N,C), leftAt(X,O,N-1,C), duration(X,Y,D),num(N), T = O + D, not servicedAtTw(N,C), timeLimit(L), T < 2 * L. %2* L is just a bound, may produce wrong results in edge cases
reachedAt(Y,A,N,C) :- routeOrder(X,Y,N,C), leftAt(X,O,N-1,C), duration(X,Y,D),num(N), T = O + D, servicedAtTw(N,C), available(Y,A), A >= T, not alreadyReached(Y,A,N,C).
alreadyReached(X,T',N,C) :- reachedAt(X,T,N,C), available(X,T'), T != T'.

% This are just sanity statements, this should not affect anything
:- reachedAt(X,T,N,V), reachedAt(X,T',N,V), T != T'.

% Now calculate when the nodes are left, if serviced simply add the service time.
leftAt(X,T,N,C) :- reachedAt(X,T,N,C), num(N), not servicedAtTw(N,C).
leftAt(X,T,N,C) :- reachedAt(X,O,N,C), num(N), servicedAtTw(N,C),serviceTime(X,S), T = O + S.
% Now exclude all models where not every node is reached
:- routeOrder(_,X,N,C), not reachedAt(X,_,N,C).

% Find out when the first node is hit. This is necessary since we don't have to leave the depot at time 0.
% When we have to leave is determined by the first serviced node. (Note that )
travelTime(X,T,N,C) :- servicedAtTw(N,C), reachedAt(X,T,N,C), useVehicle(0,_,C,V).
% Now calculate back
travelTime(X,O,N-1,C) :- travelTime(Y,T,N,C), not servicedAtTw(N-1,C), routeOrder(X,Y,N,C), duration(X,Y,D), O = T-D.

% Cycles where we don't service anyone are useless
:- leave(C), not servicedAtTw(_,C).

% Now verify that it does not take too long
:- travelTime(0,T,0,C), assign(C,V), assign(C',V), reachedAt(0,T',_,C'), timeLimit(L), T' - T > L.

% This does not work if an edge is used several times, this might occur in rare cases, e.g. the path 1->2<->3; assume that 3 is available before 2
% therefore the vehicle goes to 3 via 2, but has to go back to service 2, now it has to go through 3 again to reach the depot

#show travelTime/4.