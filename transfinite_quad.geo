// This geo script creates a transfinite (structured) quadrangular grid
// in the rectangular doamin. Boundary tags are shown in the sketch below.
//             3
//      ----------------
//      |              |
//      |              |
//   4  |              |  2
//      |              |
//      ---------------
//            1

lx = 1.3; // domain length in x-dir
ly = 0.5; // domain length in y-dir

nx = 260; // no of points in x-dir
ny = 100; // no of points in y-dir 

Point(1) = { 0,  0, 0};
Point(2) = {lx,  0, 0};
Point(3) = {lx, ly, 0};
Point(4) = {0, ly, 0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};

Transfinite Line{1,3} = nx;
Transfinite Line{2,4} = ny;
Transfinite Surface {1} = {1,2,3,4};
Recombine Surface {1};

Physical Line(1) = {1};  // x dir: left
Physical Line(2) = {2};  // x dir: right
Physical Line(3) = {3};  // y dir: bottom
Physical Line(4) = {4};  // y dir: top
Physical Surface(101) = {1};
