use <../nscad-lib.scad>

color("lightgray") cube(10);
color("orange") move(20, 0, 5) cube(10);    // = translate([20,0,5])
color("orange") m(0, 20) cube(10);           // Kurzform
color("orange") moveR(1, 1, 3) cube(5);     // Rastereinheiten (7.5 mm)
