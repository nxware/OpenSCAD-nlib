use <../nscad-lib.scad>

color("lightgray") cube([20, 5, 2]);
color("red")   move(0, 30)  rx() cube([20, 5, 2]);     // rotate([90,0,0])
color("green") move(40, 30) ry() cube([20, 5, 2]);     // rotate([0,90,0])
color("blue")  move(40, 0)  rz(45) cube([20, 5, 2]);   // rotate([0,0,45])
