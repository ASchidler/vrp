% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).
% introduce edge variables
node(X) :- cost(X,_,_).
node(Y) :- cost(_,Y,_).

% Build routes, each node has at least one route incoming and at least one outgoing
{ route(X,Y,V): edge(X,Y),vehicle(V)} >= 1 :- node(Y), Y != 0.
{ route(Y,Z,V): edge(Y,Z)} >= 1 :- node(Y), route(X,Y,V), Y != 0.


% Verify that the routes are cycles, i.e. they end at 0 and they are connected
terminates(X,V) :- route(X,0,V).
terminates(X,V) :- route(X,Y,V), terminates(Y,V).
:- route(_,Y,V), Y !=0, not terminates(Y,V).
starts(V) :- route(0,_,V).
:- route(X,Y,V), not starts(V).

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

#show route/3.
#show services/2.