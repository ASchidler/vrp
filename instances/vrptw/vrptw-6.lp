% Case where the tour takes too long. This is unsat!
vehicle(a).vehicle(b).

cost(0,1,1).cost(1,2,1).cost(2,3,1).cost(3,0,1).
cost(1,4,1).cost(4,5,1).cost(5,0,2).
cost(X,Y,C) :- cost(Y,X,C).

duration(X,Y,1) :- cost(X,Y,_C).

available(1,2..5).available(2,4..7).available(3,6..9).
available(4,15..18).available(5,25..28).

serviceTime(X,1) :- node(X).

timeLimit(10).