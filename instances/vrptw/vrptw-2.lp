% Double cycle example with one vehicle. The cycles are connected via higher cost edges.
% This instance tests, if the program finds solutions where a vehicle leaves multiple times
% Expected solution 0-1-2-3-0-4-5-6-0 (note that due to the time windows, the second cycle can be serviced in the opposite order as well. There is no optimization for time)

vehicle(a).

node(0).node(1).node(2).node(3).node(4).node(5).node(6).
cost(0,1,1).cost(1,2,1).cost(2,3,1).cost(3,0,1).
cost(0,4,1).cost(4,5,1).cost(5,6,1).cost(6,0,1).
cost(2,6,5).cost(5,3,5).
cost(X,Y,C) :- cost(Y,X,C).

duration(X,Y,1) :- cost(X,Y,_).

available(1,2).available(1,4).available(1,6).available(1,8).
available(2,4).available(2,6).available(2,8).available(2,10).
available(3,6).available(3,8).available(3,10).available(2,12).

available(4,9).available(4,11).available(4,13).available(4,15).
available(5,11).available(5,13).available(5,15).available(4,17).
available(6,13).available(6,15).available(6,17).available(4,19).

serviceTime(X,1) :- node(X).

timeLimit(40).