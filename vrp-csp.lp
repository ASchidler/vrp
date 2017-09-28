#include <csp>.

% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).
% introduce edge variables
node(X) :- cost(X,_,_).
node(Y) :- cost(_,Y,_).

% Decide which vehicle services which node
{services(Y,V) : route(X,Y,V)}=1 :- node(Y), Y != 0.
serviced(X) :- services(X,V).
%Sanity check
:- services(Y,V), services(Y,V'), V != V'.

% Guess routes
routeOrder(0,0,0,V) :- vehicle(V).

% Avoid that the vehicle leaves the depot without need. Therefore explore both options: Leaving and staying at the depot after each cycle (also explore a vehicle never leaving)
leave(V,0) :- routeOrder(_,0,N,V), not stay(V,N).
stay(V,N) :- routeOrder(_,0,N,V), not leave(V,N).
routeOrder(Y,Z,N,V) :- routeOrder(X,Y,N-1,V), Y = 0, edge(Y,Z), timeLimit(L), N <= L, not dontOrder(Z,N,V), leave(V,N-1).
% If no at the depot, simply choose a successor
routeOrder(Y,Z,N,V) :- routeOrder(X,Y,N-1,V), Y != 0, edge(Y,Z), timeLimit(L), N <= L, not dontOrder(Z,N,V).
% Avoid that the same ordinal is used twice
dontOrder(Y',N,V) :- routeOrder(X,Y,N,V), edge(X,Y'), Y != Y'.

% Make sure that the last node is the depot
terminates(K,V) :- routeOrder(_,0,N,V), K <= N, routeOrder(_,_,K,V).
:- routeOrder(_,_,N,V), not terminates(N,V).

% Make sure every node is serviced
:- node(X), not serviced(X), X != 0.

%%%%
route(X,Y,V) :- routeOrder(X,Y,N,V).


% Check duration
&sum {travelDuration(0,V)} = 0 :- vehicle(V).
&sum {travelDuration(P,V);D} = travelDuration(N) :- routeOrder(X,Y,N,V), duration(X,Y,D), P = N - 1.
:- timeLimit(L), vehicle(V), &sum {travelDuration(L,V)} <= L.

%:- vehicle(V), 
%	#sum{ST,X : serviceTime(X,ST), services(X,V)} = S, 
%	#sum{D,X,Y : duration(X,Y,D), route(X,Y,V)} = T, 
%	timeLimit(L), 
%	S + T > L.
	
% Optimize for costs
%#minimize{C,X,Y,N,V : routeOrder(X,Y,N,V), cost(X,Y,C)}.
#minimize{C,X,Y,V : route(X,Y,V), cost(X,Y,C)}.

#show routeOrder/4.
#show services/2.