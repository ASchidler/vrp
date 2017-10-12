timeLimit(3).
vehicle(v1).vehicle(v2).vehicle(v3).vehicle(v4).vehicle(v5).

serviceTime(0,0).serviceTime(n1,1).serviceTime(n2,1).serviceTime(n3,1).

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
