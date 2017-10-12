timeLimit(3).
vehicle(v1).vehicle(v2).vehicle(v3).vehicle(v4).vehicle(v5).

serviceTime(0,0).serviceTime(n1,1).available(n1,1).available(n1,2).available(n1,3).available(n1,4).available(n1,5).available(n1,6).available(n1,7).available(n1,8).
serviceTime(n2,1).available(n2,1).available(n2,2).available(n2,3).available(n2,4).available(n2,5).available(n2,6).available(n2,7).available(n2,8).
serviceTime(n3,1).available(n3,1).available(n3,2).available(n3,3).available(n3,4).available(n3,5).available(n3,6).available(n3,7).available(n3,8).


cost(0,n1,1).duration(0,n1,1).
cost(n1,0,1).duration(n1,0,1).
cost(0,n2,1).duration(0,n2,1).
cost(n2,0,1).duration(n2,0,1).
cost(0,n3,1).duration(0,n3,1).
cost(n3,0,1).duration(n3,0,1).
cost(n1,n2,1).duration(n1,n2,1).
cost(n2,n1,1).duration(n2,n1,1).
cost(n1,n3,1).duration(n1,n3,1).
cost(n3,n1,1).duration(n3,n1,1).
cost(n2,n3,1).duration(n2,n3,1).
cost(n3,n2,1).duration(n3,n2,1).
