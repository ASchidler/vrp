#include <csp>.

% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).
% introduce edge variables
node(X) :- cost(X,_,_).
node(Y) :- cost(_,Y,_).

% Decide which vehicle services which node
%{services(Y,V) : route(X,Y,V)}=1 :- node(Y), Y != 0.
%serviced(X) :- services(X,V).
%Sanity check
%:- services(Y,V), services(Y,V'), V != V'.

% Guess routes
num(L) :- timeLimit(L).
num(N-1) :- num(N), N > 1.
&dom{0..L} = routeLength(V) :- vehicle(V), timeLimit(L).
&dom{0;1} = useEdge(X,Y,N,V) :- edge(X,Y), num(N), vehicle(V). 
&sum{useEdge(X,Y,N,V) : edge(X,Y)} = 1 :- vehicle(V), num(N), &sum{routeLength(V)} >= N.
&sum{useEdge(X,Y,N,V) : edge(X,Y)} = 0 :- vehicle(V), num(N), &sum{routeLength(V)} < N.

%&show{useEdge(X,Y,N,V) : edge(X,Y), num(N), vehicle(V)}.
routeOrder(X,Y,N,V) :- &sum{useEdge(X,Y,N,V)} = 1,edge(X,Y), num(N), vehicle(V).

%Can this definition be used?
%&dom{X} = nodeAt(N,V) :- num(N), vehicle(V), node(X).

% Starts at the depot
:- routeOrder(X,_,1,V), X != 0.
% Is connected
:- routeOrder(_,X,N-1,V), routeOrder(X',_,N,V), X != X'.
% Terminates at the depot
terminates(K,V) :- routeOrder(_,0,N,V), num(K), K <= N.
:- routeOrder(_,X,N,V), not terminates(N,V).

% Services every node
reaches(X,V) :- routeOrder(_,X,_,V), X != 0.
&dom{0;1} = services(X,V) :- vehicle(V), node(X), reaches(X,V).
&dom{0} = services(X,V) :- vehicle(V), node(X), not reaches(X,V).
&sum{services(X,V) : vehicle(V)} = 1 :- node(X), X != 0.

% Time limit
&sum{useEdge(X,Y,N,V) * D : duration(X,Y,D), num(N)} = travelTime(V) :-  vehicle(V).
&sum{services(X,V) * ST : serviceTime(X,ST)} = serviceTime(V) :- vehicle(V).
:- timeLimit(L), vehicle(V), &sum{travelTime(V); serviceTime(V)} > L.

&minimize{useEdge(X,Y,N,V) * C : cost(X,Y,C), num(N), vehicle(V)}.

#show routeOrder/4.
%#show services/2.