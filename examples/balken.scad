use <../nscad-lib.scad>

color("orange") balken(5);
color("steelblue") move(0, 15) balken(5, boden = 1);
color("seagreen")  move(0, 30) balken(3, xr = false, yr = false);
