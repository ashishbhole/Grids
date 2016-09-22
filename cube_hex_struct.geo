// This geo script is taken from following blog 
// http://matveichev.blogspot.in/2013/12/building-hexagonal-meshes-with-gmsh.html
// it is very nice gmsh article cum tutorial specially for structured hex meshes

lc = 1.0;  //characteristic length, if required
np = 10;  // no of point on each edge

Point(1) = {0, 0, 0, lc};
Point(2) = {1, 0, 0, lc};
Point(3) = {0, 1, 0, lc};
Point(4) = {1, 1, 0, lc};
Point(5) = {1, 1, 1, lc};
Point(6) = {1, 0, 1, lc};
Point(7) = {0, 1, 1, lc};
Point(8) = {0, 0, 1, lc};

Line(1) = {3, 7};
Line(2) = {7, 5};
Line(3) = {5, 4};
Line(4) = {4, 3};
Line(5) = {3, 1};
Line(6) = {2, 4};
Line(7) = {2, 6};
Line(8) = {6, 8};
Line(9) = {8, 1};
Line(10) = {1, 2};
Line(11) = {8, 7};
Line(12) = {6, 5};

Line Loop(13) = {7, 8, 9, 10};
Plane Surface(14) = {13};
Line Loop(15) = {6, 4, 5, 10};
Plane Surface(16) = {15};
Line Loop(17) = {3, 4, 1, 2};
Plane Surface(18) = {17};
Line Loop(19) = {12, -2, -11, -8};
Plane Surface(20) = {19};
Line Loop(21) = {7, 12, 3, -6};
Plane Surface(22) = {21};
Line Loop(23) = {9, -5, 1, -11};
Plane Surface(24) = {23};
Surface Loop(25) = {14, 22, 20, 18, 16, 24};

Volume(26) = {25};

Transfinite Line "*" = np; 
Transfinite Surface "*";
Recombine Surface "*";
Transfinite Volume "*";

Physical Volume(1) = {26};
Physical Surface(101) = {16};
Physical Surface(102) = {20};
Physical Surface(103) = {14};
Physical Surface(104) = {18}; 
Physical Surface(105) = {22};
Physical Surface(106) = {24};
