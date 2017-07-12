vehicle(a).vehicle(b).vehicle(c).

node(0).node(1).node(2).node(3).node(4).node(5).node(6).
cost(0,1,1).cost(1,2,1).cost(2,3,1).cost(3,0,1).
cost(0,4,1).cost(4,5,1).cost(5,6,1).cost(6,0,1).
cost(2,6,5).cost(5,3,5).
cost(X,Y,C) :- cost(Y,X,C).


duration(0,1,1).duration(1,2,1).duration(2,3,1).duration(3,0,1).
duration(0,4,1).duration(4,5,1).duration(5,6,1).duration(6,0,1).
duration(2,6,1).duration(5,3,1).
duration(X,Y,D) :- duration(Y,X,D).

available(1,2).available(1,3).available(1,4).
available(2,3).available(2,4).available(2,5).
available(3,8).available(3,9).available(3,10).

available(4,6).available(4,7).available(4,8).
available(5,7).available(5,8).available(5,9).
available(6,4).available(6,5).available(6,6).

