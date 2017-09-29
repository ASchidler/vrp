#include <csp>.

%
%
%%%%%%%%%%%% Restructure input
% introduce edge variables if necessary
edge(X,Y) :- cost(X,Y,_).
% introduce edge variables
node(X) :- cost(X,_,_).
node(Y) :- cost(_,Y,_).

%
%
%%%%%%%%%%%%% Assign ascending ordinals to nodes
nodeCount(M-1) :- #count{X : node(X)} = M. %M-1 so we have to ordinal for 0
nodeNum(1..M) :- nodeCount(M).
% This is a default
ordinal(0,0).
% Assign each node an ordinal.
ordinal(X,N) :- nodeNum(N), node(X), node(X'), ordinal(X',N'), not notOrdinal(X,N).
% Avoid assigning the same ordinal twice
notOrdinal(X',N) :- ordinal(X,N), node(X'), X' != X. 
% Avoid assigning two ordinals to one node
notOrdinal(X,N') :- ordinal(X,N), nodeNum(N'), N != N'.
% Enforce that the ordinals have the same order as the nodes, i.e. the ordering is unique -> kills symmetries.
:- ordinal(X,N), ordinal(X',N'), X < X', N > N'.

%
%
%%%%%%%%%%%%%% Guess routes
num(1..L) :- timeLimit(L).

&dom{0..L} = routeLength(V) :- vehicle(V), timeLimit(L).
&dom{0..M}	= nodeAt(N,V) :- num(N), vehicle(V), nodeCount(M).
&sum{nodeAt(N,V)} = 0 :- vehicle(V), num(N), &sum{routeLength(V)} <= N.

% This would probably be better, but does not work. Results in unbounded warnings.
%&dom{0..M}	= nodeAt(N,V) :- num(N), vehicle(V), &sum{routeLength(V)} > N, nodeCount(M).
%&dom{0}	= nodeAt(N,V) :- num(N), vehicle(V), &sum{routeLength(V)} <= N.

% Get the route from the CSP variables
length(L-1,V) :- vehicle(V), num(L), &sum{routeLength(V)} = L-1.
vehicleAt(0,0,V) :- vehicle(V).
vehicleAt(X,N,V) :- ordinal(X,O), vehicle(V),num(N), &sum{nodeAt(N,V)} = O, length(L,V), N <= L.
% Check that the transitions are valid
:- vehicleAt(Y,N,V), vehicleAt(X,N-1,V), num(N), not edge(X,Y).

% Services every node
reaches(X,V) :- vehicleAt(X,_,V), X != 0.
&dom{0;1} = services(X,V) :- vehicle(V), node(X), reaches(X,V).
&dom{0} = services(X,V) :- vehicle(V), node(X), not reaches(X,V).
&sum{services(X,V) : vehicle(V)} = 1 :- node(X), X != 0.

% Time limit
travelTime(0,0,V) :- vehicle(V).
travelTime(N,D,V) :- travelTime(N-1,D',V), length(L,V), N <= L, vehicleAt(Y,N,V), vehicleAt(X,N-1,V), duration(X,Y,T), D = D' + T.

timeLeft(T,V) :- vehicle(V), length(M,V), travelTime(M,T',V), timeLimit(L), T = L - T'.
&sum{services(X,V) * ST : serviceTime(X,ST)} = serviceTime(V) :- vehicle(V).
:- timeLeft(T,V), vehicle(V), &sum{serviceTime(V)} > T.

%&minimize{useEdge(X,Y,N,V) * C : cost(X,Y,C), num(N), vehicle(V)}.
#minimize{C,N,V : vehicleAt(Y,N,V), vehicleAt(X,N-1,V), cost(X,Y,C)}.

#show vehicleAt/3.
%#show services/2.