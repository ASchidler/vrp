%In this instance there is a chokepoint at the depot, i.e. every vehicle must enter and exit the successor. Otherwise it's a simple two cycle vrp problem
%Each vehicle should use one cycle

vehicle(a).vehicle(b).
cost(0,7,5).cost(7,1,5).cost(1,2,5).cost(2,3,5).cost(3,7,5).
cost(0,7,5).cost(7,4,5).cost(4,5,5).cost(5,6,5).cost(6,7,5).
cost(X,Y,C) :- cost(Y,X,C).

duration(X,Y,1) :- cost(X,Y,_).
serviceTime(X,1) :- node(X).

timeLimit(10).