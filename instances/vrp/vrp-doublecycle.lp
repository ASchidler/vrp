% Simple VRP problem with two cycles. As there is only one vehicle it should visit both cycles
vehicle(a).
cost(0,1,1).cost(1,2,1).cost(2,3,1).cost(3,0,1).
cost(0,4,1).cost(4,5,1).cost(5,6,1).cost(6,0,1).

duration(X,Y,1) :- cost(X,Y,_).

serviceTime(X,1) :- node(X).

timeLimit(20).
