timeLimit(22).
vehicle(v1).

serviceTime(0,0).serviceTime(c1x1,1).available(c1x1,2).
serviceTime(c1x2,1).available(c1x2,4).
serviceTime(c1x3,1).available(c1x3,6).
serviceTime(c1x4,1).available(c1x4,8).
serviceTime(c1x5,1).available(c1x5,10).
serviceTime(c1x6,1).available(c1x6,12).
serviceTime(c1x7,1).available(c1x7,14).
serviceTime(c1x8,1).available(c1x8,16).
serviceTime(c1x9,1).available(c1x9,18).

serviceTime(c1x10,1).available(c1x10,20).


cost(0,c1x1,1).duration(0,c1x1,1).
cost(c1x1,0,1).duration(c1x1,0,1).
cost(c1x1,c1x2,1).duration(c1x1,c1x2,1).
cost(c1x2,c1x1,1).duration(c1x2,c1x1,1).
cost(c1x2,c1x3,1).duration(c1x2,c1x3,1).
cost(c1x3,c1x2,1).duration(c1x3,c1x2,1).
cost(c1x3,c1x4,1).duration(c1x3,c1x4,1).
cost(c1x4,c1x3,1).duration(c1x4,c1x3,1).
cost(c1x4,c1x5,1).duration(c1x4,c1x5,1).
cost(c1x5,c1x4,1).duration(c1x5,c1x4,1).
cost(c1x5,c1x6,1).duration(c1x5,c1x6,1).
cost(c1x6,c1x5,1).duration(c1x6,c1x5,1).
cost(c1x6,c1x7,1).duration(c1x6,c1x7,1).
cost(c1x7,c1x6,1).duration(c1x7,c1x6,1).
cost(c1x7,c1x8,1).duration(c1x7,c1x8,1).
cost(c1x8,c1x7,1).duration(c1x8,c1x7,1).
cost(c1x8,c1x9,1).duration(c1x8,c1x9,1).
cost(c1x9,c1x8,1).duration(c1x9,c1x8,1).
cost(c1x9,c1x10,1).duration(c1x9,c1x10,1).
cost(c1x10,c1x9,1).duration(c1x10,c1x9,1).
cost(c1x10,0,1).duration(c1x10,0,1).
cost(0,c1x10,1).duration(0,c1x10,1).
