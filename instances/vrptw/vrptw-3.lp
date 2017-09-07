% Case where one node (3) is used multiple times, but to satisfy the window, it must be serviced the second time around
% Expected solution: 0 - 1 - 2 - 3 - 4 - 5 - 3 - 6 - 0
vehicle(a).

cost(0,1,1).cost(1,2,1).cost(2,3,1).cost(3,4,1).
cost(4,5,1).cost(5,3,1).cost(3,6,1).cost(6,0,1).
cost(X,Y,C) :- cost(Y,X,C).

duration(X,Y,1) :- cost(X,Y,_).

available(1,2).available(2,4).available(3,12).available(4,8).available(5,10).available(6,14).

serviceTime(X,1) :- node(X).

timeLimit(40).