use <../nscad-lib.scad>

color("lightgray") difference() {
  cylinder(r = 52, h = 3, $fn = 96);
  kranz(r15 = true, r30 = true, r45m8 = true);
}
