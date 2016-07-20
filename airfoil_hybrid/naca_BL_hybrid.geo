Mesh.RecombinationAlgorithm = 0;

Li = 50.0; Lo = 50.0; // distance of inflow and outflow boundary from origin

n  = 50; // points on upper/lower surface of airfoil used to define airfoil
         // These points may not appear in the mesh.

lc1 = 10.0; lc2 = 0.05; // characteristic lengths of elements on airfoil and at farfield

m = 2*n - 2; // total number of points on airfoil without repetition
             // LE and TE points are common to upper/lower surface

nle = n; // point number of LE = no. of points on upper surface
         // Point(1) is trailing edge

// NACA0012 profile: formula taken from http://turbmodels.larc.nasa.gov/naca0012_val.html
Macro NACA0012
   x2 = x * x;
   x3 = x * x2;
   x4 = x * x3;
   y = 0.594689181*(0.298222773*Sqrt(x) 
       - 0.127125232*x - 0.357907906*x2 + 0.291984971*x3 - 0.105174606*x4);
Return

// put points on upper surface of airfoil
For i In {1:n}
   theta = Pi * (i-1) / (n-1);
   x = 0.5 * (Cos(theta) + 1.0);
   Call NACA0012;
   Point(i) = {x, y, 0.0, lc2};
   xx[i] = x;
   yy[i] = y;
EndFor

// put points on lower surface of airfoil, use upper surface points and reflect
For i In {n+1:m}
   Point(i) = {xx[2*n-i], -yy[2*n-i], 0.0, lc2};
EndFor

Line(1) = {1:n}; Line(2) = {n:m,1};

Transfinite Line{1,2} = n Using Bump 0.1;

Point(1001) = { 0.0, Li, 0.0, lc1};
Point(1002) = { 0.0, -Li, 0.0,lc1};
Point(1003) = {Lo, -Li, 0.0,lc1};
Point(1004) = {Lo, Li, 0.0,lc1};

Line(3) = {1004, 1001};
Circle(4) = {1001, nle, 1002};
Line(5) = {1002, 1003};
Line(6) = {1003, 1004};

Line Loop(1) = {1,2};
Line Loop(2) = {3,4,5,6};

Plane Surface(201) = {2,1};

//Define Boundary Layer
Field[1] = BoundaryLayer;
Field[1].EdgesList = {1,2};
Field[1].FanNodesList = {1,m};
Field[1].hfar = 0.05;
Field[1].hwall_n = 0.0005;
Field[1].thickness = 0.02;
Field[1].ratio = 1.1;
Field[1].AnisoMax = 10;
Field[1].Quads = 1;
Field[1].IntersectMetrics = 0;
BoundaryLayer Field = 1;

//Box field near trailing edge
Field[2] = Box;
Field[2].VOut = lc1;
Field[2].VIn = 0.2*lc2;
Field[2].XMax = 5.0;
Field[2].XMin = 0.9;
Field[2].YMax = 0.05;
Field[2].YMin = -0.05;

//1st Box field: surrounding airfoil
Field[3] = Box;
Field[3].VOut = lc1;
Field[3].VIn = 0.4*lc2;
Field[3].XMax = 10.0;
Field[3].XMin = -0.15;
Field[3].YMax = 0.2;
Field[3].YMin = -0.2;
 
//Box field surrouding 1st box field 
Field[6] = Box;
Field[6].VOut = lc1;
Field[6].VIn = 0.8*lc2;
Field[6].XMax = Lo;
Field[6].XMin = -1;
Field[6].YMax = 1.0;
Field[6].YMin = -1.0;

// Background fields against which other fields are defined
Field[10] = Min;
Field[10].FieldsList = {2,3,6};
Background Field = 10;

//Color Purple{ Surface{ 201 }; }
