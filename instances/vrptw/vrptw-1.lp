% Extension of the simple cycle instance. Two cycles, but this time the two cycles are connected with higher cost edges
% Therefore the more cost reduced version would be to not use the edges. But the time windows make this necessary
% I.e. the expected cycles are: 1-2-6, 4-5-6. But a more efficient version exists: 0-6-5-4-5-3-0, 0-1-2-1-0; this only uses one high-cost edge
vehicle(a).vehicle(b).

cost(0,1,1).cost(1,2,1).cost(2,3,1).cost(3,0,1).
cost(0,4,1).cost(4,5,1).cost(5,6,1).cost(6,0,1).
cost(2,6,5).cost(5,3,5).
cost(X,Y,C) :- cost(Y,X,C).

duration(X,Y,1) :- cost(X,Y,_).

available(1,2).available(1,3).
available(2,4).available(2,5).
available(3,14).available(3,15).

available(4,10).available(4,11).
available(5,12).available(5,13).
available(6,6).available(6,7).

serviceTime(X,1) :- node(X).

timeLimit(10).
