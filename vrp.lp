% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).
% introduce edge variables
node(X) :- cost(X,_,_).
node(Y) :- cost(_,Y,_).

% Build routes, each node has at least one route incoming and at least one outgoing
{ route(X,Y,V): edge(X,Y),vehicle(V)} >= 1 :- node(Y), Y != 0.
{ route(Y,Z,V): edge(Y,Z)} >= 1 :- node(Y), route(X,Y,V), Y != 0.

% Decide which vehicle services which node
{services(Y,V) : route(X,Y,V)}=1 :- node(Y), Y != 0.

% Verify that the routes are cycles, i.e. they end at 0 and they are connected
starts(V) :- route(0,_,V).
connected(Y,V) :- route(0,Y,V).
connected(Y,V) :- route(X,Y,V), connected(X,V).
:- starts(V), not connected(0,V).
:- route(X,Y,V), not connected(Y,V), Y > 0.
:- route(X,Y,V), not connected(X,V), X > 0.

% Check that the routes really terminate at 0. This may fail for the above statements if a vehicle drives several routes
terminates(X,V) :- route(X,0,V).
terminates(X,V) :- route(X,Y,V), terminates(Y,V).
:- route(_,Y,V), Y !=0, not terminates(Y,V).

% Verify that each vehicle does not take too long
% This only approximates the solution, as multiple visits to the same node may dilute this calcualation
:- vehicle(V), 
	#sum{ST,X : serviceTime(X,ST), services(X,V)} = S, 
	#sum{D,X,Y : duration(X,Y,D), route(X,Y,V)} = T, 
	timeLimit(L), 
	S + T > L.

% order visited nodes
routeLength(V,N) :- vehicle(V), N=#count{X,Y : route(X,Y,V)}.
routeOrder(0,0,0,V) :- vehicle(V).
routeOrder(X,Y,N+1,V) :- nodeOrder(X,N,V), route(X,Y,V), routeLength(V,M), N < M,
	#count{X',Y' : routeOrder(X',Y',N+1,V), X' != X} = 0,
	#count{X',Y' : routeOrder(X',Y',N+1,V), Y' != Y} = 0,
	#count{N' : routeOrder(X,Y,N',V), N' != N + 1} = 0.
	
nodeOrder(X,N,V) :- routeOrder(_,X,N,V).
ordinaled(X,Y,V) :- routeOrder(X,Y,_,V).
:- route(X,Y,V), not ordinaled(X,Y,V).
% This prevents from routes where one path is used several times. This is in principle legitimate, but not supported by this application
:- routeLength(V,N), not routeOrder(_,0,N,V).
	
% Optimize for costs
#minimize{C,X,Y,V : route(X,Y,V), cost(X,Y,C)}.

#show route/3.
#show services/2.