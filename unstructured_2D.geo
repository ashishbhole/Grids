// This geo script creates an unstructured triangular/quadrangular grid
// in the rectangular doamin. Boundary tags are shown in the sketch below.
// Recombine Surface{1}; creates a quadrangular grid. Commenting this line
// generates a traingular grid.
//
//
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

n1 = nx/lx;
n2 = ny/ly;

lc = 0.5*(1.0/n1 + 1.0/n2); // characteristic length

// choice of meshing algorithm: default is 2
Mesh.Algorithm = 1; // 1 = MeshAdapt, 2 = Automatic, 5 = Delaunay, 6 = Frontal, 7 = BAMG, 8 = DelQuad
Mesh.SubdivisionAlgorithm = 0; // 0=none, 1=all quadrangles, 2=all hexahedra. Default = 0.
Mesh.RecombinationAlgorithm = 1; // 0=standard, 1=blossom. Default = 1.

Point(1) = { 0,  0, 0, lc};
Point(2) = {lx,  0, 0, lc};
Point(3) = {lx, ly, 0, lc};
Point(4) = {0,  ly, 0, lc};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};

Transfinite Line{1,3} = nx;
Transfinite Line{2,4} = ny;
//Recombine Surface {1};

Physical Line(1) = {1};  // x dir: left
Physical Line(2) = {2};  // x dir: right
Physical Line(3) = {3};  // y dir: bottom
Physical Line(4) = {4};  // y dir: top
Physical Surface(101) = {1};
