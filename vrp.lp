%
%
%%%%%%%%%%%%%%%%%%%%%%% Introduce aux variables from instance
% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).
% introduce edge variables
node(X) :- cost(X,_,_).
node(Y) :- cost(_,Y,_).

%
%
%%%%%%%%%%%%%%%%%%%%%%%% Guess routes
% Each vehicle starts at the depot
routeOrder(0,0,0,V) :- vehicle(V).

% Avoid that the vehicle leaves the depot without need. Therefore explore both options: Leaving and staying at the depot after each cycle (also explore a vehicle never leaving)
leave(V,0) :- routeOrder(_,0,N,V), not stay(V,N).
stay(V,N) :- routeOrder(_,0,N,V), not leave(V,N).
% Start from the depot, if previously determined to do so
routeOrder(X,Y,N,V) :- routeOrder(_,X,N-1,V), X = 0, edge(X,Y), timeLimit(L), N <= L, not dontOrder(X,Y,N,V), leave(V,N-1).
% If not at the depot, simply choose a successor
routeOrder(X,Y,N,V) :- routeOrder(_,X,N-1,V), X != 0, edge(X,Y), timeLimit(L), N <= L, not dontOrder(X,Y,N,V).
% Avoid that the same ordinal is used twice
dontOrder(X,Y',N,V) :- routeOrder(X,Y,N,V), edge(X,Y'), Y != Y'.

%
%
%%%%%%%%%%%%%%%%%%%%%%%%% Check
% Make sure that the last node is the depot
terminates(K,V) :- routeOrder(_,0,N,V), K <= N, routeOrder(_,_,K,V).
:- routeOrder(_,_,N,V), not terminates(N,V).

% Make sure every node is serviced
{services(Y,V) : routeOrder(_,Y,_,V)}=1 :- node(Y), Y != 0.
:- node(X), not services(X,_), X != 0.


% Check that the travel duration does not exceed the allowed duration
travelTime(0,0,V) :- vehicle(V).
travelTime(N,D,V) :- travelTime(N-1,D',V), timeLimit(L), N <= L, routeOrder(X,Y,N,V), duration(X,Y,T), D = D' + T.

:- vehicle(V), 
	#sum{ST,X : serviceTime(X,ST), services(X,V)} = S, 
	travelTime(_,T,V), 
	timeLimit(L), 
	S + T > L.
	
% Optimize for costs
#minimize{C,N,V : routeOrder(X,Y,N,V), cost(X,Y,C)}.

#show routeOrder/4.
#show services/2.