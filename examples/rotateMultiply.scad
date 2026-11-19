use <../nscad-lib.scad>

color("lightgray") cylinder(r = 25, h = 2, $fn = 64);
color("orange") rotateMultiply(x = 18, count = 6) cylinder(d = 6, h = 8, $fn = 32);
