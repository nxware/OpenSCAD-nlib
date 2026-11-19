use <../nscad-lib.scad>

color("orange")    cube([10, 10, 7.5]);   // Referenz: Ecke im Ursprung
color("steelblue") move(30) cubec();       // XY zentriert
color("seagreen")  move(60) cubex();       // nur X zentriert
color("orchid")    move(80, -5) cube_rounded(20, 15, 7.5, r = 3);
color("red") for (x = [0, 30, 60, 80]) move(x) cylinder(d = 1.5, h = 12, $fn = 12); // Ursprung
