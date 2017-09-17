timeLimit(20).
vehicle(v).

serviceTime(0,0).serviceTime(n1,1).available(n1,2).
serviceTime(n2,1).available(n2,4).
serviceTime(n3,1).available(n3,6).
serviceTime(n4,1).available(n4,8).
serviceTime(n5,1).available(n5,10).


cost(0,n1,1).duration(0,n1,1).
cost(n1,0,1).duration(n1,0,1).
cost(n1,n2,1).duration(n1,n2,1).
cost(n2,n1,1).duration(n2,n1,1).
cost(n2,n3,1).duration(n2,n3,1).
cost(n3,n2,1).duration(n3,n2,1).
cost(n3,n4,1).duration(n3,n4,1).
cost(n4,n3,1).duration(n4,n3,1).
cost(n4,n5,1).duration(n4,n5,1).
cost(n5,n4,1).duration(n5,n4,1).
cost(n5,0,1).duration(n5,0,1).
cost(0,n5,1).duration(0,n5,1).
