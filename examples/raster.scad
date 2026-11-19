use <../nscad-lib.scad>

color("lightgray") difference() {
  cube([45, 30, 3]);
  move(3.75, 3.75, -5) raster(6, 4);
}
