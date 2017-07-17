% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).
% introduce edge variables
node(X) :- cost(X,_,_).
node(Y) :- cost(_,Y,_).

% Each vehicle driving out, has to come back in
:- route(0,_,V), not route(_,0,V).

% Check that every node has been reached
reached(Y) :- route(0,Y,_).
reached(Y) :- route(X,Y,_), reached(X).
:- node(X), not reached(X).

% Build routes, each node has at least one route incoming and at least one outgoing
{ route(X,Y,V): edge(X,Y),vehicle(V)} >= 1 :- node(Y), Y != 0.
{ route(Y,Z,V): edge(Y,Z)} >= 1 :- node(Y), route(X,Y,V), Y != 0.


#minimize{C,X,Y : route(X,Y,_), cost(X,Y,C)}.

%Temporary, each vehicle only departs once
:- route(0,X1,V), route(0,X2,V), X1 != X2.

% Verify that the routes are cycles, i.e. they end at 0 and they are connected
connected(Y,V) :- route(0,Y,V).
connected(Y,V) :- route(X,Y,V), connected(X,V).
:- route(0,_,V), not connected(0,V).
:- route(X,Y,V), not connected(Y,V), Y != 0.
:- route(X,Y,V), not connected(X,V), X != 0.