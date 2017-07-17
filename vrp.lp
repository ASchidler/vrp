% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).
% introduce edge variables
node(X) :- cost(X,_,_).
node(Y) :- cost(_,Y,_).

% Build routes, each node has at least one route incoming and at least one outgoing
{ route(X,Y,V): edge(X,Y),vehicle(V)} >= 1 :- node(Y), Y != 0.
{ route(Y,Z,V): edge(Y,Z)} >= 1 :- node(Y), route(X,Y,V), Y != 0.


% Verify that the routes are cycles, i.e. they end at 0 and they are connected
connected(Y,V) :- route(0,Y,V).
connected(Y,V) :- route(X,Y,V), connected(X,V).
:- route(0,_,V), not connected(0,V).
:- route(X,Y,V), not connected(Y,V), Y != 0.
:- route(X,Y,V), not connected(X,V), X != 0.

% Decide which vehicle services which node
{services(Y,V) : route(X,Y,V)}=1 :- node(Y), Y != 0.

% Verify that each vehicle does not take too long
:- vehicle(V), 
	#sum{ST,X : serviceTime(X,ST), services(X,V)} = S, 
	#sum{D,X,Y : duration(X,Y,D), route(X,Y,V)} = T, 
	timeLimit(L), 
	S + T > L.
	
	
% Optimize for costs
#minimize{C,X,Y,V : route(X,Y,V), cost(X,Y,C)}.