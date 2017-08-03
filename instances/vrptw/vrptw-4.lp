% Case where two vehicles share a node, that can only be serviced by one vehicle
vehicle(a).vehicle(b).

cost(0,1,1).cost(1,2,1).cost(2,3,1).cost(3,0,1).
cost(0,4,1).cost(4,2,1).cost(2,5,1).cost(5,0,1).
cost(X,Y,C) :- cost(Y,X,C).

duration(X,Y,1) :- cost(X,Y,_C).

available(1,2).available(2,12).available(3,5).available(4,10).available(5,14).

serviceTime(X,1) :- node(X).

timeLimit(40).