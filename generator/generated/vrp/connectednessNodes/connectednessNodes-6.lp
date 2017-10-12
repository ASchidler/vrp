timeLimit(18).
vehicle(v1).vehicle(v2).vehicle(v3).vehicle(v4).vehicle(v5).

serviceTime(0,0).serviceTime(n1,1).serviceTime(n2,1).serviceTime(n3,1).serviceTime(n4,1).serviceTime(n5,1).serviceTime(n6,1).serviceTime(n7,1).serviceTime(n8,1).

cost(0,n7,1).duration(0,n7,1).
cost(n7,0,1).duration(n7,0,1).
cost(n1,n5,1).duration(n1,n5,1).
cost(n5,n1,1).duration(n5,n1,1).
cost(n2,n4,1).duration(n2,n4,1).
cost(n4,n2,1).duration(n4,n2,1).
cost(n3,n4,1).duration(n3,n4,1).
cost(n4,n3,1).duration(n4,n3,1).
cost(n4,n6,1).duration(n4,n6,1).
cost(n6,n4,1).duration(n6,n4,1).
cost(n5,n1,1).duration(n5,n1,1).
cost(n1,n5,1).duration(n1,n5,1).
cost(n6,n3,1).duration(n6,n3,1).
cost(n3,n6,1).duration(n3,n6,1).
cost(n7,n5,1).duration(n7,n5,1).
cost(n5,n7,1).duration(n5,n7,1).
cost(n8,0,1).duration(n8,0,1).
cost(0,n8,1).duration(0,n8,1).
cost(n6,n7,1).duration(n6,n7,1).
cost(n7,n6,1).duration(n7,n6,1).
