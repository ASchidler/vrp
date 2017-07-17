%In this instance there is a chokepoint at the depot, i.e. every vehicle must enter and exit the successor

vehicle(a).vehicle(b).
node(0).node(1).node(2).node(3).node(4).node(5).node(6).node(7).
cost(0,7,5).cost(7,1,5).cost(1,2,5).cost(2,3,5).cost(3,7,5).
cost(0,7,5).cost(7,4,5).cost(4,5,5).cost(5,6,5).cost(6,7,5).
cost(X,Y,C) :- cost(Y,X,C).