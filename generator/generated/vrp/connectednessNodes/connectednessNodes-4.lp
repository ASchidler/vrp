timeLimit(14).
vehicle(v1).vehicle(v2).vehicle(v3).vehicle(v4).vehicle(v5).

serviceTime(0,0).serviceTime(n1,1).serviceTime(n2,1).serviceTime(n3,1).serviceTime(n4,1).serviceTime(n5,1).serviceTime(n6,1).

cost(0,n5,1).duration(0,n5,1).
cost(n5,0,1).duration(n5,0,1).
cost(n1,n4,1).duration(n1,n4,1).
cost(n4,n1,1).duration(n4,n1,1).
cost(n2,n6,1).duration(n2,n6,1).
cost(n6,n2,1).duration(n6,n2,1).
cost(n3,n6,1).duration(n3,n6,1).
cost(n6,n3,1).duration(n6,n3,1).
cost(n4,0,1).duration(n4,0,1).
cost(0,n4,1).duration(0,n4,1).
cost(n5,n4,1).duration(n5,n4,1).
cost(n4,n5,1).duration(n4,n5,1).
cost(n6,n2,1).duration(n6,n2,1).
cost(n2,n6,1).duration(n2,n6,1).
cost(0,n1,1).duration(0,n1,1).
cost(n1,0,1).duration(n1,0,1).
cost(n2,0,1).duration(n2,0,2).
cost(0,n2,1).duration(0,n2,2).
