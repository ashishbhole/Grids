// This geo script generates unstructured 2D quad (C) mesh around airfoil with a Boundary Layer. 
// The airfoil equations are taken from following link: 
// https://how4.cenaero.be/content/bl1-laminar-joukowski-airfoil-re1000
// This airfoil equation corresponds to so called 'Challenge' distribution of Joukowski airfoil, as specified in link.
// Use of Box field unables to make dense mesh in wake region. 
// User can modify this script to generate hybrid mesh in last few lines by chossing desired algorithms.
// Also this script may be used for any airfoil given equation of airfoil or coordinates explicitely.
// This script is generated and tested on 2.12 version of gmsh.

Li = 50.0; Lo = 50.0; // distance of inflow and outflow boundary from origin

n  = 50; // points on upper/lower surface of airfoil used to define airfoil
         // These points may not appear in the mesh.

lc1 = 10.0; lc2 = 0.5; // characteristic lengths of elements on airfoil and at farfield

m = 2*n - 2; // total number of points on airfoil without repetition
             // LE and TE points are common to upper/lower surface

nle = n; // point number of LE = no. of points on upper surface
         // Point(1) is trailing edge

// Joukowski profile
Macro Joukowski

   d = 1.0 + 2.0*a*(1.0+a)*(1.0+Cos(Pi*s));

   x = (1.0 + a*(1+2.0*a)*(1.0+Cos(Pi*s))) * Sin(Pi*s/2.0)*Sin(Pi*s/2.0);
   x = x/d;

   y = 0.5*a*(1+2.0*a)*(1.0+Cos(Pi*s)) * Sin(Pi*s);
   y = y/d;

Return

// put points on upper surface of airfoil
For i In {1:n}
   a = 0.1;
   ds0 = -0.2;
   ds1 = -0.2;

   P0 = 1.0;
   P1 = (3.0 + ds1)/3.0;
   P2 = -ds0/3.0;

   s0 = (i-1)*(1.0/(n-1));
   s = P0*(1.0-s0)*(1.0-s0)*(1.0-s0) + 3.0*P1*s0*(1.0-s0)*(1.0-s0) + 3.0*P2*s0*s0*(1.0-s0);

   Call Joukowski;

   Point(i) = {x, y, 0.0, lc2};
   xx[i] = x;
   yy[i] = y;
EndFor

// put points on lower surface of airfoil, use upper surface points and reflect
For i In {n+1:m}
   Point(i) = {xx[2*n-i], -yy[2*n-i], 0.0, lc2};
EndFor

Spline(1) = {1:n}; Spline(2) = {n:m,1};

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
Field[1].FanNodesList = {1};
Field[1].hfar = 0.05;
Field[1].hwall_n = 0.0008;
Field[1].thickness = 0.1;
Field[1].ratio = 1.2;
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

//Recombine Surface{201};
//Mesh.Algorithm = 5;
Mesh.RecombinationAlgorithm = 1;
Mesh.SubdivisionAlgorithm = 1;
//Mesh.RecombineAll = 1;
//Mesh.Smoothing = 5;
