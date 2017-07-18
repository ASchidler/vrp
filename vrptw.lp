%track time, vehicle starts at depot
timePassed(0,0,V,0) :- vehicle(V).

% Non-serviced nodes
timePassed(Y,T,V,X) :- timePassed(X,O,V,_), route(X,Y,V), duration(X,Y,D), 
	%#max{OS : timePassed(_,OS,V,_)} = O, %Only use the previous
	not services(Y,V), 
	T = O + D,
	#count{DS : timePassed(Y,DS,V,X)} = 0.
	%not timePassed(Y,_,V,X). %Only once per edge

%serviced nodes
%timePassed(Y,T,V,X) :- timePassed(X,O,V,_), route(X,Y,V), duration(X,Y,D), 
%	#max{OS : timePassed(_,OS,V,_)} = O, %Only use the previous
%	services(Y,V),
%	serviceTime(Y,S), 
%	T = O + D + S,
%	not timePassed(Y,_,V,X). %Only once per edge

% Use the first serviced node as a baseline as to when the vehicle may leave the depot
%startsAt(V,DT) :- vehicle(V), #min{DS: services(XS,V), timePassed(XS,DS,V,_)} = D, timePassed(X,D,V,_), available(X,T), DT = T - D, DT >= 0.

% Calculate at which points the vehicles may reach the different nodes
%reachedAt(X,T,V) :- vehicle(V), timePassed(X,D,V,_), startsAt(V,ST), T = ST + D.

%time window constraints
%:- node(X), not reachedAt(X,_,_), X != 0.