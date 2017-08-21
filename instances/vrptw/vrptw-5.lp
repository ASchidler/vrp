% Case where two vehicles share the same first node
% This illustrates a bug, where the first node needed to be available, no matter if the vehicle served it or not.
vehicle(a).vehicle(b).

cost(0,1,1).cost(1,2,1).cost(2,3,1).cost(3,0,1).
cost(1,4,1).cost(4,5,1).cost(5,0,2).
cost(X,Y,C) :- cost(Y,X,C).

duration(X,Y,1) :- cost(X,Y,_C).

available(1,2).available(2,4).available(3,6).
available(4,10).available(5,12).

serviceTime(X,1) :- node(X).

timeLimit(10).