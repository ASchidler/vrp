%Simple VRP instance. Two cycles and due to the time constraint each vehicles should take exactly one cycle
vehicle(a).vehicle(b).
cost(0,1,5).cost(1,2,5).cost(2,3,5).cost(3,0,5).
cost(0,4,5).cost(4,5,5).cost(5,6,5).cost(6,0,5).
cost(X,Y,C) :- cost(Y,X,C).

duration(0,1,1).duration(1,2,1).duration(2,3,1).duration(3,0,1).
duration(0,4,1).duration(4,5,1).duration(5,6,1).duration(6,0,1).
duration(2,6,1).duration(5,3,1).
duration(X,Y,D) :- duration(Y,X,D).

serviceTime(X,1) :- node(X).

timeLimit(10).
