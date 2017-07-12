% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).

:- route(0,_), not route(_,0).

reached(Y) :- route(0,Y).
reached(Y) :- route(X,Y), reached(X).
:- node(X), not reached(X).

{ route(X,Y): edge(X,Y)} = 1 :- node(X), X != 0.
{ route(X,Y): edge(X,Y)} = 1 :- node(Y), Y != 0.

%Each node is serviced by a vehicle
{service(X,K) : vehicle(K)} = 1 :- node(X), X != 0.
%Adjacent vehicles on a route have the same service vehicle (i.e. one route is serviced by one verhicle)
:- route(X,Y), service(X,K1), service(Y,K2), K1 != K2, X != 0, Y != 0.

%Each vehicle leaves the depot only once
:- route(0,X1), route(0,X2), service(X1,K1), service(X2,K2), X1 != X2, K1 = K2.

#minimize{C,X,Y : route(X,Y), cost(X,Y,C)}.

%time window constraints
reachedAt(X,T) :- route(0,X), available(X,T).
reachedAt(Y,T+D) :- route(X,Y), reachedAt(X,T), duration(X,Y,D), available(Y,T+D), Y != 0.

:- node(X), not reachedAt(X,_), X != 0.