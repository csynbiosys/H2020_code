function [model] = SBL_diff()
model.param = 'lin';
model.debug = false;
model.forward = true;
model.adjoint = true;

syms x1 x2 x3 x4 x5

model.sym.x = [x1 x2 x3 x4 x5];

syms p1_2 p1_7 p1_8 p1_9 p1_10 p1_11 p1_13 p1_14 p1_15 p1_21 p2_7 p2_8 p2_9 p2_10 p2_12 p2_13 p2_14 p2_15 p3_2 p3_5 p3_9 p4_5 p5_6 p5_9 p5_11 p5_15 p5_17 p5_18 p5_20 p5_21

model.sym.p = [p1_2 p1_7 p1_8 p1_9 p1_10 p1_11 p1_13 p1_14 p1_15 p1_21 p2_7 p2_8 p2_9 p2_10 p2_12 p2_13 p2_14 p2_15 p3_2 p3_5 p3_9 p4_5 p5_6 p5_9 p5_11 p5_15 p5_17 p5_18 p5_20 p5_21];

model.sym.xdot(1) = [+p1_2*x1+p1_7*x1*x1+p1_8*x1*x2+p1_9*x1*x3+p1_10*x1*x4+p1_11*x1*x5+p1_13*x2*x3+p1_14*x2*x4+p1_15*x2*x5+p1_21*x5*x5];
model.sym.xdot(2) = [+p2_7*x1*x1+p2_8*x1*x2+p2_9*x1*x3+p2_10*x1*x4+p2_12*x2*x2+p2_13*x2*x3+p2_14*x2*x4+p2_15*x2*x5];
model.sym.xdot(3) = [+p3_2*x1+p3_5*x4+p3_9*x1*x3];
model.sym.xdot(4) = [+p4_5*x4];
model.sym.xdot(5) = [+p5_6*x5+p5_9*x1*x3+p5_11*x1*x5+p5_15*x2*x5+p5_17*x3*x4+p5_18*x3*x5+p5_20*x4*x5+p5_21*x5*x5];
model.sym.x0 = [8.09091      46.4105      1.40694       39.685       16.393];

model.sym.y(1) = [x1];
model.sym.y(2) = [x2];
model.sym.y(3) = [x3];
model.sym.y(4) = [x4];
model.sym.y(5) = [x5];
