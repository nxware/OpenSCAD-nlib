use <../nscad-lib.scad>

color("lightgray") difference() {
  cube([60, 30, 10]);
  move(10, 15)  m3hole();               // senkrecht
  move(-1, 7.5, 5) m3holeX(70);         // entlang X
  move(30, -1, 5)  m3holeY(40);         // entlang Y
  move(50, 15, 5)  m3hole(d = 6);       // anderer Durchmesser
}
