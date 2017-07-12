edge(X,Y) :- cost(X,Y,_).

:- route(0,_,K), not route(_,0,K).
:- route(_,_,K), not vehicle(K).

reached(Y) :- route(0,Y,_).
reached(Y) :- route(X,Y,_), reached(X).
:- node(X), not reached(X).

:- route(X,Y,K1), route(X,Y,K2), K1 != K2.

{ route(X,Y,K): edge(X,Y)} = 1 :- node(X), vehicle(K), X != 0.
{ route(X,Y,K): edge(X,Y)} = 1 :- node(Y), vehicle(K), Y != 0.

#minimize{C,X,Y : route(X,Y,_), cost(X,Y,C)}.
