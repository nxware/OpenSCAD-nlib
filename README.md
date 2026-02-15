
# Utils

```
 m(x,y,z)
```
Moves an objekt to (x,y,z) instead of `translate([x,y,z])`.

Shortcut: `for(i=[0,10])translate([i, 0, 0])cylinder(d=3,h=10);` -> `m([0,10])cylinder(d=3,h=10);`
